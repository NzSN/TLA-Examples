------------------------------ MODULE Reporter ------------------------------
VARIABLE reporter
CONSTANT Reply(_,_,_),
         Request(_,_),
         ID,
         Reporter,
         Report

ASSUME \A repOld, repNew:
    Request(repOld, repNew) \in BOOLEAN
ASSUME \A rep, repOld, repNew:
    Reply(rep, repOld,repNew) \in BOOLEAN \* Reporter report a report to Receiver
-----------------------------------------------------------------------------
NoReporter == CHOOSE v : v \notin Reporter
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 11:54:41 CST 2023 by linshizhi
\* Created Fri Aug 18 16:57:46 CST 2023 by linshizhi
