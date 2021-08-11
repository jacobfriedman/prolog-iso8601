
% ===========
% 3.1.1.9 clock
% "_time scale_ suited for intra-day time measurements"
/*
time_scale('clock', Origin, Instants, Time_Axis) :- true. 

% 24-Hour Clock
clock("24-hour", Clock) :- 
    Clock is time_scale('clock', Origin, Instants, Time_Axis).
*/
% Foreword pg. 5 
% "disallowing the value “24” for hour;"
time_scale("hourly", 0, Instants, time_axis(real,_)) :-
    Instants::real(0, 24),
    {Instants < 24}.


/*
time_scale("minutely", 0, Instants, time_axis(real,_)) :-
    between(0, 60, Instants).

time_scale("secondly", 0, Instants, time_axis(real,_)) :-
    between(0, 60, Instants).
*/

