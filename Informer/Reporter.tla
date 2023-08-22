------------------------------ MODULE ReporterInterface ------------------------------
VARIABLE reporterInterface
CONSTANT DoReport(_,_,_),
         ID,
         Reporter,
         Report

ASSUME \A repOld, repNew:
    DoReply(repOld,repNew) \in Report (* Reporter report a report to Receiver *)
-----------------------------------------------------------------------------
NoReporter == CHOOSE v : v \notin Reporter
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 11:54:41 CST 2023 by linshizhi
\* Created Fri Aug 18 16:57:46 CST 2023 by linshizhi
