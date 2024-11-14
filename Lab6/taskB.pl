% task B

taller_than([], _, _, 'No match found.').
taller_than([person(Name, Height, Age)|_], MinHeight, age_in_range(Min, Max), person(Name, Height, Age)) :-
    Height > MinHeight,
    Age >= Min,
    Age < Max, !.
taller_than([_|T], MinHeight, AgeRange, Result) :-
    taller_than(T, MinHeight, AgeRange, Result).

