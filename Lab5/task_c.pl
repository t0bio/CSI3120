% CSI3120 lab 4 
% Written by:
% Oluwatobilba Ogunbi 300202843
% Tara Denaud 300318926 
% Sanika Sisodia 300283847 

% next_to/3 helper predicate

next_to(X, Y, List) :-
    append(_, [X, Y | _], List).
next_to(X, Y, List) :-
    append(_, [Y, X | _], List).

% not_next_to/3 helper predicate
not_next_to(X, Y, List) :-
    \+ next_to(X, Y, List).

% puzzle
solve_puzzle(Houses, GreenIndex) :-
    % list of houses
    Houses = [_, _, _, _],
    
    % permutations of the houses
    permutation([red, blue, green, yellow], Houses),

    % clue 1
    next_to(red, blue, Houses),

    % clue 2
    nth1(GreenIndex, Houses, green),

    % clue 3
    not_next_to(yellow, green, Houses),

    % clue 4
    GreenIndex \= 2.
