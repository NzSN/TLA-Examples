----------- MODULE ZeroOneSeq ---------------
EXTENDS Integers, TLC, Sequences
CONSTANTS MAX_Q_SIZE

(*--algorithm algo
variables q = <<>>;

define
    Bounded == Len(q) <= MAX_Q_SIZE
    Interleaved ==
        LET zero_ks == {k \in 1..Len(q): q[k] = 0}
        IN  \A k \in zero_ks: IF k = Len(q)
                                THEN q[k] = 0
                                ELSE q[k+1] = 1
    EventuallyFull == <>(Len(q) = MAX_Q_SIZE)
end define;

macro wait_for(val) begin
    if Len(q) = 0 then
      skip;
    else
      await q[Len(q)] = val;
    end if;
end macro;

fair+ process Writer0 \in { "w0_1", "w0_2" }
begin Writer0:
    while TRUE do
      wait_for(1);

      if Len(q) < MAX_Q_SIZE then
        either
          q := Append(q, 0);
        or
          skip;
        end either;
      else
        skip
      end if;
      end while;
end process;

fair+ process writer1 = "writer1"
begin Writer1:
    while TRUE do
      wait_for(0);

      if Len(q) < MAX_Q_SIZE then
        either
          q := Append(q, 1);
        or
          skip;
        end either;
      else
        skip
      end if;
    end while;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "a4f2b47f" /\ chksum(tla) = "4b13fa74")
\* Label Writer0 of process Writer0 at line 28 col 5 changed to Writer0_
VARIABLE q

(* define statement *)
Bounded == Len(q) <= MAX_Q_SIZE
Interleaved ==
    LET zero_ks == {k \in 1..Len(q): q[k] = 0}
    IN  \A k \in zero_ks: IF k = Len(q)
                            THEN q[k] = 0
                            ELSE q[k+1] = 1
EventuallyFull == <>(Len(q) = MAX_Q_SIZE)


vars == << q >>

ProcSet == ({ "w0_1", "w0_2" }) \cup {"writer1"}

Init == (* Global variables *)
        /\ q = <<>>

Writer0(self) == /\ IF Len(q) = 0
                       THEN /\ TRUE
                       ELSE /\ q[Len(q)] = 1
                 /\ IF Len(q) < MAX_Q_SIZE
                       THEN /\ \/ /\ q' = Append(q, 0)
                               \/ /\ TRUE
                                  /\ q' = q
                       ELSE /\ TRUE
                            /\ q' = q

writer1 == /\ IF Len(q) = 0
                 THEN /\ TRUE
                 ELSE /\ q[Len(q)] = 0
           /\ IF Len(q) < MAX_Q_SIZE
                 THEN /\ \/ /\ q' = Append(q, 1)
                         \/ /\ TRUE
                            /\ q' = q
                 ELSE /\ TRUE
                      /\ q' = q

Next == writer1
           \/ (\E self \in { "w0_1", "w0_2" }: Writer0(self))

Spec == /\ Init /\ [][Next]_vars
        /\ \A self \in { "w0_1", "w0_2" } : SF_vars(Writer0(self))
        /\ SF_vars(writer1)

\* END TRANSLATION 
=============================================
