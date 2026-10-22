CHAIN IF WEIGHT #-1 ~Global("C0SamuraiRegainKit","GLOBAL",1)~ THEN PLAYER1 samurai-d
~你守卫要塞、公正治领的功绩，已然尽到了分内之责。经此种种，你相信自己足以重拾失落的荣誉。你可愿再度成为一名武士？

这是你绝无仅有的机会。三思而行！~
DO ~IncrementGlobal("C0SamuraiRegainKit","GLOBAL",1)~
END
  + ~Alignment(Player1,MASK_GOOD)~ + ~我愿重拾武士的能力。~ DO ~ChangeAlignment(Player1,LAWFUL_GOOD) AddKit(C0_SAMURAI)~ EXIT
  + ~Alignment(Player1,MASK_GENEUTRAL)~ + ~我愿重拾武士的能力。~ DO ~ChangeAlignment(Player1,LAWFUL_NEUTRAL) AddKit(C0_SAMURAI)~ EXIT
  + ~Alignment(Player1,MASK_EVIL)~ + ~我愿重拾武士的能力。~ DO ~ChangeAlignment(Player1,LAWFUL_EVIL) AddKit(C0_SAMURAI)~ EXIT
  ++ ~不了。事已至此，我便继续做一名浪人。~ EXIT