% Task A
% Base case for 0
factorial(0, Acc, Acc)

% invalid input base case
factorial(N, _, 'Invalid'):-
    N < 0.

% recursive case
factorial(N, Acc, Result):-
    N > 0,
    NewN is N - 1,
    NewAcc is Acc * N,
    factorial(NewN, NewAcc, Result).

%validation
factorial(N, Acc, Result):-
    \+ integer(N),
    Result = 'Invalid'.
    