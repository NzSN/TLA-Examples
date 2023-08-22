------------------------------ MODULE Receiver ------------------------------
EXTENDS ReporterInterface
VARIABLE reply,     (* Report that will send to caller of receiver *)
         reporters, (* Collection of Reporters connected with the Receiver *)
         selected   (* The reporter specified by request *)

RInit ==
    /\ reporters \in [ID -> Reporter]
    /\ selected = NoReporter

Req(id) ==
    /\ selected \in NoReporter
    /\ reporters[id] \in Reporter
    /\ selected = reporters[id]
    /\ Request(selected, selected')

Rep ==
    /\ selected \in Reporter
    /\ \E rep \in Report:
        /\ Reply(rep, selected, selected')
        /\ reply = rep
    /\ selected = NoReporter
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 11:58:56 CST 2023 by linshizhi
\* Created Fri Aug 18 16:57:59 CST 2023 by linshizhi
