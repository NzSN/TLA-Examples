---- MODULE Actor --------------
EXTENDS Integers
CONSTANT ResourceCap, MaxConsumerReq, Actors

ASSUME ResourceCap > 0
ASSUME Actors /= {}
ASSUME MaxConsumerReq \in 1..ResourceCap

(*--algorithm cache
variables
  resource_cap \in 1..ResourceCap,
  resources_left = resource_cap,
  reserved = 0; \* our semaphore

define
  ResourceInvariant == resources_left >= 0
end define;

process actor \in Actors
variables
  resources_need \in 1..MaxConsumerReq
begin
  WaitForResources:
    while TRUE do
      await reserved + resources_need <= resources_left;
      reserved := reserved + resources_need;
      UseResources:
        while resources_need > 0 do
          resources_left := resources_left - 1;
          resources_need := resources_need - 1;
          reserved := reserved - 1;
        end while;
        with x \in 1..MaxConsumerReq do
          resources_need := x;
        end with;
    end while;
end process;

process time = "time"
begin
  Tick:
    resources_left := resource_cap;
    goto Tick;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "fe05a12b" /\ chksum(tla) = "71010eef")
VARIABLES resource_cap, resources_left, reserved, pc

(* define statement *)
ResourceInvariant == resources_left >= 0

VARIABLE resources_need

vars == << resource_cap, resources_left, reserved, pc, resources_need >>

ProcSet == (Actors) \cup {"time"}

Init == (* Global variables *)
        /\ resource_cap \in 1..ResourceCap
        /\ resources_left = resource_cap
        /\ reserved = 0
        (* Process actor *)
        /\ resources_need \in [Actors -> 1..MaxConsumerReq]
        /\ pc = [self \in ProcSet |-> CASE self \in Actors -> "WaitForResources"
                                        [] self = "time" -> "Tick"]

WaitForResources(self) == /\ pc[self] = "WaitForResources"
                          /\ reserved + resources_need[self] <= resources_left
                          /\ reserved' = reserved + resources_need[self]
                          /\ pc' = [pc EXCEPT ![self] = "UseResources"]
                          /\ UNCHANGED << resource_cap, resources_left, 
                                          resources_need >>

UseResources(self) == /\ pc[self] = "UseResources"
                      /\ IF resources_need[self] > 0
                            THEN /\ resources_left' = resources_left - 1
                                 /\ resources_need' = [resources_need EXCEPT ![self] = resources_need[self] - 1]
                                 /\ reserved' = reserved - 1
                                 /\ pc' = [pc EXCEPT ![self] = "UseResources"]
                            ELSE /\ \E x \in 1..MaxConsumerReq:
                                      resources_need' = [resources_need EXCEPT ![self] = x]
                                 /\ pc' = [pc EXCEPT ![self] = "WaitForResources"]
                                 /\ UNCHANGED << resources_left, reserved >>
                      /\ UNCHANGED resource_cap

actor(self) == WaitForResources(self) \/ UseResources(self)

Tick == /\ pc["time"] = "Tick"
        /\ resources_left' = resource_cap
        /\ pc' = [pc EXCEPT !["time"] = "Tick"]
        /\ UNCHANGED << resource_cap, reserved, resources_need >>

time == Tick

Next == time
           \/ (\E self \in Actors: actor(self))

Spec == Init /\ [][Next]_vars

\* END TRANSLATION 
==============================================================================
