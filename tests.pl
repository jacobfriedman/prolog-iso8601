:- begin_tests(iso8601).
:- use_module(iso8601).

% 3.1.1.3 *instant*

test(instant) :-
    instant( 4, time_axis("test_instant_time_axis", 0, 10) ),
    \+ instant( 80, time_axis("test_instant_time_axis", 0, 10) ),
    \+ instant( -80, time_axis("test_instant_time_axis", 0, 10) ).

:- end_tests(iso8601).

:- run_tests.