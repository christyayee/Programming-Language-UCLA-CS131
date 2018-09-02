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

check_uniq([]).
check_uniq([Head|Tail]):-fd_all_different(Head),check_uniq(Tail).

check_rules(_, []).
check_rules(T, [Head|Tail]):- check_rule(T, Head), check_rules(T ,Tail).

test_emp([[]]).
test_emp([[]|Tail]):- test_emp(Tail).

change_fir([], [], []).
change_fir([[Row_head|Row_tail]|Tail_rows], [Row_head|Trans_Hs], [Row_tail|Row]):- change_fir(Tail_rows, Trans_Hs, Row).

trans(T, []):- test_emp(T).
trans(T, [Trans_H|Trans_T]):- change_fir(T, Trans_H, Next_T), trans(Next_T, Trans_T).

check_domain(N, L) :- fd_domain(L, 1, N).

kenken(N,C,T):-
        check_len(T,N),
        check_uniq(T),
        trans(T, Trans_T),
        check_uniq(Trans_T),
        maplist(check_domain(N), T),
        check_rules(T, C),
        maplist(fd_labeling, T).

make_test(0, []).
make_test(N, [N|Tail]):-N > 0, N_next is N - 1, make_test(N_next, Tail).

m_check(List, N):-make_test(N, Test_List), permutation(Test_List, List).

m_check_list([], 0, _).
m_check_list([Head|Tail], Nth, N):-Nth > 0, Next_N is Nth-1, m_check(Head,N),m_check_list(Tail, Next_N, N).


plain_kenken(N,C,T):- m_check_list(T, N, N), trans(T, Trans_T), m_check_list(Trans_T, N, N), check_rules(T, C).
