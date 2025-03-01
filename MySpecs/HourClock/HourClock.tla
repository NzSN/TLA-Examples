---------------- MODULE HourClock ---------------------
EXTENDS Naturals
VARIABLE hr

HCinit == hr \in (1..12)
HCnext == hr' = IF hr # 12 THEN hr + 1 ELSE hr

HC == HCinit /\ [][HCnext]_<<hr>>
=======================================================
