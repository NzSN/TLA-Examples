---- MODULE MC ----
EXTENDS Wire, TLC

\* Constant expression definition @modelExpressionEval
const_expr_169459306289930000 == 
1 + 2
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_169459306289930000>>)
----

=============================================================================
\* Modification History
\* Created Wed Sep 13 16:17:42 CST 2023 by linshizhi
