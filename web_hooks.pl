:- use_module(library(http/thread_httpd), [http_server/2]).
:- use_module(library(http/http_dispatch), [http_handler/3, http_dispatch/1]).
:- use_module(library(http/websocket), [http_upgrade_to_websocket/3, ws_send/2, ws_receive/2]).
:- use_module(library(http/http_files), [http_reply_from_files/3]).
:- use_module(library(http/html_write), [reply_html_page/2]).

:- dynamic user:file_search_path/2.
:- prolog_load_context(directory, Dir),
   assertz(user:file_search_path(snake_web, Dir)).

http:location(static, '/static', []).

:- http_handler(root(.), home, []).
:- http_handler(root(socket), http_upgrade_to_websocket(socket, []), [spawn([])]).
:- http_handler(static(.), http_reply_from_files(snake_web(static), []), [prefix]).

home(_R) :-
    home_page::get.

socket(Websocket) :-
    socket::instantiate(Instance, Websocket),
    Instance::receive.
