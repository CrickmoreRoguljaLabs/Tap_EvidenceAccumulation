function [ CP, R2, Initfrac ] = tapevid(theta, mu, ntrials, leak, plotsim )
% tapevid simulates the linear evidence accumulation between taps.
%
% [ CP, R2, Initfrac ] = tapevid(theta, mu, ntrials, leak, plotsim )
%
% Inputs:
% theta - standard deviation of evidence
% mu - mean evidence
% ntrials - number of iterations for simulation
% leak - how much evidence is retained between taps (1 = perfect
% accumulation)
% plotsim - whether to plot each simulation (0 = no)
%
% Outputs
% CP - the equavalent courtship probability if the data is analyzed as a
% coin
% R2 - the equavalent R square if the data is analyzed as a coin
% Initfrac - fraction of courtship after each tap (cumulative)

%% Simulation settings

% Default values
if nargin < 5 || isempty(plotsim) == 1
    plotsim = 1;
    
    if nargin < 4 || isempty(leak) == 1
        leak = 1;

        if nargin < 3 || isempty(ntrials) == 1
            ntrials = 50000;

            if nargin < 2 || isempty(mu) == 1 
                mu = 0.9;

                if nargin < 1 || isempty(theta) == 1
                    theta = 1;
                end
            end
        end

    end
end

% Additional parameters to play with
shift = 0;
lambda = 1; % Noise modifier

%% Sim
% Generate signal and noise
randmat = lambda * randn(ntrials, 4) + mu + shift;
accrandmat = randmat;

% Accumulate with leak
for i = 2 : 4
    accrandmat(:,i) = accrandmat(:,i) + accrandmat(:,i-1) * leak;
end

% Initiation mat
theta2 = theta + shift;
Initmat = accrandmat >= theta2;

% Sort out oscilating trials
Initmat2 = cumsum(Initmat,2);
Initmat2 = Initmat2 > 0;

% Plot simulation parameters
if plotsim == 1
    figure
    [ybin, xbin] = hist(randmat(:), 100);
    plot(xbin, ybin/max(ybin),[theta2 theta2], [0 1.2]);
    xlim([-15 15])
    xlabel('Evidence supporting courtship')
    legend({'Evidence distribution'; 'Threshold'})
end

% Initiation fraction
Initfrac = mean(Initmat2,1);

%% Transformation
% Initial transformation
X = 1 : 4;
Y = -log(1-Initfrac);

% Remove infinities
X2 = X(Initfrac < 1);
Y2 = Y(Initfrac < 1);

% Calculate CP and R2
slope = X2' \ Y2';
CP = 1 - exp(-slope);

Ycalc = X2 * slope;
R2 = 1 - sum((Y2 - Ycalc).^2)...
        /sum((Y2 - mean(Y2)).^2);

end