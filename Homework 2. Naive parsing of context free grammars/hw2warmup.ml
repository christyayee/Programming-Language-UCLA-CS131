type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let rec c_rule rule result r = match rule with
	[]->result
	| (sym, res)::tail -> if sym = r then c_rule tail (result@[res]) r
							else c_rule tail result r

let rec convert_grammar gram = match gram with
	|(s_sym, rule) -> (s_sym, (c_rule rule []))