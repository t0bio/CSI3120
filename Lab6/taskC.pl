% task C

is_prime(2).
is_prime(3).
is_prime(N) :-
    N > 3,
    N mod 2 =\= 0,
    \+ has_factor(N, 3).


has_factor(N, Factor) :-
    N mod Factor =:= 0.
has_factor(N, Factor) :-
    Factor * Factor < N,
    NextFactor is Factor + 2,
    has_factor(N, NextFactor).

reverse_digits(N, Rev) :-
    number_chars(N, Digits),
    reverse(Digits, RevDigits),
    number_chars(Rev, RevDigits).


filter_and_transform(List, Result) :-
    filter_transform_acc(List, [], Result, 5).

filter_transform_acc(_, Acc, Acc, 0) :- !.
filter_transform_acc([], Acc, Acc, _).
filter_transform_acc([H|T], Acc, Result, Count) :-
    is_prime(H),
    reverse_digits(H, Rev),
    NewCount is Count - 1,
    filter_transform_acc(T, [Rev|Acc], Result, NewCount).
filter_transform_acc([_|T], Acc, Result, Count) :-
    filter_transform_acc(T, Acc, Result, Count).

