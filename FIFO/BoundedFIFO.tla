---------------------------- MODULE BoundedFIFO ----------------------------
EXTENDS Naturals,Sequences
CONSTANT Message
VARIABLES in,out

ASSUME (N \in Nat) /\ (N > 0)

Inner(q) == INSTANCE InnerFIFO
BNext(q) == /\ Inner(q)!Next
            /\ Inner(q)!BufRcv => (Len(q) < N)

Spec == (\exists q: Inner(q)!Init) /\ [][BNext(q)]_<<in, out, q>>
=============================================================================
\* Modification History
\* Last modified Fri Aug 18 16:11:51 CST 2023 by linshizhi
\* Created Fri Aug 18 16:00:31 CST 2023 by linshizhi
