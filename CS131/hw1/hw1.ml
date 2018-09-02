let rec have ele li = match li with
	  [] -> false
	| head::tail -> if ele = head then true
					else (have ele tail);;

let rec subset a b = match a with 
	  [] -> true
	| head::tail -> if (have head b) then (subset tail b)
					else false;;

let equal_sets a b = (subset a b) && (subset b a);;

let rec set_union a b = match a with
	  [] -> b
	| head::tail -> if (have head b) then (set_union tail b)
					else head::(set_union tail b);;

let rec set_intersection a b = match a with
	  [] -> a
	| head::tail -> if (have head b) then head::(set_intersection tail b)
					else (set_intersection tail b);;

let rec set_diff a b = match a with
	  [] -> a
	| head::tail -> if (have head b) then (set_diff tail b)
					else head::(set_diff tail b);;

let rec computed_fixed_point eq f x = 
	if (eq (f x) x) then x
	else (computed_fixed_point eq f (f x));;


let rec computed_periodic_point eq f p x = match p with
	  0 -> x
	| _ -> if (eq x (f (computed_periodic_point eq f (p-1) (f x)))) then x
			else (computed_periodic_point eq f p (f x));;

let rec while_away s p x =
	if (p x) then x::(while_away s p (s x))
	else [];;

let rec section (rep, pat) = match rep with
	  0 -> []
	| _ ->pat::(section ((rep - 1), pat));;

let rec rle_decode lp = match lp with
	  [] -> []
	| head::tail -> (section (head))@(rle_decode tail);;

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let checkValid rule valid = match rule with
	  N va -> (have va valid)
	| T _  -> true;;

let rec checkRule rule valid = match rule with
	  [] -> true
	| head::tail -> if not (checkValid head valid) then false
					else (checkRule tail valid);; 
 
let rec parse valid origin = match origin with
	  [] -> valid
	| head::tail -> if (checkRule (snd head) valid) && not (have (fst head) valid) then (parse ((fst head)::valid) tail)
					 else (parse valid tail);;

let comp_parse (valid, origin) = 
	((parse valid origin), origin);;

let m_equal (first_valid, first_origin) (second_valid, second_origin)= equal_sets first_valid second_valid;;

let rec correct_sequence (valid, origin) = match origin with
	  [] -> []
	| head::tail -> if (checkRule (snd head) valid) then [head]@(correct_sequence (valid,tail))
					else (correct_sequence (valid,tail));;

let filter_blind_alleys g = (fst g, correct_sequence (computed_fixed_point m_equal comp_parse ([], (snd g))));;