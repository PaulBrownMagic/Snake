:- object(nondet_random,
    extends(fast_random)).

    between(Min, Max, B) :-
        ^^between(Min, Max, B)
    ;   between(Min, Max, B).

:- end_object.


:- object(place,
    imports(action)).

    poss(_).

    retract_fluents([apple_location(_)]).
    assert_fluents([apple_location(coord(X, Y))]) :-
        board::size(S),
        nondet_random::between(1, S, X),
        nondet_random::between(1, S, Y),
        snake::holds(whole_body(SnakeBody)),
        \+ list::memberchk(coord(X, Y), SnakeBody).

:- end_object.
