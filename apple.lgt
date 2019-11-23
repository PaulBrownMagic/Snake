:- object(apple,
    imports([actor, fluent_predicates])).

    action(place/0).
    fluent(location/2).

    :- public(location/2).
    location(Location, Sit) :-
        bedsit::holds(apple_location(Location), Sit).

:- end_object.

