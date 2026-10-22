CHAIN IF ~Global("C0MinscBearskin","GLOBAL",1)~ THEN MINSCJ a1
~啊，这皮子真上乘，对吧，布布？明斯克还记得，在老家拉施曼，工匠能用这样的兽皮打造出各式绝妙的好物。~
DO ~SetGlobal("C0MinscBearskin","GLOBAL",2)~
== MINSCJ ~要是能回老家就好了。明斯克就能换双新靴子啦！哈！~
== DYNAHJ IF ~IsValidForPartyDialogue("DYNAHEIR")~ THEN ~或许我们在这片土地上，也能找到精通这种材料加工的工匠。~
EXIT