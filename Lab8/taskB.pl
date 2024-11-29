% Task B 
% CSI3120 lab 8
% Written by:
% Oluwatobilba Ogunbi 300202843
% Tara Denaud 300318926 
% Sanika Sisodia 300283847 

/* Declare dynamic predicates to track game state */
:- dynamic mine/2, revealed/2, flagged/2.

/* Initialize the game: place 6 random mines on a 6x6 grid */
init_game :-
    retractall(mine(_, _)),
    retractall(revealed(_, _)),
    retractall(flagged(_, _)),
    assert_mines(6),
    write('Game initialized. Use reveal_cell(Row, Col) to reveal a cell.\n'),
    write('Use flag_cell(Row, Col) to flag a mine and unflag_cell(Row, Col) to unflag it.\n'),
    write('Use display_board to view the board.\n').

/* Randomly place N mines on the grid */
assert_mines(0).
assert_mines(N) :-
    N > 0,
    random(1, 7, Row),
    random(1, 7, Col),
    \+ mine(Row, Col),
    assert(mine(Row, Col)),
    N1 is N - 1,
    assert_mines(N1).

/* Reveal a cell */
reveal_cell(Row, Col) :-
    valid_cell(Row, Col),
    \+ revealed(Row, Col),
    \+ flagged(Row, Col),
    ( mine(Row, Col) ->
        write('Game Over! You hit a mine.\n'), display_board, fail
    ; count_adjacent_mines(Row, Col, Count),
      assert(revealed(Row, Col)),
      format('Cell ~w, ~w revealed. Adjacent mines: ~w.\n', [Row, Col, Count]),
      display_board,
      check_win
    ).

/* Flag a cell */
flag_cell(Row, Col) :-
    valid_cell(Row, Col),
    \+ revealed(Row, Col),
    \+ flagged(Row, Col),
    assert(flagged(Row, Col)),
    write('Cell flagged.\n'),
    display_board,
    check_win.

/* Unflag a cell */
unflag_cell(Row, Col) :-
    flagged(Row, Col),
    retract(flagged(Row, Col)),
    write('Cell unflagged.\n'),
    display_board.

/* Display the game board */
display_board :-
    forall(between(1, 6, Row), 
        (forall(between(1, 6, Col),
            (revealed(Row, Col) -> 
                (mine(Row, Col) -> write(' M ') 
                ; count_adjacent_mines(Row, Col, Count),
                  format(' ~w ', [Count])
                )
            ; flagged(Row, Col) -> write(' F ')
            ; write(' ? '))),
        nl)
    ).

/* Count adjacent mines around a cell */
count_adjacent_mines(Row, Col, Count) :-
    findall(1, adjacent_mine(Row, Col, _, _), Mines),
    length(Mines, Count).

/* Check for adjacent mines (8 directions) */
adjacent_mine(Row, Col, AdjRow, AdjCol) :-
    between(-1, 1, DR), between(-1, 1, DC),
    \+ (DR = 0, DC = 0),
    AdjRow is Row + DR,
    AdjCol is Col + DC,
    mine(AdjRow, AdjCol).

/* Check if all mines are flagged and no extra flags exist */
check_win :-
    findall((Row, Col), mine(Row, Col), Mines),
    findall((Row, Col), flagged(Row, Col), Flags),
    length(Mines, MineCount),
    length(Flags, FlagCount),
    MineCount =:= FlagCount,
    forall(member(Mine, Mines), member(Mine, Flags)),
    write('Congratulations! You have successfully flagged all mines.\n'), display_board, halt.

/* Validate if a cell is within grid boundaries */
valid_cell(Row, Col) :-
    between(1, 6, Row), between(1, 6, Col).

