EXTEND_BOTTOM TAEROM 0
+ ~PartyHasItem("c0mskin")~ + ~其实，我想请你看看这个。这是一张红熊的皮。~ EXTERN TAEROM a1
END

EXTEND_BOTTOM TAEROM 4
+ ~PartyHasItem("c0mskin")~ + ~其实，我想请你看看这个。这是一张红熊的皮。~ EXTERN TAEROM a1
END

EXTEND_BOTTOM TAEROM 8
+ ~PartyHasItem("c0mskin")~ + ~想请你看看这个。这是一张红熊的皮。~ EXTERN TAEROM a1
END

EXTEND_BOTTOM TAEROM 12
+ ~PartyHasItem("c0mskin")~ + ~其实，我想请你看看这个。这是一张红熊的皮。~ EXTERN TAEROM a1
END

EXTEND_BOTTOM TAEROM 14
+ ~PartyHasItem("c0mskin")~ + ~想请你看看这个。这是一张红熊的皮。~ EXTERN TAEROM a1
END

CHAIN TAEROM a1
~这是什么？啊，确实是块上好的料子。我不是鞣皮匠，但也看得出来这皮异常坚韧，能打造出一副结实的护甲。我可以用这张皮给你做一件皮甲，工钱六千金币。~
END
+ ~PartyGoldGT(2999)~ + ~泰罗姆·雷霆锤的手艺，这个价钱公道。就六千金币。~ + a2
++ ~价钱是公道，可我现在带的钱不够。~ + a3

CHAIN TAEROM a2
~好眼光。这活儿得花些时日，不过很快你就能拿到贝尔苟斯特最上乘的护甲，就算放眼整个剑湾也数得上。五天后再来，我就给你备好。~
DO ~TakePartyGold(6000)
TakePartyItem("c0mskin")
DestroyItem("c0mskin")
SetGlobal("C0TaeromMakeArmor","GLOBAL",1)
SetGlobalTimer("C0TaeromArmorTimer","GLOBAL",FIVE_DAYS)~ EXIT

CHAIN TAEROM a3
~随你便。你随时可以改主意。~
EXIT

CHAIN IF WEIGHT #-1 ~!GlobalTimerExpired("C0TaeromArmorTimer","GLOBAL")
Global("C0TaeromMakeArmor","GLOBAL",1)~ THEN TAEROM b1
~还没做好呢。估计还得一两天。耐心点，好货得花功夫。~
COPY_TRANS TAEROM 8

CHAIN IF WEIGHT #-1 ~GlobalTimerExpired("C0TaeromArmorTimer","GLOBAL")
Global("C0TaeromMakeArmor","GLOBAL",1)~ THEN TAEROM c1
~啊，你回来了。这就是我答应你的东西。漂亮吧？我可有日子没做出这么好的护甲了。好好穿。~
DO ~SetGlobal("C0TaeromMakeArmor","GLOBAL",2)
GiveItemCreate("c0mleat",LastTalkedToBy(Myself),1,0,0)
DestroyItem("MISC12")~ EXIT