---------------------------- MODULE BoundedFIFO ----------------------------
EXTENDS Naturals,Sequences
CONSTANT Message, N
VARIABLES in,out,q

ASSUME (N \in Nat) /\ (N > 0)

Inner == INSTANCE InnerFIFO
BNext == /\ Inner!Next
         /\ Inner!BufRcv => (Len(q) < N)

Spec == Inner!Init /\ [][BNext]_<<in, out, q>>
=============================================================================
\* Modification History
\* Last modified Fri Aug 18 16:11:51 CST 2023 by linshizhi
\* Created Fri Aug 18 16:00:31 CST 2023 by linshizhi



