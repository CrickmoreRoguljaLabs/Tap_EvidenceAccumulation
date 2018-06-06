function [ lower_bound, upper_bound ] = confint2( input_vec , percent_interval)
%CONFINT finds the confidence interval of an input vector, based on the
%confidence percentage. The default percentage is 95%.
%   [ lower_bound, upper_bound ] = confint2( input_vec , percent_interval)

if nargin < 2
    percent_interval = 0.95;
end

% Vector size
N = length(input_vec);

% Edge fraction
edge = (1 - percent_interval)/2;
min_ind = round(edge * N);
max_ind = N - round(edge * N);

% Sortvector
sorted_vec = sort( input_vec );

% Output
lower_bound = sorted_vec(min_ind);
upper_bound = sorted_vec(max_ind);

end

