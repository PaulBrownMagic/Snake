:- if((
    current_logtalk_flag(prolog_dialect, swi),
    current_prolog_flag(gui, true)
)).


    :- initialization((
        consult(web_hooks),
        consult(chromium_app),
        logtalk_load([ types(loader)
                     , random(loader)
                     , stripstate(loader)
                     , bedsit(loader)
                     ]),
        logtalk_load([ board
                     , apple
                     , snake
                     , place
                     , game
                     , web_gui
                     ]),
        game::start,
        define_events(after, bedsit, do(_), _, game),
        server::serve,
        open_chromium_app
                 )).

:- else.

    :- initialization((
        write('(this example requires SWI-Prolog as the backend compiler)'), nl
    )).

:- endif.
