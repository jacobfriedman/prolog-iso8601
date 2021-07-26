/*
    Author:        Jacob Friedman
    E-mail:        jacob@subsumo.com
    Copyright (C): 2021 Jacob Friedman. All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
may be used to endorse or promote products derived from this software without 
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

%   INCOMPLETE.
:-  module(iso8601, [date/3, time/2, instant/2]).
:-  dynamic(time_axis/3).

:-  initialization(setup).
%                       ...

/* <module> ISO8601-1:2019 date library

Date and time Representations for information interchange
Gregorian dates and times based on the 24-hour clock
based on composite character strings + time shifts, with UTC default.

@author Jacob Friedman
@license GPL
*/

setup :- assertz(time_axis('default',-inf, inf)).

% ------- ISO8601-1:2019 Part 1: Basic Rules -------
% 3.1 Terms and Definitions --> 3.1.1 Basic Concepts
% --------------------------------------------------
% ===========
% 3.1.1.1 *date*
% Format can be one of 'calendar', 'ordinal', or 'week'.
% !date(+Time:time, -Format:string, Time_Scale:time_scale) is det
% !date(-Time:time, +Format:string, Time_Scale:time_scale) is det

date(Time, Format, time_scale('calendar', _Origin, Instants, _Time_Axis)) :- 
%   TODO: denominate _Time_ and _Instants_ to a single format. 
    atom(Format),
    member(Time, Instants).


% ===========
% 3.1.1.2 *time*
% "mark attributed to an _instant_ or _time interval_ on a specified _time scale_"
%   Note 1: _time_ should be used *only if* its meaning is visible from the context.
%   Note 2: If _time scale_ consists of successive _time intervals_,
%         (e.g. _clock_ or _calendar_), distinct _instants_ may be expressed by the same _time_.
%   Note 3: This definition corresponds with the definition of term "date" in IEC 60050-113:
%    IEC 60050-113-01-12 date: mark attributed to an instant by means of a specified time scale
%       1: On a time scale consisting of successive steps, two distinct instants 
%          may be expressed by the same date (see Note 1 of the term “time scale” in 113-01-11).
%       2: With respect to the specified time scale, a date may also be considered as the duration between the origin of the time scale and the considered instant.
%       3: In common language, the term “date” is mainly used when the time scale is a calendar as a sequence of days."
%
%! time(+Instant:, +Time_Scale) is det
%! time(+Instant:, +Time_Scale) is det

time(Instant_or_Time_Interval, Time_Scale) :- 
    Time_Scale = time_scale(_,_,_,_),
    (Instant_or_Time_Interval = instant(_,_); Instant_or_Time_Interval = time_interval(_,_,_)).


% ===========
% 3.1.1.3 *instant*
% Note 1: An instantaneous event occurs at a specific instant

%! instant(+Point, +Time_Axis:time_axis) is det
instant(Point, Time_Axis) :-
    time_axis(_, Start, End) = Time_Axis,      
    between(Start, End, Point). 

% TODO: Check if the instant or time_interval is on the time_scale.

% ===========
% 3.1.1.4 *time axis*
%! time(+Name:string, +Start, +End) is det

time_axis(Name, Start, End) :- 
    string(Name),
    Start \== End.

% Note 1: According to the theory of special relativity: _time axis_ depends on the choice of a _spatial reference frame_.
% Note 2: In IEC 60050-113:2011, 113-01-03, time according to the space-time model is defined to be: 
%           "one-dimensional subspace of space-time, locally orthogonal to space."

% UTC, TAI, etc.
 % successors(Instantaneous_Events), member(Axis)?

% ===========
% 3.1.1.5 *time scale*
% system of ordered marks which can be attributed to _instants_ on the _time axis_, one instant chosen as _origin_.
% time_scale_types "may amongst others be chosen as" _TAI_, _UTC_, _calendar_, _discrete_, etc.
%! time_scale(+Scale_Type:string, ?Origin:instant, ?Instants:list, ?Time_Axis:time_axis) is det

% Default Time Scale
time_scale(Scale_Type, Origin, Instants, Time_Axis) :- 
    atom(Scale_Type),
    Origin = instant(_, _),
    % TODO: Ensure that these are all instants...
    is_list(Instants),
    Time_Axis = time_axis(_,_,_).


% Discrete Time Scale
% time_scale(Scale_Type, Origin, Instants, Time_Axis) :- 

% ===========
% 3.1.1.5 *time interval*
% "part of the _time_axis_ limited by two _instants_ and, unless otherwise stated, the limiting instants themselves."
%! time_interval(+Instant1:instant, +Instant2:instant, +Time_Axis:time_axis, -Time_Interval:time_interval) is det

time_interval(Instant1, Instant2, Time_Axis) :- 
%   TODO: Check that Instant1 and Instant2 are part of the Time_Axis   
    Time_Axis = time_axis(_Name, _Start, _End),
    Instant1  = instant(_Point, Time_Axis),
    Instant2  = instant(_Point2, Time_Axis).

% ===========
% 3.1.1.7 *time scale unit*
% "unit of measurement of a _duration_
%! time_scale_unit(+Duration, +Time_Scale, -Unit_of_Measurement) is det

time_scale_unit(Duration, Time_Scale, Unit_of_Measurement) :- 
    Duration    =   duration(_,_,_),
    Time_Scale  =   time_scale(_Scale_Type, _, _, _),
%   TODO: Use the Scale_Type to determine the Unit of Measurement
    atom(Unit_of_Measurement).

% ===========
% 3.1.1.8 *duration*
% "non-negative time quantity" = difference between final and initial _instants_ of a _time interval_
% ... Note 3: exact duration of a _time_scale_unit_ depends on the _time_scale_

%! duration(+Time_Interval:time_interval, +Time_Scale:time_scale, -Duration) is det

duration(Time_Interval, _Time_Scale, Duration) :- 
    Time_Interval = time_interval(_Instant1, _Instant2, _Time_Axis),
%   TODO: Convert Instant1 + Instant2 to Time Scale, Return Duration
    Duration > 0.



% ===========
% 3.1.1.9 *clock*
% "_time scale_ suited for intra-day time measurements"
% see time_scale.pl.

% ===========
% 3.1.1.10 *24-hour clock*
% see time_scale.pl.

% ===========
% 3.1.1.11 *recurring time interval*
% "series of consecutive _time intervals_ of identical _duration"
%! recurring_time_interval(+Consecutive_Time_Intervals:list) is det

recurring_time_interval --> 
    % minimum of 2 intervals
    [time_interval(_,_,_), time_interval(_,_,_)].
    % TODO: Include duration rule (below)

recurring_time_interval --> [time_interval(_,_,_)], recurring_time_interval.
% duration(Head_Interval, Time_Scale, Duration),
% Time_Scale, Duration...

%   note 1: "if duration(time intervals) measured in calendar entities, 
%   duration of each time interval depends on the calendar dates of start & end"



% ----- Part 2: Extensions -----