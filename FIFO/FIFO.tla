-------------------------------- MODULE FIFO --------------------------------
EXTENDS Naturals,Sequences
CONSTANT Message
VARIABLES in,out

Inner(q) == INSTANCE InnerFIFO
Spec == \exists q: Inner(q)!Spec
=============================================================================
\* Modification History
\* Last modified Fri Aug 18 15:40:18 CST 2023 by linshizhi
\* Created Fri Aug 18 11:56:32 CST 2023 by linshizhi
