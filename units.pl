% 3.1 Terms and Definitions --> 3.1.2 Time and date units
% --------------------------------------------------

% ===========
% 3.1.2.1 *Second*
% "base unit of _duration_ measurement in the International System of Units (SI)"
% See line 167
% TODO: Do we have a huge integer? Everything can be measured in seconds...
duration(
    time_interval(
        instant(0,time_axis(finite, , _))
    )
).
% ===========
% 3.1.2.2 *Clock Second*
% "base unit of _duration_ measurement in the International System of Units (SI)"


time_scale_unit(clock_second, Time_Scale, Duration) :- 
    %
    Time_Scale  = time_scale(secondly, _, _, Time_Axis, second), 
    Time_Axis   = time_axis(finite, _, _),
    Duration    = duration(
                    _,
                    _, 
                    time(
                        instant(1, Time_Axis),
                        Time_Scale,
                        '1'
                    )

% ===========
% 3.1.2.2 *minute*
% "_duration_ of 60 _seconds_"

time_scale_unit(minute, 
    time_scale(secondly, _, _, time_axis(finite, _, _), second), 
    duration(_,_, time(instant(60, time_axis(finite, _, _)),
    time_scale(secondly, _, _, time_axis(finite, _, _), second))) :- true. 

                    % ===========
% 3.1.2.2 *minute*
% "_duration_ of 60 _seconds_"

time_scale_unit(minute, 
    time_scale(secondly, _, _, time_axis(finite, _, _), second), 
    duration(_,_, time(instant(60, time_axis(finite, _, _)),
    time_scale(secondly, _, _, time_axis(finite, _, _), second))) :- true. 