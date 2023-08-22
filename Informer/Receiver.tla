------------------------------ MODULE Receiver ------------------------------
EXTENDS Reporter
VARIABLE reply, (* Report that will send to caller of receiver *)
         reporters, (* Collection of Reporters connected with the Receiver *)
         selected (* The reporter specified by request *)

TypeInvariant ==
    /\ reporters \in [ID -> Reporter]
    /\ selected \in Reporter \union NoReporter

RInit ==
    /\ selected = NoReporter

Req(id) ==
    /\ reporters[id] \in Reporter
    /\ selected = reporters[id]
    /\ Request(selected, selected')

Rep ==
    /\ selected \in Reporter
    /\ \exists rep \in Report:
        /\ Reply(rep, selected, selected')
        /\ reply = rep
    /\ selected = NoReporter

RNext == \E id \in ID: Req(id) /\ Rep
RSpec == RInit /\ [][RNext]_<<reply,reporters>>
----------------------------------------
THEOREM RSpec => []TypeInvariant
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 14:12:04 CST 2023 by linshizhi
\* Created Fri Aug 18 16:57:59 CST 2023 by linshizhi
