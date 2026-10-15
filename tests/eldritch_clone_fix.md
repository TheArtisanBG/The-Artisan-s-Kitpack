# Eldritch Knight image armour-casting regression

The callback is shared by the Fighter/Mage and Sorcerer variants. The shared
installer runs only with EEex and adds at most one callback per image spell,
including when both kit components are installed in separate setup runs.

## Reproduction

1. Use a Sorcerer Eldritch Knight with Battle Caster and memorized/available
   Project Image and Simulacrum. Equip ordinary plate armour.
2. Cast either image spell and select the image.
3. Before the fix, wizard spells are greyed out. Removing the original's armour
   before creating the image allows casting.

## Observed cause and correction

The image retains permanent opcode 318 protection for `C0ARCAS1` / `C0ARCAS2`, yet
can also retain an equipped opcode 177 referencing the protected armour EFF.
The callback marks only that conflicting equipped effect for normal engine
cleanup. It does not unlink or free list nodes, modify spell counts, grant a new
armour exemption, or force an effect-processing repass.

## Native validation

Tested in an independent copied BG2EE 2.6.6 EET installation with EEex, Artisan's
Kitpack and SCS. The actual level-18 Sorcerer Eldritch Knight wore `PLAT01`.

| Check | Before | After |
|---|---:|---:|
| Project Image disabled spell buttons | 31 | 0 |
| Simulacrum disabled spell buttons | 22 | 0 |

Both images completed an ordinary Magic Missile cast and spent one of their own
uses (4 to 3); the original retained 4. The Simulacrum remained level 11 with its
22-spell selection. An unrelated timed wizard-casting-disable effect continued to
disable spells. Removing inherited Battle Caster protection and adding the heavy
armour restriction left the Simulacrum restricted. Uninstall restored both image
initialization spells byte-for-byte.

Run the portable callback guard tests with Lua 5.1 / LuaJIT:

```sh
lua5.1 tests/eldritch_clone_fix.lua ArtisansKitpack/eeex/M_EKCF.lua
```

The callback tests cover both kit symbols, Project Image, Simulacrum, exclusion of
Mislead and non-image actors, missing/mismatched/conditional/temporary exemptions,
unrelated effects, spell-source effects, and case-insensitive restriction names.

The shared WeiDU helper was also installed twice in a private integration harness:
each initialization spell contained exactly one new callback, with all existing
effects byte-identical. Its output matched the live-tested standalone fix. With
the EEex loader resource absent, the same helper changed neither spell and added
no Lua callback.

The native runtime evidence applies to the tested installed combination. A fresh
whole-kit installation on every supported game, multiplayer, and every equipment
combination have not been validated. The Fighter/Mage variant is covered by guard
tests; the reported native reproduction was the Sorcerer variant.
