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
%                       ...

/** <module> ISO 8601 date library

ISO8601-1:2019 & ISO8601-2:2019
Date and time Representations for information interchange

Gregorian dates and times based on the 24-hour clock
based on composite character strings + time shifts, with UTC default.

@author Jacob Friedman
@license GPL

*/

initialization(time_axis).

% ----- ISO8601-1:2019 Part 1: Basic Rules -----

% 3.1 Terms and Definitions -> 3.1.1 Basic Concepts

% ------------
% 3.1.1.1 date
% !date(+Time:time, -Date:date, ++Options) is nondet
% !date(-Time:time, +Date:date, ++Options) is nondet

date(Time, Date, Format) :-  true. % time_scale(calendar)

% 3.1.1.2 time
% ------------
% time(+Instant:, +Time_Scale) is det
% "mark attributed to an _instant_ or _time interval_ on a specified _time scale_"
time(Instant_or_Time_Interval, Time_Scale) :- true. % Instant must be on a time scale

% Note 1: _time_ should be used only if meaning is visible from context.
% Note 2: If _time scale_ consists of successive _time intervals_,
%         (e.g. _clock_ or _calendar_), distinct _instants_ may be expressed by the same _time_.
% Note 3: This definition corresponds with the definition of term "date" in IEC 60050-113:
%    IEC 60050-113-01-12 date: mark attributed to an instant by means of a specified time scale
%       1: On a time scale consisting of successive steps, two distinct instants 
%          may be expressed by the same date (see Note 1 of the term “time scale” in 113-01-11).
%       2: With respect to the specified time scale, a date may also be considered as the duration between the origin of the time scale and the considered instant.
%       3: In common language, the term “date” is mainly used when the time scale is a calendar as a sequence of days."

% 3.1.1.3 instant
% ------------
% instant(+Point, +Time_Axis)
instant(Point, Time_Axis) :- true. % member(Axis)?
% Note 1: An instantaneous event occurs at a specific instant

% 3.1.1.4 time axis
% ------------
time_axis :- assert(time_axis('0000/P9999')). % successors(Instantaneous_Events), member(Axis)?

% Note 1: According to the theory of special relativity: _time axis_ depends on the choice of a _spatial reference frame_.
% Note 2: In IEC 60050-113:2011, 113-01-03, time according to the space-time model is defined to be: 
%           "one-dimensional subspace of space-time, locally orthogonal to space."

% ...

% ----- Part 2: Extensions -----