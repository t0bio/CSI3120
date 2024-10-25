% CSI3120 lab 4 
% Written by:
% Oluwatobilba Ogunbi 300202843
% Tara Denaud 300318926 
% Sanika Sisodia 300283847 

% task num 1

% parent to child relationships
parent(john, mary).
parent(john, tom).
parent(mary, ann).
parent(mary, fred).
parent(tom, liz).

% genders
male(john).
male(tom).
male(fred).
female(mary).
female(ann).
female(liz).

% sibling predicate
sibling(X, Y) :-
    parent(P, X),
    parent(P, Y),
    X \= Y.

% grandparent predicate
grandparent(GP, GC) :-
    parent(GP, P),
    parent(P, GC).

% ancestor predicate
ancestor(Anc, Desc) :-
    parent(Anc, Desc).
ancestor(Anc, Desc) :-
    parent(Anc, P),
    ancestor(P, Desc).


