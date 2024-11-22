% Task A 
% CSI3120 lab 7 
% Written by:
% Oluwatobilba Ogunbi 300202843
% Tara Denaud 300318926 
% Sanika Sisodia 300283847 

% Question 1

% Start point for the console (user input)
right_angle_triangle_console :-
    write('Enter the height of the right-angled triangle: '),
    read(N),       
    nl,
    triangle(N).   

% base case
triangle(0) :- !. 

% rec case
triangle(N) :-
    N > 0,
    triangle(N, 1).

triangle(0, _) :- !.
triangle(N, K) :-
    N > 0,
    print_stars(K),
    nl,
    K1 is K + 1,
    N1 is N - 1,
    triangle(N1, K1).

% printing the stars
print_stars(0) :- !.
print_stars(N) :-
    N > 0,
    write('*'),
    N1 is N - 1,
    print_stars(N1).

% Question 2
% base case
isosceles_triangle_pattern_file(0, _) :- !.

% main pred
isosceles_triangle_pattern_file(Height, Filename) :-
    open(Filename, write, Stream),
    write_isosceles_triangle(Height, 1, Stream),
    close(Stream),
    format('Isosceles triangle pattern written to file: ~w~n', [Filename]).

% base case for writing shit
write_isosceles_triangle(0, _, _) :- !.
write_isosceles_triangle(Height, CurrentRow, Stream) :-
    Height > 0,
    Spaces is Height - 1,
    Stars is 2 * CurrentRow - 1,
    print_spaces(Spaces, Stream),
    print_stars2(Stars, Stream),
    nl(Stream),
    NextRow is CurrentRow + 1,
    NextHeight is Height - 1,
    write_isosceles_triangle(NextHeight, NextRow, Stream).

% printing stars/spaces
print_stars2(0, _) :- !.
print_stars2(N, Stream) :-
    N > 0,
    write(Stream, '*'),
    N1 is N - 1,
    print_stars2(N1, Stream).


print_spaces(0, _) :- !. % for the spaces on each side
print_spaces(N, Stream) :-
    N > 0,
    write(Stream, ' '),
    N1 is N - 1,
    print_spaces(N1, Stream).