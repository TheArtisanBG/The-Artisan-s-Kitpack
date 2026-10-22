BEGIN C0FS#06

CHAIN IF WEIGHT #-1 ~True()~ THEN C0FS#06 miracle
~你感受到神祇的目光落在了你身上。只需一语，便可祈求一项神恩相助。~
END
IF ~CheckStatLT(LastTalkedToBy,10,CHR)~ DO ~SetupWish(4,4)~ + miracle1
IF ~CheckStatGT(LastTalkedToBy,9,CHR)
    CheckStatLT(LastTalkedToBy,18,CHR)~ DO ~SetupWish(4,3)~ + miracle2
IF ~CheckStatGT(LastTalkedToBy,17,CHR)
    CheckStatLT(LastTalkedToBy,23,CHR)~ DO ~SetupWish(4,2)~ + miracle3
IF ~CheckStatGT(LastTalkedToBy,22,CHR)~ DO ~SetupWish(4,1)~ + miracle4

CHAIN C0FS#06 miracle1
~你信心不足，不禁怀疑神祇是否会真正降下恩惠庇佑你。~
EXTERN C0FS#06 miracle5

CHAIN C0FS#06 miracle2
~你对神明的虔敬让你有理由相信，所得之物必有裨益，只是能否扭转局势犹未可知。~
EXTERN C0FS#06 miracle5

CHAIN C0FS#06 miracle3
~你有信心能说服神祇赐予你一份举足轻重的馈赠。不过话说回来，这种事从来都说不准。~
EXTERN C0FS#06 miracle5

CHAIN C0FS#06 miracle4
~你超凡的人格魅力让你确信，神祇定会厚赐于你，哪怕馈赠未必完全如你所愿。~
EXTERN C0FS#06 miracle5

CHAIN C0FS#06 miracle5
~无论如何，祈愿已然许下，你必须接受结果。你要选择什么？~
COPY_TRANS WISH25 12