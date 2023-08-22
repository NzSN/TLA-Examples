------------------------------ MODULE Informer ------------------------------
EXTENDS Reporter
Informer(reporters, data) == INSTANCE Receiver
Spec == \E reporters, data: Informer(reporters, data)!RSpec
=============================================================================
\* Modification History
\* Last modified Tue Aug 22 16:06:28 CST 2023 by linshizhi
\* Created Fri Aug 18 16:53:57 CST 2023 by linshizhi
