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
:-  module(iso8601, [date/3, time/3, instant/2]).
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
%
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
%! time(+Instant, +Time_Scale, ?Mark) is nondet
%! time(+Instant, +Time_Scale, ?Mark) is nondet

time(Instant_or_Time_Interval, Time_Scale, Mark) :- 
    Time_Scale = time_scale(_,_,_,_),
    member(Instant_or_Time_Interval, 
    [
            instant(_,_), 
            time_scale(_,_,_,_)
    ]).

% ===========
% 3.1.1.3 *instant*
% Note 1: An instantaneous event occurs at a specific instant

%! instant(+Point, +Time_Axis:time_axis) is semidet
instant(Point, Time_Axis) :-
    time_axis(_, Start, End) = Time_Axis,      
    between(Start, End, Point). 

% TODO: Check if the instant or time_interval is on the time_scale.

% ===========
% 3.1.1.4 *time axis*
%! time(+Name:string, +Start, +End) is semidet

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
%! time_scale(+Scale_Type:string, ?Origin:instant, ?Instants:list, ?Time_Axis:time_axis) is nondet

% Default Time Scale
time_scale(Scale_Type, Origin, Instants, Time_Axis) :- 
    % TODO: Include Basic_Unit as a 
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

time_interval(Instant1, Instant2) :- 
%   TODO: Check that Instant1 and Instant2 are part of the Time_Axis   
    Instant1  = instant(_Point_1, Time_Axis),
    Instant2  = instant(_Point_2, Time_Axis).

% ===========
% 3.1.1.7 *time scale unit*
% "unit of measurement of a _duration_
%! time_scale_unit(+Duration, +Time_Scale, -Unit_of_Measurement) is semidet

time_scale_unit(Duration, Time_Scale, Unit_Of_Measurement) :- 
    Duration    =   duration(_,_,_),
    Time_Scale  =   time_scale(_Scale_Type, _, _, _),
%   TODO: Use the Scale_Type to determine the Unit of Measurement
%           i.e conversion
    atom(Unit_Of_Measurement).

% ===========
% 3.1.1.8 *duration*
% "non-negative time quantity" = difference between final and initial _instants_ of a _time interval_
% ... Note 3: exact duration of a _time_scale_unit_ depends on the _time_scale_

%! duration(+Time_Interval:time_interval, +Time_Scale:time_scale, -Time) is semidet

duration(Time_Interval, Time_Scale, Time) :-
    Time_Interval = time_interval(
                        instant(Point_1, Time_Axis), 
                        instant(Point_2, Time_Axis)
                    ),
    Quantity is (Point_2 - Point_1), Quantity > 0,
    Time = time(instant(Quantity, Time_Axis), Time_Scale).
    
% ===========
% 3.1.1.9 *clock*
% "_time scale_ suited for intra-day time measurements"
% see time_scale.pl.

% ===========
% 3.1.1.10 *24-hour clock*
% see time_scale.pl.

% ===========
% 3.1.1.11 *recurring time interval*

% "series of consecutive _time intervals_ of identical _duration?".
% "series of (consecutive _time intervals_ of identical _duration)?".
% ----- Better phrasing: series of durations, whereby each durations' time intervals are consecutive. 
% TODO: Include rules for recurring_time_intervals

recurring_time_interval(Time_Scale, Time_Scale_Unit) --> 
    [Time_Interval, Time_Interval]; 
    [Time_Interval], recurring_time_interval(X), 
    { 
        Time_Interval = time_interval(_,_,_) 
    }.

recurring_time_interval --> 
    [Time_Interval, Time_Interval]; 
    [Time_Interval], recurring_time_interval(X), 
    { Time_Interval = time_interval(_,_,_) }.

%   note 1: "if duration(time intervals) measured in calendar entities, 
%   duration of each time interval depends on the calendar dates of start & end"
% ...

% ===========
% 3.1.1.12 *UTC*
% 3.1.1.12 *Coordinated Universal Time*
% TODO: Integrate _offset_
utc(Time_Scale) :- 
    % TODO: Update Time_Axis,  assertz(time_scale...)
    Time_Scale = time_scale('UTC', instant(-inf, Time_Axis), [], Time_Axis).

% 3.1.1.12.1 *TAI* International Atomic Time
% TODO: Update according to axioms in ISO doc.
tai(Time_Scale) :- 
    % TODO: Update Time_Axis, assertz(time_scale...)
    Time_Scale = time_scale('TAI', instant(-inf, Time_Axis), [], Time_Axis).


% ===========
% 3.1.1.13 *UTC of day*
% TODO: Hook up conversion of "now" in unix
utc_of_day(Time_Of_Day) :-
    time(
        Instant, % Instant along axis
        time_scale('UTC', instant(-inf, Time_Axis), [], Time_Axis)
        Time_Of_Day % Mark
    ).

% ===========
% 3.1.1.14 *Standard Time*
% "_time_scale_ derived from _UTC_ by a _time_shift_"

standard_time(Time_Scale, Time_Shift) :- 
    % Include the Time_Shift established 'in a given location by the competent authority'
    % e.g. Daylight Savings Time
    true.

% ===========
% 3.1.1.15 *Local Time Scale*
% "locally applicable _time_scale_ "
local_time_scale(Time_Scale, Time_Shift) :- 
    true.

% ===========
% 3.1.1.16 *Time of Day*
% "_time_of_day_ in a _local_time_scale_"
time_of_day(Local_Time_Scale) :- 
    true.

% ===========
% 3.1.1.18 *Calendar*
% "_time_scale_ that uses the _time_scale_unit_ of _calendar_day_ as its basic unit"
% TODO: Define 'Basic Unit'... is this equivalent to a 'Mark'?

calendar(Time_Scale) :- true.
% TODO: Update Time_Axis, assertz(time_scale...)
% TODO: Include Basic_Unit
% Note: _calendar_month_ and _calendar_year_ are time scale units often included in a calendar.
% We learn that time_scales can now INCLUDE other time scales.

% ===========
% 3.1.1.19 *Gregorian Calendar*
% "_calendar_ in general use that defines a _calendar_year_ which approximates the tropical year"

gregorian_calendar(Calendar_Time_Scale) :- 
    Calendar_Year = "YYYY",
    Calendar_Time_Scale = calendar(Time_Scale).
    % TODO: Include the appropriate systems of time scales

% Note: "Gregorian calendar" refers to the _time_scale_ in this doc

% ===========
% 3.1.1.20 *Common Year*
% "_calendar_year_ in _gregorian_calendar_ that has 365 _calendar_days_"

common_year(Calendar_Year_Time_Scale_Unit, Gregorian_Calendar) :-
    % Calendar
    Gregorian_Calendar = gregorian_calendar(Gregorian_Time_Scale).
    % TODO: Pull the _Calendar_Year_ scale from the Gregorian Time Scale
    % Assert 365 Days

% ===========
% 3.1.1.21 *Leap Year*
% "_calendar_year_ in _gregorian_calendar_ that has 366 _calendar_days_"
leap_year(Calendar_Year_Time_Scale_Unit, Gregorian_Calendar) :-

    % Calendar
    Gregorian_Calendar = gregorian_calendar(Gregorian_Time_Scale).
    % TODO: Pull the _Calendar_Year_ scale from the Gregorian Time Scale
    % Assert 366 Days

% ===========
% 3.1.1.22 *Centennial Year*
% "_calendar_year_ in _gregorian_calendar_ whose year # is divisible without remainder by 100"
centennial_year(Calendar_Year_Time_Scale_Unit, Gregorian_Calendar) :-
    % Calendar
    Gregorian_Calendar = gregorian_calendar(Gregorian_Time_Scale),
    % TODO: Pull the _Calendar_Year_ scale from the Gregorian Time Scale
    % Assert mod 100


% ===========
% 3.1.1.23 *Week Calendar*
% "_calendar_ based on an unbounded series of contiNguous _calendar_weeks_ that uses
%   the _time_scale_unit_ of 'calendar week' as its basic unit to represent a _calendar_year,
%   according to the rule that the first calendar week of a calendar year is the week including 
%   the first Thursday of that year, and that the last one is the week imeediately preceding the
%   first calendar week of the next calendar year"

week_calendar(Calendar_Weeks, Time_Scale_Unit, Calendar_Year) :- 
    % Nice todo
    true.

% Note 1: Rule based on principle that a week belongs to the calendar year to which
% the majority of its _calendar_days_ belong.
% Note 2: calendar days of the first and last calendar week of a calendar year may belong to the
% previous and the next calendar year respectively in the _Gregorian_calendar_.


% ===========
% 3.1.1.24 *Leap Second*
 
% ===========
% 3.1.1.25 *Time Shift*
% "constant _duration_ difference between _times_ of two _time_scales_"
time_shift(Time_1, Time_2, Time_Scale_1, Time_Scale_2) :- true.
% TODO: Calculate duration difference after conversion of one time scale to another.



% 3.1 Terms and Definitions --> 3.1.2 Time and date units
% --------------------------------------------------
