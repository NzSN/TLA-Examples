---- MODULE ReaderWriter -------------------------------------------------------
EXTENDS TLC, Integers, Sequences
CONSTANTS MaxQueueSize

(*--algorithm message_queue

variable queue = <<>>, read_count = 0;

define
  BoundedQueue == Len(queue) <= MaxQueueSize
  EventuallyFull == <>(Len(queue) = MaxQueueSize)
end define;

procedure add_to_queue(val="") begin
  Add:
    await Len(queue) < MaxQueueSize;
    queue := Append(queue, val);
    return;
end procedure;

fair+ process writer = "writer"
begin Write:
  while TRUE do
    call add_to_queue("msg");
  end while;
end process;

fair+ process reader \in {"r1", "r2"}
variables current_message = "none";
begin Read:
  while TRUE do
    await queue /= <<>>;

    if read_count < 5 then
      current_message := Head(queue);
      queue := Tail(queue);

      read_count := read_count + 1;
    else
      skip;
    end if;

    \* either
    \*   skip;
    \* or
    \*   NotifyFailure:
    \*     current_message := "none";
    \*     call add_to_queue(self);
    \* end either;
    end while;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "1138f56" /\ chksum(tla) = "f84f1f71")
VARIABLES queue, read_count, pc, stack

(* define statement *)
BoundedQueue == Len(queue) <= MaxQueueSize
EventuallyFull == <>(Len(queue) = MaxQueueSize)

VARIABLES val, current_message

vars == << queue, read_count, pc, stack, val, current_message >>

ProcSet == {"writer"} \cup ({"r1", "r2"})

Init == (* Global variables *)
        /\ queue = <<>>
        /\ read_count = 0
        (* Procedure add_to_queue *)
        /\ val = [ self \in ProcSet |-> ""]
        (* Process reader *)
        /\ current_message = [self \in {"r1", "r2"} |-> "none"]
        /\ stack = [self \in ProcSet |-> << >>]
        /\ pc = [self \in ProcSet |-> CASE self = "writer" -> "Write"
                                        [] self \in {"r1", "r2"} -> "Read"]

Add(self) == /\ pc[self] = "Add"
             /\ Len(queue) < MaxQueueSize
             /\ queue' = Append(queue, val[self])
             /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
             /\ val' = [val EXCEPT ![self] = Head(stack[self]).val]
             /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
             /\ UNCHANGED << read_count, current_message >>

add_to_queue(self) == Add(self)

Write == /\ pc["writer"] = "Write"
         /\ /\ stack' = [stack EXCEPT !["writer"] = << [ procedure |->  "add_to_queue",
                                                         pc        |->  "Write",
                                                         val       |->  val["writer"] ] >>
                                                     \o stack["writer"]]
            /\ val' = [val EXCEPT !["writer"] = "msg"]
         /\ pc' = [pc EXCEPT !["writer"] = "Add"]
         /\ UNCHANGED << queue, read_count, current_message >>

writer == Write

Read(self) == /\ pc[self] = "Read"
              /\ queue /= <<>>
              /\ IF read_count < 5
                    THEN /\ current_message' = [current_message EXCEPT ![self] = Head(queue)]
                         /\ queue' = Tail(queue)
                         /\ read_count' = read_count + 1
                    ELSE /\ TRUE
                         /\ UNCHANGED << queue, read_count, current_message >>
              /\ pc' = [pc EXCEPT ![self] = "Read"]
              /\ UNCHANGED << stack, val >>

reader(self) == Read(self)

Next == writer
           \/ (\E self \in ProcSet: add_to_queue(self))
           \/ (\E self \in {"r1", "r2"}: reader(self))

Spec == /\ Init /\ [][Next]_vars
        /\ SF_vars(writer) /\ SF_vars(add_to_queue("writer"))
        /\ \A self \in {"r1", "r2"} : SF_vars(reader(self))

\* END TRANSLATION 

================================================================================

