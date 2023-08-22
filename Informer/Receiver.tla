------------------------------ MODULE Receiver ------------------------------
EXTENDS Reporter
VARIABLE data, (* Report that will send to caller of receiver *)
         reporters (* Collection of Reporters connected with the Receiver *)

ReporterInst == INSTANCE Reporter

TypeInvariant ==
    /\ ReporterInst!TypeInvariant
    /\ reporters \in [ID -> Reporter]
    /\ data \in Report

Retrieve(id) ==
    /\ reporters[id] \in Reporter
    /\ data = ReporterInst!DoReport(reporters[id], reporters[id]')
    /\ data \in Report
    /\ UNCHANGED reporters

RetrieveAll ==
    /\ data = [i \in 1 .. Len(Reporters) |-> DoReport(reporters[i]) ]
    /\ UNCHANGED reporters

RNext == \E id \in Retrieve(id)
RSpec == [][RNext]_<<data>>
----------------------------------------
THEOREM RSpec => []TypeInvariant
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 14:12:04 CST 2023 by linshizhi
\* Created Fri Aug 18 16:57:59 CST 2023 by linshizhi
