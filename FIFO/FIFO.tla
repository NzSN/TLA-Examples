-------------------------------- MODULE FIFO --------------------------------
EXTENDS Naturals, Sequences
CONSTANT Message, qLen
VARIABLES in,out,q

Inner == INSTANCE InnerFIFO WITH in <- in, out <- out, q <- q
QConstraint == Len(q) \leq qLen
TypeInvariant == Inner!TypeInvariant

Spec == Inner!Spec
=============================================================================
\* Modification History
\* Last modified Fri Aug 18 15:40:18 CST 2023 by linshizhi
\* Created Fri Aug 18 11:56:32 CST 2023 by linshizhi
