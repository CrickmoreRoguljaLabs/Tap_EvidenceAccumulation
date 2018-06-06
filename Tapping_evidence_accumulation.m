%% Parameters
% Number of iterations
ntrials = 100000;

% Default standard deviation of evidence
theta = 1; 

% Leak of evidence between taps (1 = perfect accumulation, 0 = no
% accumulation of evidence, i.e., coin)
leak = 1;

% Whether to plot simulation results or not
plotsim = 0;

%% Simulation
% Evidence means
mu_sweep = [-0.4 0.8 1.5];

% Number of sweeps
nsweeps = length(mu_sweep);

% Initiate matrices to store the equavalent courtship probabilities, R
% squares of fits, and fractions of initiations in the accumulation model
CPs_mu = zeros(nsweeps,1);
R2s_mu = zeros(nsweeps,1);
Initfracs_mu = zeros(nsweeps, 4);

for i = 1 : nsweeps
    % Perform simulations
    [ CPs_mu(i), R2s_mu(i), Initfracs_mu(i,:) ] = tapevid(theta, mu_sweep(i), ntrials, leak, plotsim );
end

% Plot the resulted linear courtship initiations
plot(1:4, -log(1-Initfracs_mu),'-o')
xlabel('Tap number')
ylabel('- Ln(1 - Fraction initiations)')
legend({'mu = -0.4', 'mu = 0.8','mu = 1.5'})