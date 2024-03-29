---- MODULE linklistMain ----
EXTENDS TLC, Integers, FiniteSets, Sequences
CONSTANTS Nodes, NULL

INSTANCE linklist WITH NULL <- NULL
AllLinkedLists == LinkedLists(Nodes)

CycleImpliesTwoParents(ll) ==
    Cyclic(ll) <=>
        \/ Ring(ll)
        \/ \E n \in DOMAIN ll:
            Cardinality({p \in DOMAIN ll: ll[p] = n}) = 2

Valid ==
    /\ \A ll \in AllLinkedLists:
        /\ PrintT(ll)
        \*/\ Assert(CycleImpliesTwoParents(ll), <<"Counterexample:", ll>>)
====
