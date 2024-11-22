% Task A 
% CSI3120 lab 7 
% Written by:
% Oluwatobilba Ogunbi 300202843
% Tara Denaud 300318926 
% Sanika Sisodia 300283847 

:- dynamic book/4.
:- dynamic borrowed/4.

% Checks if the book does not already exist
add_book(Title, Author, Year, Genre) :-
    \+ book(Title, Author, Year, Genre),
    assertz(book(Title, Author, Year, Genre)).

% Removes a book from the library if it exists
remove_book(Title, Author, Year, Genre) :-
    book(Title, Author, Year, Genre),
    retract(book(Title, Author, Year, Genre)).

% Checks if a book is available for borrowing
is_available(Title, Author, Year, Genre) :-
    book(Title, Author, Year, Genre),
    \+ borrowed(Title, Author, Year, Genre).

% Allows borrowing of a book if it is available
borrow_book(Title, Author, Year, Genre) :-
    is_available(Title, Author, Year, Genre),
    assertz(borrowed(Title, Author, Year, Genre)).

% Marks a borrowed book as returned
return_book(Title, Author, Year, Genre) :-
    borrowed(Title, Author, Year, Genre),
    retract(borrowed(Title, Author, Year, Genre)).

% Retrieves all books written by a specific author
find_by_author(Author, Books) :-
    findall(Title, book(Title, Author, _, _), Books).

% Retrieves all books of a specific genre
find_by_genre(Genre, Books) :-
    findall(Title, book(Title, _, _, Genre), Books).

% Retrieves all books published in a specific year
find_by_year(Year, Books) :-
    findall(Title, book(Title, _, Year, _), Books).

% Suggests books of a particular genre
recommend_by_genre(Genre, Recommendations) :-
    find_by_genre(Genre, Recommendations).

% Suggests books by a specific author
recommend_by_author(Author, Recommendations) :-
    find_by_author(Author, Recommendations).
