----------------------- MODULE ParallelClockWithPlusCal -------------------------
EXTENDS Naturals


(* --algorithm Clock
variable hr \in (1..12); min \in (1..60); tick_from = 0;

define
  ValidSemantic == hr \in (1..12) /\ min \in (1..60)
  HourTickPerCycleOfMin == (tick_from = 0 => min = 60)
end define;

fair process hour = 0
begin
  Tick_Hr_hand:
    while TRUE do
      await min = 60;

      if hr # 12 then
        hr := hr + 1;
      else
        hr := 1;
      end if;

      tick_from := 1;

    end while;

end process;

fair process min = 1
begin
  Tick_min_hand:
    while TRUE do
      await min # 60;
      min := min + 1;

      tick_from := 0;
    end while;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "c9097e5c" /\ chksum(tla) = "7316423f")
\* Process min at line 31 col 6 changed to min_
VARIABLES hr, min, tick_from

(* define statement *)
ValidSemantic == hr \in (1..12) /\ min \in (1..60)
HourTickPerCycleOfMin == (tick_from = 0 => min = 60)


vars == << hr, min, tick_from >>

ProcSet == {0} \cup {1}

Init == (* Global variables *)
        /\ hr \in (1..12)
        /\ min \in (1..60)
        /\ tick_from = 0

hour == /\ min = 60
        /\ IF hr # 12
              THEN /\ hr' = hr + 1
              ELSE /\ hr' = 1
        /\ tick_from' = 1
        /\ min' = min

min_ == /\ min # 60
        /\ min' = min + 1
        /\ tick_from' = 0
        /\ hr' = hr

Next == hour \/ min_

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(hour)
        /\ WF_vars(min_)

\* END TRANSLATION 

=================================================================================
