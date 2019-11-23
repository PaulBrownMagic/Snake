:- object(server).

    :- use_module(thread_httpd, [http_server/2]).
    :- use_module(http_dispatch, [http_dispatch/1]).
    :- use_module(websocket, [ws_send/2]).

    :- meta_predicate(thread_httpd:http_server(1, *)).
    :- public(serve/0).
    serve :-
        http_server(http_dispatch, [port(8000)]).


    :- multifile(logtalk::message_hook/4).
    :- dynamic(logtalk::message_hook/4).
    logtalk::message_hook('Snake'::Coords, information, snake, _Tokens) :-
        meta::map(coord_json, Coords, Snake),
        broadcast(json(json{snake: Snake})).
    logtalk::message_hook('Apple'-coord(X, Y), information, snake, _Tokens) :-
        broadcast(json(json{apple: coord{x: X, y: Y}})).
    logtalk::message_hook('GameOver'-State, information, snake, _Tokens) :-
        broadcast(json(json{gameover: State})).

    coord_json(coord(X, Y), coord{x: X, y: Y}).

    broadcast(Msg) :-
        forall(instantiates_class(Inst, socket),
                ( Inst::websocket(WS), ws_send(WS, Msg))
              ).

:- end_object.


:- object(home_page).
    :- use_module(html_write, [reply_html_page/2]).
    :- meta_predicate(html_write:reply_html_page(*, *)).

    :- public(get/0).
    get :-
        board::size(Size),
        format(atom(Store),
            "const store = { snake: [], apple: {x: 0, y: 0}, gameover: true, tile_count: ~d }",
            Size),
        reply_html_page(
            [ title('Snake')
            , link([href('/static/bootstrap.min.css'), rel(stylesheet)])
            , link([href('/static/snake.css'), rel(stylesheet)])
            ],
            [ div(class([container, 'mt-4']),
                [ div(class([jumbotron, 'bg-dark']), h1(class(['text-white', 'display-4']), 'Snake'))
                , div([])
                ])
            , script([], Store)
            , script([src('/static/jquery-3.4.1.min.js')],[])
            , script([src('/static/bootstrap.bundle.min.js')], [])
            , script([src('/static/p5.min.js')], [])
            , script([src('/static/snake.js')], [])
            ]).

:- end_object.


:- object(metasocket,
    instantiates(metasocket)).

    :- info([ version is 1.0
            , author is 'Paul Brown'
            , date is 2019/10/2
            , comment is 'An object describing a class with an instantiate method for creating instances and importing methods to traverse the subsumption heirarchy.'
            ]).

    :- public(instantiate/2).
    :- mode(instantiate(-object, +list), zero_or_one).
    :- info(instantiate/2,
        [ comment is 'Create a new instance of self'
        , argnames is ['Instance', 'Clauses']
        ]).
    instantiate(Instance, WS) :-
        self(Class),
        create_object(Instance, [instantiates(Class)], [], [websocket(WS)]).

:- end_object.


:- object(socket,
    instantiates(metasocket)).
    :- use_module(websocket, [ws_receive/2]).

    :- public(websocket/1).

    :- public(receive/0).
    receive :-
        ::websocket(WS),
        ws_receive(WS, Message),
        ( Message.opcode == close, self(Self), abolish_object(Self)
        ; Data = Message.get(data),
          handle(Data),
          receive
        ).

    handle("refresh") :-
        bedsit::situation(S), game::render(S).
    handle("move") :-
        game::turn.
    handle("start") :-
        game::start.
    handle(Dir) :-
        list::memberchk(Dir, ["up", "down", "left", "right"]),
        atom_string(Direction, Dir),
        (snake::do(Direction) ; true).

:- end_object.
