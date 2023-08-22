------------------------------ MODULE Reporter ------------------------------
VARIABLE reporterInterface
CONSTANT DoReport(_,_),
         ID,
         Reporter,
         Report

RPTypeInvariant == Reporter \in [ id: ID ]
ASSUME \A repOld, repNew:
    DoReport(repOld,repNew) \in Report (* Reporter report a report to Receiver *)
-----------------------------------------------------------------------------
NoReporter == CHOOSE v : v \notin Reporter
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 16:14:29 CST 2023 by linshizhi
\* Created Fri Aug 18 16:57:46 CST 2023 by linshizhi
