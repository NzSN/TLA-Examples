-------------------------- MODULE AsyncInterface --------------------------
EXTENDS Naturals
CONSTANT Data
VARIABLES chan

TypeInvariant == chan \in [val:Data, rdy:{0,1}, ack:{0,1}]
----------------------------------------------------------------------------
Init == /\ TypeInvariant
        /\ chan.ack = chan.rdy
Send(d) == /\ chan.rdy = chan.ack
           /\ chan' = [chan EXCEPT !.val = d, !.rdy = 1 - @]
Rcv == /\ chan.rdy # chan.ack
       /\ chan' = [chan EXCEPT !.ack = 1 - @]
Next == (\exists d \in Data: Send(d)) \/ Rcv
Spec == Init /\ [][Next]_<<chan>>
-------------------------------------------------------------
TypeInvar == TypeInvariant

\* TLC ignore THEMORE so for reader only
THEOREM Spec => []TypeInvariant
=============================================================================
\* Modification History
\* Last modified Fri Aug 18 11:40:55 CST 2023 by linshizhi
\* Created Fri Aug 18 10:45:52 CST 2023 by linshizhi
