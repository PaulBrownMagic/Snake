:- object(game,
    imports(view_category)).

    :- uses(logtalk, [
            print_message/3
        ]).

    :- public(start/0).
    start :-
        bedsit::do(reset),
        apple::do(place),
        print_message(information, snake, 'GameOver'-false), !.
    start :-
        \+ bedsit::do(reset),
        board::size(S),
        HS is S//2,
        bedsit::init([ snake_direction(up)
                     , snake_head(coord(HS, HS))
                     , snake_body(DL-DL)
                     ]),
        apple::do(place),
        print_message(information, snake, 'GameOver'-false).

    :- public(turn/0).
    turn :-
        ( snake::do(eat), apple::do(place)
        ; snake::do(move)
        ).

    render(Sit) :-
        snake::whole_body(Snake, Sit),
        apple::location(Apple, Sit),
        print_message(information, snake, 'Snake'::Snake),
        print_message(information, snake, 'Apple'-Apple),
        ( is_gameover(Sit),
          print_message(information, snake, 'GameOver'-true)
        ; true).

    :- public(is_gameover/1).
    is_gameover(Sit) :-
        snake::head(Head, Sit),
        snake::body(Body, Sit),
        list::memberchk(Head, Body).

:- end_object.


:- object(reset,
    imports(action)).

    poss(Sit) :-
        game::is_gameover(Sit).

    retract_assert([ snake_head(_)
                   , snake_body(_)
                   , snake_direction(_)
                   , apple_location(_)
                   ]
                   ,
                   [ snake_direction(up)
                   , snake_head(coord(HS, HS))
                   , snake_body(DL-DL)
                   ]) :-
        board::size(S),
        HS is S//2.

:- end_object.
