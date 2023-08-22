------------------------------ MODULE Informer ------------------------------
EXTENDS Receiver

Informer(reply_, reporters_) == INSTANCE Receiver
Spec == \E reply_, reporters_: Informer(reply_, reporters_)!RSpec
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 14:19:05 CST 2023 by linshizhi
\* Created Fri Aug 18 16:53:57 CST 2023 by linshizhi
