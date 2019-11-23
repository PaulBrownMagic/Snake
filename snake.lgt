:- object(snake,
    imports([actor, fluent_predicates])).

    action(move/0).
    action(eat/0).
    action(up/0).
    action(down/0).
    action(left/0).
    action(right/0).

    fluent(head/2).
    fluent(body/2).
    fluent(body_dl/2).
    fluent(whole_body/2).
    fluent(direction/2).

    :- public(head/2).
    head(Head, Sit) :-
        bedsit::holds(snake_head(Head), Sit).

    :- public(body/2).
    body(Body, Sit) :-
        bedsit::holds(snake_body(Body-[]), Sit).

    :- public(body_dl/2).
    body_dl(Body, Sit) :-
        bedsit::holds(snake_body(Body), Sit).

    :- public(whole_body/2).
    whole_body([Head|Body], Sit) :-
        body(Body, Sit),
        head(Head, Sit).

    :- public(direction/2).
    direction(Direction, Sit) :-
        bedsit::holds(snake_direction(Direction), Sit).

    :- public(move/5).
    move(up, coord(X, Y), Body, coord(X, NY), NewBody) :-
        YY is Y - 1,
        ( YY < 1, board::size(NY)
        ; YY = NY
        ), !,
        difflist::add(coord(X, Y), Body, NewBody).

    move(down, coord(X, Y), Body, coord(X, NY), NewBody) :-
        YY is Y + 1,
        ( board::size(H), YY > H, NY = 1
        ; YY = NY
        ), !,
        difflist::add(coord(X, Y), Body, NewBody).

    move(left, coord(X, Y), Body, coord(NX, Y), NewBody) :-
        XX is X - 1,
        ( XX < 1, board::size(NX)
        ; NX = XX
        ), !,
        difflist::add(coord(X, Y), Body, NewBody).

    move(right, coord(X, Y), Body, coord(NX, Y), NewBody) :-
        XX is X + 1,
        ( board::size(W), XX > W, NX = 1
        ; NX = XX
        ), !,
        difflist::add(coord(X, Y), Body, NewBody).

:- end_object.


:- object(eat,
    imports(action)).

    poss(Sit) :-
        snake::head(Location, Sit),
        apple::location(Location, Sit).

    retract_fluents([snake_body(_), snake_head(_)]).
    assert_fluents([snake_body(NewBody), snake_head(NewHead)]) :-
        snake::holds(head(Head)),
        snake::holds(body_dl(Body)),
        snake::holds(direction(Direction)),
        snake::move(Direction, Head, Body, NewHead, NewBody).

:- end_object.


:- object(move,
    imports(action)).

    poss(Sit) :-
        \+ eat::poss(Sit).

    retract_fluents([snake_body(_), snake_head(_)]).
    assert_fluents([snake_body(NewBody), snake_head(NewHead)]) :-
        snake::holds(head(Head)),
        snake::holds(body_dl([_|Body]-Hole)),
        snake::holds(direction(Direction)),
        snake::move(Direction, Head, Body-Hole, NewHead, NewBody).

:- end_object.


:- object(up,
    imports(action)).

   poss(Sit) :-
       snake::direction(Direction, Sit),
       ( Direction == left ; Direction == right ).

   retract_fluents([snake_direction(_)]).
   assert_fluents([snake_direction(up)]).

:- end_object.


:- object(down,
    imports(action)).

   poss(Sit) :-
       snake::direction(Direction, Sit),
       ( Direction == left ; Direction == right ).

   retract_fluents([snake_direction(_)]).
   assert_fluents([snake_direction(down)]).

:- end_object.


:- object(left,
    imports(action)).

   poss(Sit) :-
       snake::direction(Direction, Sit),
       ( Direction == up ; Direction == down ).

   retract_fluents([snake_direction(_)]).
   assert_fluents([snake_direction(left)]).

:- end_object.


:- object(right,
    imports(action)).

   poss(Sit) :-
       snake::direction(Direction, Sit),
       ( Direction == up ; Direction == down ).

   retract_fluents([snake_direction(_)]).
   assert_fluents([snake_direction(right)]).

:- end_object.
