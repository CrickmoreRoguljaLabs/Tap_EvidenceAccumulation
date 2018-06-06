%% Parameters
% Evidence standard deviation
theta = 1;

% Mean evidence of the two females (virgin: 0.8, mated: -0.35).
mu1 = 0.8;
mu2 = -0.35;

% Chance of tapping the mated female (experimentally determined but here
% we simulated a variety of possibilities).
chance_mu2 = 0 : 0.05 : 0.95;
nmu2 = chance_mu2 ./ (1 - chance_mu2);

% How many points to simulate (each is for a different tapping chance on
% the mated female)
N_points = length(chance_mu2);

% Number of iternations
N_repeats = 100000;

% Number of trials of choice assays (103 performed experimentally). This is
% the number of male flies per iteration in the simulation
ntrials = 103;

% Leak (1 = perfect accumulator, 0 = no accumulation)
leak = 1;

% Whether to plot each simulation or not (recommend not)
plotsim = 0;

% Number of taps before decisions (10 in this case)
n_taps = 10;


%% Simulation
% Initiate matrices to store simulated data for accumulators
f_mu1_acc_raw = NaN(N_points,N_repeats); % Fractions courting virgin females
f_mu2_acc_raw = NaN(N_points,N_repeats); % Fractions courting mated females
f_courted_acc_raw = NaN(N_points,N_repeats); % Fractions courting at all
F1_score_acc_raw = NaN(N_points,N_repeats); % F1 score of choosing the virgin female

% Initiate matrices to store simulated data for coin-flippers
f_mu1_strictcoin_raw = NaN(N_points,N_repeats); % Fractions courting virgin females
f_mu2_strictcoin_raw = NaN(N_points,N_repeats); % Fractions courting mated females
f_courted_strictcoin_raw = NaN(N_points,N_repeats); % Fractions courting at all
F1_score_strictcoin_raw = NaN(N_points,N_repeats); % F1 score of choosing the virgin female

% Initiate waitbar
hbar = waitbar(0,'Simulating...');

for i = 1 : N_points
    % Update waitbar
    waitbar(i/N_points)
    
    % Calculate courtship probabilities for coin-flippers
    CP1 = tapevid(theta, mu1, 100000, leak, 0 );
    CP2 = tapevid(theta, mu2, 100000, leak, 0 );
    
    % Simulation
    for j = 1 : N_repeats
        [f_mu1_acc_raw(i,j), f_mu2_acc_raw(i,j), f_courted_acc_raw(i,j), ~, F1_score_acc_raw(i,j) ]...
            = tapevid_2fly(theta, mu1, mu2, nmu2(i), ntrials, leak, n_taps, plotsim );
        [f_mu1_strictcoin_raw(i,j), f_mu2_strictcoin_raw(i,j), f_courted_strictcoin_raw(i,j), ~, F1_score_strictcoin_raw(i,j) ]...
            = tapevid_2fly_coin(CP1, CP2, nmu2(i), ntrials, n_taps, plotsim );
    end
end

close(hbar)

%% Process simulation data
% Initiate matrices to store simulated data for accumulators
f_mu1_acc_output = NaN(N_points,3); % Fractions courting virgin females
f_mu2_acc_output = NaN(N_points,3); % Fractions courting mated females
f_courted_acc_output = NaN(N_points,3); % Fractions courting at all
F1_score_acc_output = NaN(N_points,3); % F1 score of choosing the virgin female

% Initiate matrices to store simulated data for coin-flippers
f_mu1_strictcoin_output = NaN(N_points,3); % Fractions courting virgin females
f_mu2_strictcoin_output = NaN(N_points,3); % Fractions courting mated females
f_courted_strictcoin_output = NaN(N_points,3); % Fractions courting at all
F1_score_strictcoin_output = NaN(N_points,3); % F1 score of choosing the virgin female

% Average accumulator data over iterations
f_mu1_acc_output(:,1) = nanmean(f_mu1_acc_raw, 2); % Fractions courting virgin females
f_mu2_acc_output(:,1) = nanmean(f_mu2_acc_raw, 2); % Fractions courting mated females
f_courted_acc_output(:,1) = nanmean(f_courted_acc_raw, 2); % Fractions courting at all
F1_score_acc_output(:,1) = nanmean(F1_score_acc_raw, 2); % F1 score of choosing the virgin female

% Average coin-flipper data over iterations
f_mu1_strictcoin_output(:,1) = nanmean(f_mu1_strictcoin_raw, 2); % Fractions courting virgin females
f_mu2_strictcoin_output(:,1) = nanmean(f_mu2_strictcoin_raw, 2); % Fractions courting mated females
f_courted_strictcoin_output(:,1) = nanmean(f_courted_strictcoin_raw, 2); % Fractions courting at all
F1_score_strictcoin_output(:,1) = nanmean(F1_score_strictcoin_raw, 2); % F1 score of choosing the virgin female

% Loop through all the points (each with a different chance to tap on the
% mated female
for i = 1 : N_points
    % Get 95% confidence intervals for accumulators
    [f_mu1_acc_output(i,3), f_mu1_acc_output(i,2)]...
        = confint2(f_mu1_acc_raw(i,:)); % Fractions courting virgin females
    [f_mu2_acc_output(i,3), f_mu2_acc_output(i,2)]...
        = confint2(f_mu2_acc_raw(i,:)); % Fractions courting mated females
    [f_courted_acc_output(i,3), f_courted_acc_output(i,2)]...
        = confint2(f_courted_acc_raw(i,:)); % Fractions courting at all
    [F1_score_acc_output(i,3), F1_score_acc_output(i,2)]...
        = confint2(F1_score_acc_raw(i,:)); % F1 score of choosing the virgin female
    
    % Get 95% confidence intervals for coin-flippers
    [f_mu1_strictcoin_output(i,3), f_mu1_strictcoin_output(i,2)]...
        = confint2(f_mu1_strictcoin_raw(i,:)); % Fractions courting virgin females
    [f_mu2_strictcoin_output(i,3), f_mu2_strictcoin_output(i,2)]...
        = confint2(f_mu2_strictcoin_raw(i,:)); % Fractions courting mated females
    [f_courted_strictcoin_output(i,3), f_courted_strictcoin_output(i,2)]...
        = confint2(f_courted_strictcoin_raw(i,:)); % Fractions courting at all
    [F1_score_strictcoin_output(i,3), F1_score_strictcoin_output(i,2)]...
        = confint2(F1_score_strictcoin_raw(i,:)); % F1 score of choosing the virgin female
    
end

%% Display data
disp('==================Accumulators==================')
disp('Fractions of accumulators courting virgin females:')
array2table(f_mu1_acc_output, 'VariableNames',{'Mean','Upperbound','Lowerbound'})

disp('Fractions of accumulators courting mated females:')
array2table(f_mu2_acc_output, 'VariableNames',{'Mean','Upperbound','Lowerbound'})

disp('Fractions of accumulators courting any females:')
array2table(f_courted_acc_output, 'VariableNames',{'Mean','Upperbound','Lowerbound'})

disp('Accumulator F1 scores:')
array2table(F1_score_acc_output, 'VariableNames',{'Mean','Upperbound','Lowerbound'})

disp('==================Coin-flippers==================')
disp('Fractions of coin-flippers courting virgin females:')
array2table(f_mu1_strictcoin_output, 'VariableNames',{'Mean','Upperbound','Lowerbound'})

disp('Fractions of coin-flippers courting mated females:')
array2table(f_mu2_strictcoin_output, 'VariableNames',{'Mean','Upperbound','Lowerbound'})

disp('Fractions of coin-flippers courting any females:')
array2table(f_courted_strictcoin_output, 'VariableNames',{'Mean','Upperbound','Lowerbound'})

disp('Coin-flipper F1 scores:')
array2table(F1_score_strictcoin_output, 'VariableNames',{'Mean','Upperbound','Lowerbound'})