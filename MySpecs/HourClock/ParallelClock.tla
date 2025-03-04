------------------- MODULE ParallelClock -------------------
EXTENDS Naturals
VARIABLES hr,min,tick_from

\* Actions
HCinit == hr \in (1..12) /\ min \in (1..60) /\ tick_from = 0

Tick_hr ==
    /\ min = 60
    /\ hr' = IF hr # 12
             THEN hr + 1
             ELSE 1
    /\ tick_from' = 1
    /\ UNCHANGED <<min>>
Tick_min ==
    /\ min # 60
    /\ min' = min + 1
    /\ tick_from' = 0
    /\ UNCHANGED <<hr>>

HCnext == Tick_min \/ Tick_hr
HC == HCinit /\ [][HCnext]_<<hr,min,tick_from>> /\ WF_<<hr,min,tick_from>>(Tick_hr) /\ WF_<<hr,min,tick_from>>(Tick_min)

\* Properties
HourTickValidity == [](tick_from = 1 => min = 60)
============================================================
