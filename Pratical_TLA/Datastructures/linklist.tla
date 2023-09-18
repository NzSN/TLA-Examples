------ MODULE linklist -------
CONSTANT NULL

LOCAL INSTANCE FiniteSets
LOCAL INSTANCE Sequences
LOCAL INSTANCE TLC
LOCAL INSTANCE Integers

LOCAL PointerMaps(Nodes) ==
    [Nodes -> Nodes \union {NULL}]
LOCAL Range(f) == {f[x]: x \in DOMAIN f}

LOCAL isLinkedLists(PointerMap) ==
    LET nodes == DOMAIN PointerMap
        all_seqs == [1..Cardinality(nodes) -> nodes]
    IN \E ordering \in all_seqs:
        /\ \A i \in 1..Len(ordering)-1:
            PointerMap[ordering[i]] = ordering[i+1]
        /\ nodes \subseteq Range(ordering)

LinkedLists(Nodes) ==
    IF NULL \in Nodes THEN Assert(FALSE, "NULL annot be in Nodes")
    ELSE
      LET
        nodes_subset == (SUBSET Nodes \ {{}})
        pointer_maps_sets == {PointerMaps(subn): subn \in nodes_subset}
        all_maps == UNION pointer_maps_sets
      IN
        {pm \in all_maps: isLinkedLists(pm)}

Cyclic(LL) == NULL \notin Range(LL)
Ring(LL) == (DOMAIN LL = Range(LL))

First(LL) ==
    IF Ring(LL)
    THEN CHOOSE node \in DOMAIN LL: TRUE
    ELSE CHOOSE node \in DOMAIN LL: node \notin Range(LL)
===============
