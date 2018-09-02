(*Fall 2017*)

(*1.a*)
(*?*)
let rec merge_sorted f l1 l2 = 
	if l1 = [] then l2
	else if l2 = [] then l1
	else let (head1::tail1, head2::tail2) = (l1,l2) in
		match (f head1 head2) with
			True -> head1::head2::(merge_sorted f tail1 tail2)
			False -> head2::head1::(merge_sorted f tail1 tail2)