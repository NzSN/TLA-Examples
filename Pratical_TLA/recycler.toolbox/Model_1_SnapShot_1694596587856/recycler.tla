------------------------------ MODULE recycler ------------------------------
EXTENDS Sequences, Integers, FiniteSets, TLC

(*--algorithm recycler
variables
    capacity \in [trash: 1..10, recycle: 1..10],
    bins = [trash |-> <<>>, recycle |-> <<>>],
    count = [trash |-> 0, recycle |-> 0],
    item = [type: {"recycle", "trash"}, size: 1..6],
    items \in item \X item \X item \X item,
    curr = ""; \* helper: current item
    
macro add_item(type) begin
    bins[type] := bins[type] \union {curr};
    capacity[type] := capacity[type] - curr.size;
    count[type] := count[type] + 1;
end macro;    
    
begin
    while items /= <<>> do
        curr := Head(items);
        items := Tail(items);
        if curr.type = "recycle" /\ curr.size < capacity.recycle then
            add_item("recycle");
        elsif curr.size < capacity.trash then 
            add_item("trash");
        end if;
    end while;
    
    assert capacity.trash >= 0 /\ capacity.recycle >= 0;
    assert Cardinality(bins.trash) = count.trash;
    assert Cardinality(bins.recycle) = count.recycle;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "3d3eed00" /\ chksum(tla) = "597db41f")
VARIABLES capacity, bins, count, item, items, curr, pc

vars == << capacity, bins, count, item, items, curr, pc >>

Init == (* Global variables *)
        /\ capacity \in [trash: 1..10, recycle: 1..10]
        /\ bins = [trash |-> <<>>, recycle |-> <<>>]
        /\ count = [trash |-> 0, recycle |-> 0]
        /\ item = [type: {"recycle", "trash"}, size: 1..6]
        /\ items \in item \X item \X item \X item
        /\ curr = ""
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF items /= <<>>
               THEN /\ curr' = Head(items)
                    /\ items' = Tail(items)
                    /\ IF curr'.type = "recycle" /\ curr'.size < capacity.recycle
                          THEN /\ bins' = [bins EXCEPT !["recycle"] = bins["recycle"] \union {curr'}]
                               /\ capacity' = [capacity EXCEPT !["recycle"] = capacity["recycle"] - curr'.size]
                               /\ count' = [count EXCEPT !["recycle"] = count["recycle"] + 1]
                          ELSE /\ IF curr'.size < capacity.trash
                                     THEN /\ bins' = [bins EXCEPT !["trash"] = bins["trash"] \union {curr'}]
                                          /\ capacity' = [capacity EXCEPT !["trash"] = capacity["trash"] - curr'.size]
                                          /\ count' = [count EXCEPT !["trash"] = count["trash"] + 1]
                                     ELSE /\ TRUE
                                          /\ UNCHANGED << capacity, bins, 
                                                          count >>
                    /\ pc' = "Lbl_1"
               ELSE /\ Assert(capacity.trash >= 0 /\ capacity.recycle >= 0, 
                              "Failure of assertion at line 30, column 5.")
                    /\ Assert(Cardinality(bins.trash) = count.trash, 
                              "Failure of assertion at line 31, column 5.")
                    /\ Assert(Cardinality(bins.recycle) = count.recycle, 
                              "Failure of assertion at line 32, column 5.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << capacity, bins, count, items, curr >>
         /\ item' = item

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Wed Sep 13 17:16:13 CST 2023 by linshizhi
\* Created Wed Sep 13 16:33:43 CST 2023 by linshizhi
