---- MODULE MemoryInterface ----------------------------------------------------
(* Documentation *)
--------------------------------------------------------------------------------
VARIABLE memInt
CONSTANTS Send(_,_,_,_),
          Reply(_,_,_,_),
          InitMemInt,
          Proc,
          Adr,
          Val
ASSUME \forall p,d,miOld,miNew : /\ Send(p,d,miOld,miNew) \in Boolean
                                 /\ Reply(p,d,miOld,miNew) \in Boolean
--------------------------------------------------------------------------------
MReq == [op:{"Rd"}, adr:Adr] \union [op:{"Wr"}, adr:Adr, val:Val]
NoVal == CHOOSE v: v \notin Val
================================================================================

