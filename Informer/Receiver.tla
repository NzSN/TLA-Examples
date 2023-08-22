------------------------------ MODULE Receiver ------------------------------
EXTENDS Reporter
VARIABLE data, (* Report that will send to caller of receiver *)
         reporters (* Collection of Reporters connected with the Receiver *)

TypeInvariant ==
    /\ reporters \in [ID -> Reporter]
    /\ data \in Report

Rep(id) ==
    /\ reporters[id] \in Reporter
    /\ \exists rep \in Report:
        /\ Reply(rep, reporters[id], reporters[id]')
        /\ data = rep

RNext == \E id \in Rep(id)
RSpec == [][RNext]_<<data>>
----------------------------------------
THEOREM RSpec => []TypeInvariant
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 14:12:04 CST 2023 by linshizhi
\* Created Fri Aug 18 16:57:59 CST 2023 by linshizhi
