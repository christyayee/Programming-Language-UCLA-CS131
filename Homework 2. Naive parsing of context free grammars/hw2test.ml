let accept_incrop derivation = function 
  | "++"::tail -> Some (derivation,"++"::tail) 
  | "--"::tail -> Some (derivation,"--"::tail) 
  | _ -> None
let accept_all derivation string = Some (derivation, string)


type my_nonterminals =
  | Expr | Term | Incrop | Binop | Num

let my_grammar =
  (Expr,
   function
     | Expr ->
         [[N Term; N Binop; N Expr];
          [N Term]]
     | Term ->
      	 [[N Num];
      	  [T"("; N Expr; T")"]]
     | Incrop ->
      	 [[T"++"];
      	  [T"--"]]
     | Binop ->
      	 [[T"+"];
      	  [T"*"];
          [T"/"];
          [T"-"]]
     | Num ->
      	 [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
      	  [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

let test0 =
  ((parse_prefix my_grammar accept_all ["9"; "/"; "1"; "+";"1";"+";"9";]) =
  Some
   ([(Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "9"]);
     (Binop, [T "/"]); (Expr, [N Term; N Binop; N Expr]); (Term, [N Num]);
     (Num, [T "1"]); (Binop, [T "+"]); (Expr, [N Term; N Binop; N Expr]);
     (Term, [N Num]); (Num, [T "1"]); (Binop, [T "+"]); (Expr, [N Term]);
     (Term, [N Num]); (Num, [T "9"])],
    []))

let test1 =
  ((parse_prefix my_grammar accept_incrop ["9"; "++"; "*"; "3";"--";"+";"1"])=
  Some
   ([(Expr, [N Term]); (Term, [N Num]); (Num, [T "9"])],
    ["++"; "*"; "3"; "--"; "+"; "1"]))