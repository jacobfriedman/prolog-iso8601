
% 24-Hour Clock

time_scale("hourly", 0, Instants, time_axis("hourly", 0, 24)) :-
    between(0, 24, Instants).

time_scale("minutely", 0, Instants, time_axis("hourly", 0, 60)) :-
    between(0, 60, Instants).

time_scale("secondly", 0, Instants, time_axis("hourly", 0, 60)) :-
    between(0, 60, Instants).


