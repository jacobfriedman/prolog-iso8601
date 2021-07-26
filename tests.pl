:- begin_tests(iso8601).
:- use_module(iso8601).

% 3.1.1.4
test(time_axis) :-
    iso8601:time_axis('default',-inf, inf).

% 3.1.1.3 *instant*
test(instant) :-
    instant( 4, time_axis("test_instant_time_axis", 0, 10) ),
    \+ instant( 80, time_axis("test_instant_time_axis", 0, 10) ),
    \+ instant( -80, time_axis("test_instant_time_axis", 0, 10) ).

% 3.1.1.11 *recurring time interval*
test(recurring_time_interval) :-
    phrase(
        iso8601:recurring_time_interval, 
            [   
                time_interval(1,2,3),
                time_interval(1,2,3)
            ]
        ).

:- end_tests(iso8601).

:- run_tests.