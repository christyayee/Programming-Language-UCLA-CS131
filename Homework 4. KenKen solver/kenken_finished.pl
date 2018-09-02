get_ele(T,[Row|Col],Ele):-nth(Row, T, Row_List),nth(Col, Row_List, Ele).

add_rule( _, [], 0).
add_rule(T, [Head|Tail], S):-get_ele(T,Head,Ele),add_rule(T,Tail,Sum),S #= Ele + Sum.

mul_rule( _, [], 1).
mul_rule(T, [Head|Tail], P):-get_ele(T,Head,Ele),mul_rule(T,Tail,Pro),P #=  Ele * Pro.

sub_rule(T, J, K, D):-get_ele(T,J,Ele1), get_ele(T,K,Ele2),(D #=  Ele1 - Ele2; D #=  Ele2 - Ele1).

div_rule(T, J, K, Q):-get_ele(T,J,Ele1), get_ele(T,K,Ele2),(Q #=  Ele1 / Ele2; Q #=  Ele2 / Ele1).

check_rule(T,+(S, L)):-add_rule(T,L,S).
check_rule(T,*(P, L)):-mul_rule(T,L,P).
check_rule(T,-(D, J, K)):-sub_rule(T,J,K,D).
check_rule(T,/(Q, J, K)):-div_rule(T,J,K,Q).

check_row_len([], _).
check_row_len([Head|Tail], N):-length(Head, N),check_row_len(Tail, N).

check_len(T,N):-length(T,N),check_row_len(T,N).

check_row_uniq([]).
check_row_uniq([Head|Tail]):-fd_all_different(Head),check_row_uniq(Tail).

check_nth_col_uniq([], Res, _):-fd_all_different(Res).
check_nth_col_uniq([Head|Tail], Res, Nth):-nth(Nth,Head,Ele),check_nth_col_uniq(Tail,[Ele|Res],Nth).

check_col_uniq(_, 0).
check_col_uniq(T, Nth):-Next_N is Nth - 1, check_nth_col_uniq(T,[],Nth), check_col_uniq(T, Next_N).

check_domain(N, L) :- fd_domain(L, 1, N).

kenken(N,C,T):-
	check_len(T,N),
	check_row_uniq(T),
	check_col_uniq(T,N),
	maplist(check_domain(N), T),
	maplist(check_rule(T), C),
	maplist(fd_labeling, T).

check_rules(_, []).
check_rules(T, [Head|Tail]):- check_rule(T, Head), check_rules(T ,Tail).

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
make_test(0, []).
make_test(N, [N|Tail]):-N > 0, N_next is N - 1, make_test(N_next, Tail).
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

m_check(List, N):-make_test(N, Test_List), permutation(List, Test_List).

m_check_row([], _).
m_check_row([Head|Tail], N):-m_check(Head,N),check_row(Tail,N).


%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
get_col([], _, []]).
get_col([Head|Tail], Nth, [Res|Temp]):- nth(Head, Nth, Res), get_col(Tail, Nth, Temp).

m_check_nth_col(T, Nth, N):-get_col(T, Nth, Res),m_check(Res, N).
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
m_check_col(_, 0,_).
m_check_col(T, Nth, N):-Nth > 0, Next_N is Nth - 1,m_check_nth_col(T,Nth, N), m_check_col(T, Next_N, N).
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

plain_kenken(N,C,T):- m_check_col(T, N, N), m_check_row(T, N), check_rules(T, C).

t([[5,6,3,4,1,2],
     [6,1,4,5,2,3],
     [4,5,2,3,6,1],
     [3,4,1,2,5,6],
     [2,3,6,1,4,5],
     [1,2,5,6,3,4]]).

kenken_testcase(
  6,
  [
   +(11, [[1|1], [2|1]]),
   /(2, [1|2], [1|3]),
   *(20, [[1|4], [2|4]]),
   *(6, [[1|5], [1|6], [2|6], [3|6]]),
   -(3, [2|2], [2|3]),
   /(3, [2|5], [3|5]),
   *(240, [[3|1], [3|2], [4|1], [4|2]]),
   *(6, [[3|3], [3|4]]),
   *(6, [[4|3], [5|3]]),
   +(7, [[4|4], [5|4], [5|5]]),
   *(30, [[4|5], [4|6]]),
   *(6, [[5|1], [5|2]]),
   +(9, [[5|6], [6|6]]),
   +(8, [[6|1], [6|2], [6|3]]),
   /(2, [6|4], [6|5])
  ]
).

