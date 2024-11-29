% Task A 
% CSI3120 lab 8
% Written by:
% Oluwatobilba Ogunbi 300202843
% Tara Denaud 300318926 
% Sanika Sisodia 300283847 

:- use_module(library(dcg/basics)).


/* Dynamic predicates for destinations and expenses */
:- dynamic destination/4.
:- dynamic expense/3.

/* Add a destination */
add_destination(Name, StartDate, EndDate, Budget) :-
    assertz(destination(Name, StartDate, EndDate, Budget)).

/* Remove a destination */
remove_destination(Name) :-
    retractall(destination(Name, _, _, _)).

/* Add an expense */
add_expense(Destination, Category, Amount) :-
    assertz(expense(Destination, Category, Amount)).

/* Calculate total expenses for a destination */
total_expenses(Destination, Total) :-
    findall(Amount, expense(Destination, _, Amount), Amounts),
    sum_list(Amounts, Total).

/* Validate budget for a destination */
validate_budget(Destination) :-
    destination(Destination, _, _, Budget),
    total_expenses(Destination, Total),
    (   Total =< Budget
    ->  write('Within budget.'), nl
    ;   write('Over budget.'), nl
    ).

/* Filter destinations by date range */
filter_destinations_by_date(StartDate, EndDate) :-
    forall(
        (destination(Name, Start, End, _), Start @>= StartDate, End @=< EndDate),
        (write(Name), nl)
    ).

/* Filter expenses by category */
filter_expenses_by_category(Category) :-
    forall(
        expense(Destination, Category, Amount),
        (write(Destination), write(': '), write(Amount), nl)
    ).

/* Save journey to a file */
save_journey(File) :-
    open(File, write, Stream),
    forall(destination(Name, Start, End, Budget),
           format(Stream, 'destination(~q, ~q, ~q, ~q).~n', [Name, Start, End, Budget])),
    forall(expense(Destination, Category, Amount),
           format(Stream, 'expense(~q, ~q, ~q).~n', [Destination, Category, Amount])),
    close(Stream).

/* Load journey from a file */
load_journey(File) :-
    consult(File).



/* Command Parsing */

/* ADD DESTINATION */
command --> "add destination", blanks, string(Dest), blanks, 
             "from", blanks, string(Start), blanks, 
             "to", blanks, string(End), blanks, 
             "with budget", blanks, integer(Budget), eos,
             { atom_string(DestAtom, Dest),
               atom_string(StartDate, Start),
               atom_string(EndDate, End),
               add_destination(DestAtom, StartDate, EndDate, Budget),
               write('Destination added.'), nl }.

/* REMOVE DESTINATION */
command --> "remove destination", blanks, string(Dest), eos,
             { atom_string(DestAtom, Dest),
               remove_destination(DestAtom),
               write('Destination removed.'), nl }.

/* ADD EXPENSE */
command --> "add expense", blanks, string(Dest), blanks, 
             "for category", blanks, string(Category), blanks, 
             "with amount", blanks, integer(Amount), eos,
             { atom_string(DestAtom, Dest),
               atom_string(CatAtom, Category),
               add_expense(DestAtom, CatAtom, Amount),
               write('Expense added.'), nl }.

/* CHECK BUDGET */
command --> "check budget", blanks, string(Dest), eos,
             { atom_string(DestAtom, Dest),
               validate_budget(DestAtom) }.

/* FILTER DESTINATIONS BY DATE */
command --> "filter destinations by date", blanks, 
             "from", blanks, string(Start), blanks, 
             "to", blanks, string(End), eos,
             { atom_string(StartDate, Start),
               atom_string(EndDate, End),
               filter_destinations_by_date(StartDate, EndDate) }.

/* FILTER EXPENSES BY CATEGORY */
command --> "filter expenses by category", blanks, string(Category), eos,
             { atom_string(CatAtom, Category),
               filter_expenses_by_category(CatAtom) }.

/* SAVE JOURNEY */
command --> "save journey", blanks, "as", blanks, string(File), eos,
             { atom_string(FileName, File),
               save_journey(FileName),
               write('Journey saved.'), nl }.

/* LOAD JOURNEY */
command --> "load journey", blanks, "from", blanks, string(File), eos,
             { atom_string(FileName, File),
               load_journey(FileName),
               write('Journey loaded.'), nl }.

/* EXIT */
command --> "exit", eos, { write('Exiting...'), halt }.


/* Entry Point */
start :-
    write('Travel Planner: Type commands or "exit" to quit.'), nl,
    repeat,
    write('> '),
    read_line_to_string(user_input, Input),
    string_codes(Input, Codes),
    (   phrase(command, Codes)
    ->  true 
    ;   write('Invalid command.'), nl
    ),
    Input = "exit".
