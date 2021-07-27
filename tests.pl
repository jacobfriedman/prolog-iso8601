:- begin_tests(iso8601).
:- use_module(iso8601).

% 3.1.1.2 *time*
test(time) :-
    time(instant(point(a),time_axis), time_scale(a,b,c,d)).


% 3.1.1.4
test(time_axis) :-
    iso8601:time_axis('default',-inf, inf).

% 3.1.1.3 *instant*
test(instant) :-
    instant( 4, time_axis("test_instant_time_axis", 0, 10) ),
    \+ instant( 80, time_axis("test_instant_time_axis", 0, 10) ),
    \+ instant( -80, time_axis("test_instant_time_axis", 0, 10) ).

% 3.1.1.11 *recurring time interval*
% recurring_time_interval
test(recurring_time_interval) :-

    /*
    Time_Axis = time_axis('default', Start, End),

    Instant_1       = instant(1, Time_Axis),
    Instant_2       = instant(2, Time_Axis),
    Instant_3       = instant(3, Time_Axis),
    Instant_4       = instant(4, Time_Axis),

    time_interval(Instant_1, Instant_2, Time_Axis),
    time_interval(Instant_2, Instant_3, Time_Axis),
    time_interval(Instant_3, Instant_4, Time_Axis),
    duration(Time_Interval, _Time_Scale, Duration) 
    TODO: Add Time Scale
    */

    phrase(
        iso8601:recurring_time_interval, 
            [   
                time_interval(1,2,3),
                time_interval(1,2,3),
                time_interval(1,2,3)
            ]
        ).

:- end_tests(iso8601).

:- run_tests.