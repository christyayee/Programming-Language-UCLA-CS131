let subset_test0 = subset [] []
let subset_test1 = subset [5;2] [1;5;6;2]
let subset_test2 = subset [1] [1;5;6;7]
let subset_test3 = not (subset [5;2] [])
let subset_test4 = not (subset [1] [5;6;7])

let equal_sets_test0 = equal_sets [] []
let equal_sets_test1 = equal_sets [1;2;3] [3;2;1]
let equal_sets_test2 = equal_sets [5] [5;5;5;5]
let equal_sets_test3 = not (equal_sets [] [1])
let equal_sets_test4 = not (equal_sets [2;3] [3;2;1])

let set_union_test0 = equal_sets (set_union [6;4;2] []) [6;4;2]
let set_union_test1 = equal_sets (set_union [1;2;3] [1;2;3]) [1;2;3]
let set_union_test2 = equal_sets (set_union [1;1;1] [2;2;2]) [1;2]
let set_union_test3 = equal_sets (set_union [1;1;1;2] []) [1;2]
let set_union_test4 = equal_sets (set_union [] [5;5;5;5;1]) [5;1]

let set_intersection_test0 = equal_sets (set_intersection [1;2;3] []) []
let set_intersection_test1 = equal_sets (set_intersection [1;2;3] [4;6;7]) []
let set_intersection_test2 = equal_sets (set_intersection [5;6;7;8] [8;7;6;5]) [5;6;7;8]
let set_intersection_test3 = equal_sets (set_intersection [2;2;2;2;3] [3]) [3]
let set_intersection_test4 = equal_sets (set_intersection [5;5;5;5;5;5] [5]) [5]
  
let set_diff_test0 = equal_sets (set_diff [] []) []
let set_diff_test1 = equal_sets (set_diff [5;4;3;2;1] [3;9;8;0]) [1;2;4;5]
let set_diff_test1 = equal_sets (set_diff [] [3;9;8;0]) []

let computed_fixed_point_test = computed_fixed_point (=) (fun x -> x - x/2) 50 = 1
  
let computed_periodic_point_test = computed_periodic_point (=) (fun x -> -x) 2 1 = 1

let mwhile_away_test0 = 
  equal_sets (while_away ((+) 3) ((>) 10) 0) [0; 3; 6; 9]
let while_away_test1 = 
  equal_sets (while_away (( * ) 3) ((>) 15) 5) [5]
 let while_away_test1 = 
  equal_sets (while_away (( - ) 3) ((<) 0) 0) []

let rle_decode_test0 = 
  equal_sets (rle_decode [0,0; 0,1]) []
let rle_decode_test1 = 
  equal_sets (rle_decode [2,1; 2,1; 0,2; 3,3]) [1; 1; 1; 1; 3; 3; 3]
let rle_decode_test2 =
  equal_sets (rle_decode []) []
  
type m_nonterminals =
  | A | B | C | D | E

  let m_rules =
   [A, [T "???"];
    A, [N D];
    A, [N B; N C; N D];
    B, [N B];
    C, [T "c"];
    C, [N A];
    D, [T "d"];
    D, [T "dd"]] 
	
let m_grammar = A, m_rules

let m_test0 = 
	filter_blind_alleys m_grammar 
	= (A,
	[(A, [T "???"]); (A, [N D]);
	(C, [T "c"]); (C, [N A]);
	(D, [T "d"]);
	(D, [T "dd"])])

let m_test1 =
  filter_blind_alleys (A,
      [A, [N E; N D; N C];
       A, [N A; N B];
	   A, [N B];
       A, [N A; N D; N A];
       B, [N C; N B];
	   B, [N B; N A];
       B, [N C; N D];
       B, [N B; N C];
       C, [T"ccc"]; C, [T"cc"]; C, [T"c"]; C, [T"cccc"];
       D, [T"dd"]; D, [T"d"];
       E, [T"eeeee"]; E, [T"eeee"]])
  = (A,
    [(A, [N E; N D; N C]);
    (A, [N A; N B]);
    (A, [N B]);
    (A, [N A; N D; N A]);
    (B, [N C; N B]);
    (B, [N B; N A]);
    (B, [N C; N D]);
    (B, [N B; N C]);
    (C, [T "ccc"]); (C, [T "cc"]); (C, [T "c"]); (C, [T "cccc"]);
    (D, [T "dd"]); (D, [T "d"]);
    (E, [T "eeeee"]); (E, [T "eeee"])])

