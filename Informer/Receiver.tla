------------------------------ MODULE Receiver ------------------------------
EXTENDS Reporter
VARIABLE data, (* Report that will send to caller of receiver *)
         reporters (* Collection of Reporters connected with the Receiver *)

TypeInvariant ==
    /\ RPTypeInvariant
    /\ reporters \in [ID -> Reporter]

Retrieve(id) ==
    /\ reporters[id] \in Reporter
    /\ data = DoReport(reporters[id], reporters[id]')
    /\ data \in Report
    /\ UNCHANGED reporters

RetrieveAll ==
    /\ data = [id \in ID |-> DoReport(reporters[id], reporters[id]')]
    /\ data \in Report
    /\ UNCHANGED reporters

RNext == /\ \E id \in ID: Retrieve(id)
         /\ RetrieveAll 
RSpec == [][RNext]_<<data>>
----------------------------------------
THEOREM RSpec => []TypeInvariant
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 16:27:17 CST 2023 by linshizhi
\* Created Fri Aug 18 16:57:59 CST 2023 by linshizhi
