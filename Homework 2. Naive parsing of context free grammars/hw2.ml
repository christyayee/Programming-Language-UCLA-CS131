type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let rec converter (pre_sym, list_sym) = match list_sym with
	[] -> (function | _ -> [])
	| (cur_sym, gra_rule)::tail -> if pre_sym = cur_sym then gra_rule::(converter (cur_sym, tail))
									else function cur_sym -> converter (cur_sym, tail);;

 let convert_grammar gram1 = (fst gram1, fun )