------------------------------ MODULE Informer ------------------------------
Informer(reply, reporters) == INSTANCE Receiver
Spec == \E reply, reporters: Informer(reply, reporters)!RSpec
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 14:19:05 CST 2023 by linshizhi
\* Created Fri Aug 18 16:53:57 CST 2023 by linshizhi
