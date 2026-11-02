"""Test the resource-install fragment with native WeiDU; no game data required.

python ArtisansKitpack/tests/test_sorcerer_backstab.py --weidu PATH_TO_WEIDU
"""
import argparse
from pathlib import Path
import re
import shutil
import struct
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[2]
U16 = lambda b, o: struct.unpack_from('<H', b, o)[0]
U32 = lambda b, o: struct.unpack_from('<I', b, o)[0]


def effects(b):
    result = []
    for i in range(U16(b, 0x68)):
        h = U32(b, 0x64) + i * 40
        result.append([b[U32(b, 0x6a) + j * 48:U32(b, 0x6a) + (j + 1) * 48]
                       for j in range(U16(b, h + 32), U16(b, h + 32) + U16(b, h + 30))])
    return result


def check_private(game):
    spells = ROOT/'ArtisansKitpack/Sorcerer/Arcane_Trickster/spells'
    for old, new in [('c0atr00', 'c0ats00'), ('c0atr03', 'c0ats03')]:
        original = (spells/(old+'.spl')).read_bytes()
        out = (game/'override'/(new+'.spl')).read_bytes()
        expected = []
        for fx in effects(original):
            kept = []
            for e in fx:
                if (U16(e, 0), U32(e, 4), U32(e, 8)) == (263, 0xffffffff, 0):
                    continue
                if U16(e, 0) == 321 and e[20:28].rstrip(b'\0').upper() == b'C0ATR03':
                    e = e[:20] + b'C0ATS03\0' + e[28:]
                kept.append(e)
            expected.append(kept)
        assert effects(out) == expected
        assert out[:0x64] == original[:0x64]
    table = (game/'override/c0atrso.2da').read_text().upper()
    assert 'AP_C0ATS00' in table and 'AP_C0ATS03' in table
    assert 'AP_C0ATR00 ' not in table and 'AP_C0ATR03 ' not in table


def main():
    p = argparse.ArgumentParser(); p.add_argument('--weidu', type=Path, required=True)
    weidu = p.parse_args().weidu.resolve()
    source = ROOT/'ArtisansKitpack'
    sorc_tpa = (source/'lib/Arcane_Trickster_Sorc.tpa').read_text()
    assert 'INCLUDE ~%MOD_FOLDER%/lib/arcane_trickster_sorc_resources.tpa~' in sorc_tpa
    progression = list(map(int, re.search(r'^\s*backstab\s*=\s*~([^~]+)~', sorc_tpa, re.M)[1].split()))
    for level in range(1, 51):
        assert progression[level] == (2 if level < 10 else 3 if level < 18 else 4)
    for mage_first in [False, True]:
        with tempfile.TemporaryDirectory(prefix='artisan-sorc-backstab-') as tmp:
            game = Path(tmp); (game/'override').mkdir(); (game/'lang/en_US').mkdir(parents=True)
            (game/'chitin.key').write_bytes(b'KEY V1  '+struct.pack('<IIII',0,0,24,24))
            (game/'lang/en_US/dialog.tlk').write_bytes(b'TLK V1  '+struct.pack('<HII',0,0,18))
            (game/'engine.lua').write_text('engine_name = "Baldur\'s Gate II - Enhanced Edition"\nengine_mode = 1\n')
            (game/'weidu.conf').write_text('lang_dir = en_US\n')
            (game/'ArtisansKitpack/lib').mkdir(parents=True)
            for name in ['Sorcerer/Arcane_Trickster', 'MultiKit/Arcane_Trickster']:
                shutil.copytree(source/name, game/'ArtisansKitpack'/name)
            shutil.copy2(source/'lib/arcane_trickster_sorc_resources.tpa', game/'ArtisansKitpack/lib')
            shared = {n: (source/'MultiKit/Arcane_Trickster/spells'/n).read_bytes()
                      for n in ['c0atr00.spl', 'c0atr03.spl']}
            if mage_first:
                for n, b in shared.items(): (game/'override'/n).write_bytes(b)
            (game/'test.tp2').write_text('BACKUP ~backup~\nAUTHOR ~test~\nBEGIN ~sorcerer resources~\nOUTER_SPRINT MOD_FOLDER ~ArtisansKitpack~\nINCLUDE ~ArtisansKitpack/lib/arcane_trickster_sorc_resources.tpa~\n')
            args = [str(weidu), 'test.tp2', '--language', '0', '--noautoupdate', '--no-exit-pause', '--skip-at-view']
            def run(option):
                r = subprocess.run(args+[option,'0'], cwd=game, input=b'', capture_output=True)
                log = (r.stdout+r.stderr).decode(errors='replace')
                assert r.returncode == 0 and 'FATAL ERROR' not in log, log[-5000:]
            run('--force-install-list'); check_private(game)
            for n,b in shared.items():
                path = game/'override'/n
                assert (path.exists() and path.read_bytes() == b) if mage_first else not path.exists()
            run('--force-uninstall-list')
            for n in ['c0ats00.spl','c0ats03.spl','c0atrso.2da']: assert not (game/'override'/n).exists()
            if mage_first:
                assert all((game/'override'/n).read_bytes() == b for n,b in shared.items())
            # The reverse order must also leave the private sorcerer passives intact.
            run('--force-install-list')
            for n,b in shared.items(): (game/'override'/n).write_bytes(b)
            check_private(game)
    print('PASS: native WeiDU install/uninstall, both kit resource orders, all 50 progression levels, and retained effects checked byte-for-byte.')


if __name__ == '__main__': main()
