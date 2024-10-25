% CSI3120 lab 4 
% Written by:
% Oluwatobilba Ogunbi 300202843
% Tara Denaud 300318926 
% Sanika Sisodia 300283847 

% task num 2

% base case
sum_odd_numbers([], 0).

% recursive case
sum_odd_numbers([Head|Tail], Sum) :-
    Head mod 2 =:= 1,
    sum_odd_numbers(Tail, TailSum),
    Sum is Head + TailSum.

% skipping even numbers
sum_odd_numbers([Head|Tail], Sum) :-
    Head mod 2 =:= 0,
    sum_odd_numbers(Tail, Sum).


