----------------- MODULE Clock -----------------------
EXTENDS Naturals, Sequences
VARIABLE hr,min


Tick == /\ min' = min + 1
        /\ hr' = IF min = 59
                 THEN IF hr # 12 THEN hr + 1 ELSE 1
                 ELSE hr

HCinit == hr \in (1..12) /\ min \in (1..60)
HCnext ==
  /\ IF min # 60
     THEN Tick
     ELSE min' = 1 /\ hr' = hr

HC == HCinit /\ [][HCnext]_<<hr,min>>
======================================================
