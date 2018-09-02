type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let rec or_matcher orig_rules start pick_rules acceptor derivation fragment = match pick_rules with
  | [] -> None
  | (fst :: rest) -> let check_suffix = and_matcher orig_rules fst acceptor (derivation@[(start, fst)]) fragment
                      in 
                      match check_suffix with
                        | None -> or_matcher orig_rules start rest acceptor derivation fragment
                        | other -> other

and and_matcher orig_rules pick_rules acceptor derivation fragment = match pick_rules with
  | [] -> acceptor derivation fragment
  | ((N fst) :: rest) ->
      or_matcher orig_rules fst (orig_rules fst) (and_matcher orig_rules rest acceptor) derivation fragment
  | ((T fst) :: rest) ->
      match fragment with 
      | [] -> None 
      | (hd :: tl) -> if (hd = fst) then (and_matcher orig_rules rest acceptor derivation tl)
                      else None 

 

let parse_prefix grammar acceptor fragment = 
	match grammar with
	| (start, orig_rules) -> or_matcher orig_rules start (orig_rules start) acceptor [] fragment