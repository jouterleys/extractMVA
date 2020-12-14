function data_critical_array = critDampFilter(data_raw_array,sampling_frequency,cutoff_frequency,filter_passes,visualise)
% critDampFilter implements a zerolag critically-damped recursive IIR
% filter based on equations from Robertson et al. 2003.
%
% Inputs:
%   data_raw_array - raw data to be filtered.
%   sampling_frequency - sampling frequency of raw data [Hz].
%   cutoff_frequency - cut-off frequency to be used [Hz].
%   filter_passes - number of filter passes, i.e. filter order.
%   visualise - [0 or 1]: to turn on or off a plot to visualise the raw vs.
%   filtered data.
%
% Outputs:
%   data_critical_array - filtered data. 


% All code for this script was created by Jarrod Blinch ~ June 12, 2015 and
% can be found at https://motorbehaviour.wordpress.com/. I take no credit
% for the creation of the original implementation of Jarrod's code. I will
% use it assuming that it is Licensed under the MIT License, as it seems
% reasonble since it's in the public domain. This language is also added to
% License file contained in the root of this toolbox.

% Copyright (c) <2020> <Jereme Outerleys> Licensed under the MIT License.
% See LICENSE in the project root for license information.


% Create copy of raw array.
data_raw_copy_array = data_raw_array;

% Maintain the cutoff frequency by adjusting for multiple passes (i.e. 10 Hz becomes 12.4650 Hz).
c_critical = 1 / (((2^(1/(2*filter_passes)))-1)^(1/2));
f_adjusted_critical = cutoff_frequency * c_critical; % 10 Hz becomes 22.9896 Hz
w_adjusted_critical = tan(pi*f_adjusted_critical/sampling_frequency);

k1_critical = 2 * w_adjusted_critical;
k2_critical = w_adjusted_critical^2;

a0_critical = k2_critical / (1 + k1_critical + k2_critical);
a2_critical = a0_critical;
a1_critical = 2 * a0_critical;

b1_critical = 2 * a0_critical * (1/k2_critical - 1);
b2_critical = 1 - (a0_critical + a1_critical + a2_critical + b1_critical);

%display(a0_critical + a1_critical + a2_critical + b1_critical + b2_critical);

% Convert the coefficients to B and A. There is no Matlab command to compare these to, but we will use them later.
% B_manual_critical = [ a0_critical a1_critical a2_critical ];
% A_manual_critical = [ 1 -b1_critical -b2_critical ];

% Filter the data.
data_critical_array = ones(size(data_raw_array)) .* NaN;

% First pass in the forward direction.
for x = 1:size(data_raw_array,1)
    if (x >= 3)
        data_critical_array(x) = a0_critical*data_raw_array(x) + a1_critical*data_raw_array(x-1) + a2_critical*data_raw_array(x-2) + b1_critical*data_critical_array(x-1) + b2_critical*data_critical_array(x-2);
    elseif (x == 2)
        data_critical_array(x) = a0_critical*data_raw_array(x) + a1_critical*data_raw_array(x-1) + b1_critical*data_critical_array(x-1);
    else
        data_critical_array(x) = a0_critical*data_raw_array(x);
    end
end

% Flip the data for the second pass.
data_raw_array = data_critical_array(end:-1:1); % this is now the once filtered data
data_critical_array = ones(size(data_raw_array)) .* NaN;

% Second pass.
for x = 1:size(data_raw_array,1)
    if (x >= 3)
        data_critical_array(x) = a0_critical*data_raw_array(x) + a1_critical*data_raw_array(x-1) + a2_critical*data_raw_array(x-2) + b1_critical*data_critical_array(x-1) + b2_critical*data_critical_array(x-2);
    elseif (x == 2)
        data_critical_array(x) = a0_critical*data_raw_array(x) + a1_critical*data_raw_array(x-1) + b1_critical*data_critical_array(x-1);
    else
        data_critical_array(x) = a0_critical*data_raw_array(x);
    end
end

% Flip the data back.
data_critical_array = data_critical_array(end:-1:1);

if visualise == 1
    % Plot the results.
    figure;
    hold on;
    plot(data_raw_copy_array, 'r');
    plot(data_critical_array, 'b');
    legend('Raw','Critically damped');
end