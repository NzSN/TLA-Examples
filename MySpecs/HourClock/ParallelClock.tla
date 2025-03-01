------------------- MODULE ParallelClock -------------------
EXTENDS Naturals
VARIABLES hr,min

\* Actions
HCinit == hr \in (1..12) /\ min \in (1..60)

Tick_hr ==
    /\ min = 60
    /\ hr' = IF hr # 12
             THEN hr + 1
             ELSE 1
    /\ UNCHANGED <<min>>
Tick_min ==
    /\ min # 60
    /\ min' = min + 1
    /\ UNCHANGED <<hr>>

HCnext == Tick_min \/ Tick_hr
HC == HCinit /\ [][HCnext]_<<hr,min>> /\ WF_<<hr,min>>(Tick_hr) /\ WF_<<hr,min>>(Tick_min)

\* Properties
EventuallyTick == []<>(hr = 12)
HourTickValidity == [](ENABLED Tick_hr => min = 60)
============================================================
