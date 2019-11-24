:- if((
    current_logtalk_flag(prolog_dialect, swi),
    current_prolog_flag(gui, true)
)).


    :- initialization((
        logtalk_load_context(directory, Directory),
        assertz(logtalk_library_path(snake, Directory)),
        logtalk_load(snake(web_hooks)),
        logtalk_load(snake(chromium_app)),
        logtalk_load([ types(loader)
                     , random(loader)
                     , stripstate(loader)
                     , bedsit(loader)
                     ]),
        logtalk_load([ snake(board)
                     , snake(apple)
                     , snake(snake)
                     , snake(place)
                     , snake(game)
                     , snake(web_gui)
                     ]),
        game::start,
        define_events(after, bedsit, do(_), _, game),
        server::serve,
        open_chromium_app,
        halt
                 )).

:- else.

    :- initialization((
        write('(this example requires SWI-Prolog as the backend compiler)'), nl
    )).

:- endif.
