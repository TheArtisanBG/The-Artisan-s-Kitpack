# Sorcerer Arcane Trickster backstab regression

The sorcerer kit defines its own `BACKSTAB.2DA` progression: x2 at levels 1-9,
x3 at 10-17 and x4 from 18. Its level-one `C0ATR00` and level-thirteen
`C0ATR03` passives also applied additive -1 backstab modifiers (opcode 263).
That produced x1 at levels 1-9, x2 at 10-12, x1 at 13-17, and x2 from 18.

The resource installer now creates private sorcerer passives `C0ATS00` and
`C0ATS03` without these two modifiers, redirects only `C0ATRSO.2DA`, and
updates the private level-thirteen spell's self-removal reference. Other
effects are preserved. It does not replace the mage/thief's shared
`C0ATR00`/`C0ATR03` resources with the sorcerer versions.

Run from the repository root with Python 3 and a native WeiDU executable:

```
python ArtisansKitpack/tests/test_sorcerer_backstab.py --weidu PATH_TO_WEIDU
```

The test executes the same resource-install fragment included by the kit,
checks native install/uninstall, both resource installation orders, all 50
progression levels, and compares retained spell effects byte for byte.
It uses the mod's own assets and a generated empty game fixture. Python is
only needed for this development test, not to install or use the kit.

Observed reproduction in an EET/EEex game: level-14 Nalia, kit
`C0_ARCANE_TRICKSTER_SORC`, had a live multiplier of x1 and additive modifier
-2, with one permanent -1 effect from each source spell in her saved CRE.
The test does not automate attacks, positioning, or target immunity.

Existing saves keep previously applied permanent effects. This source fix
does not migrate saves automatically. Repair those saved effects separately:
only on sorcerer Arcane Tricksters, neutralize the additive -1 opcode-263
records from `C0ATR00` and `C0ATR03`; preserve unrelated backstab modifiers.
Updating spell files alone does not remove already serialized penalties.
