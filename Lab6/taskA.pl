% task A

% Q1

factorial(N, Acc, Result) :-
    integer(N),
    N >= 0,
    factorial_acc(N, Acc, Result), !.
factorial(N, _, 'Error: Input must be a non-negative integer.') :-
    (\+ integer(N) ; N < 0).

factorial_acc(0, Acc, Acc).
factorial_acc(N, Acc, Result) :-
    N > 0,
    NewAcc is N * Acc,
    NewN is N - 1,
    factorial_acc(NewN, NewAcc, Result).


% Q2

greater_than(Value, Element) :-
    Element > Value.

multiple_of(Value, Element) :-
    Element mod Value =:= 0.

filter_list([], _, []).
filter_list([H|T], Conditions, [H|FilteredTail]) :-
    satisfy_all_conditions(H, Conditions),
    filter_list(T, Conditions, FilteredTail).
filter_list([_|T], Conditions, FilteredTail) :-
    filter_list(T, Conditions, FilteredTail).

satisfy_all_conditions(_, []).
satisfy_all_conditions(Element, [Cond|Conds]) :-
    call(Cond, Element),
    satisfy_all_conditions(Element, Conds).


% Q3

second_max(List, 'Error: List must contain at least two distinct elements.') :-
    sort(List, Sorted), length(Sorted, Length), Length < 2, !.
second_max(List, SecondMax) :-
    sort(List, Sorted),
    reverse(Sorted, [Max, SecondMax|_]).

