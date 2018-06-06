function [f_mu1, f_mu2, f_courted, courtship_part_vec, F1_score ] = tapevid_2fly(theta, mu1, mu2, nmu2, ntrials, leak, n_taps, plotsim )
% tapevid_2fly simulates how an evidence-accumulating fly would perform in a
% two-female choice assay
%
% [f_mu1, f_mu2, f_courted, courtship_part_vec ] = tapevid_2fly(theta, mu1, mu2, nmu2, ntrials, leak, plotsim )
%
% Inputs:
% theta - standard deviation of evidence
% mu1 - mean evidence for fly 1
% mu2 - mean evidence for fly 2
% nmu2 - number of fly 2s (used to adjust tapping probability on the flies)
% ntrials - number of iterations for simulation
% leak - how much evidence is retained between taps (1 = perfect
% accumulation)
% n_taps - max number of taps used to make the decision
% plotsim - whether to plot each simulation (0 = no)
%
% Outputs
% f_mu1 - fraction of males courting fly 1
% f_mu2 - fraction of males courting fly 2
% f_courted - fraction of males courting at all
% F1_score - the F1 score of choosing fly 1 (1 = perfectly selective)
%% Simulation settings

% Default values
if nargin < 8 || isempty(plotsim) ==1
    plotsim = 1;
    
    if nargin < 7 || isempty(n_taps) ==1
        n_taps = 4;

        if nargin < 6 || isempty(leak) == 1
            leak = 1;

            if nargin < 5 || isempty(ntrials) ==1
                ntrials = 50000;            

                if nargin < 4 || isempty(nmu2) == 1
                    nmu2 = 1;

                    if nargin < 3 || isempty(mu2) == 1
                        ntrials = -0.35;

                        if nargin < 2 || isempty(mu1) == 1 
                            mu = 0.8;

                            if nargin < 1 || isempty(theta) == 1
                                theta = 1;
                            end
                        end
                    end

                end
            end
        end
    end
end

% Default 1 fly with mu1
nmu1 = 1;

% Additional parameters to play with
shift = 0;

%% Sort out which taps are on a mu1 or mu2 fly
% Ratio of the flies bearing the two mu's
nmu_ratio = nmu1/(nmu1 + nmu2);
mu_rand_mat = rand(ntrials, n_taps);
mu1_mat = mu_rand_mat < nmu_ratio;
mu2_mat = mu_rand_mat >= nmu_ratio;
mu_mat = mu1_mat * mu1 + mu2_mat * mu2;
mu_mat_ind = mu1_mat * 1 + mu2_mat * 2;


%% Sim
% Generate signal and noise
randmat = randn(ntrials, n_taps) + mu_mat + shift;
accrandmat = randmat;

% Accumulate with leak
for i = 2 : n_taps
    accrandmat(:,i) = accrandmat(:,i) + accrandmat(:,i-1) * leak;
end

% Initiation mat
theta2 = theta + shift;
Initmat = accrandmat >= theta2;

% Sort out oscilating trials
Initmat2 = cumsum(Initmat,2);
Initmat2 = Initmat2 > 0;

% Sort out when first courtship starts
first_initmat2 = [zeros(ntrials, 1), Initmat2];
first_initmat2 = diff(first_initmat2, 1, 2) == 1;

% Sort out who courted whom
courtship_part_vec = mu_mat_ind(first_initmat2);
f_courted = sum(courtship_part_vec > 0)/ntrials;
f_mu1 = sum(courtship_part_vec == 1)/ntrials;
f_mu2 = sum(courtship_part_vec == 2)/ntrials;


% Plot simulation parameters
if plotsim == 1
    figure
    [ybin, xbin] = hist(randmat(:), 100);
    plot(xbin, ybin/max(ybin),[theta2 theta2], [0 1.2]);
    xlim([-15 15])
end

% Initiation fraction
% Initfrac = mean(Initmat2,1);

%% F1 score
%
tap_mat = (1 - Initmat2 + first_initmat2) .* mu_mat_ind;
n_mu1_tap = sum(tap_mat(:) == 1);
n_mu2_tap = sum(tap_mat(:) == 2);

% Calculate fractions of data in each category
true_pos = sum(courtship_part_vec == 1) / n_mu1_tap;
false_pos = sum(courtship_part_vec == 2) / n_mu2_tap;
false_neg = 1 - true_pos;
true_neg = 1 - false_neg;

% Calculate precision and recall
prec = true_pos / (true_pos + false_pos);
recall = true_pos / (true_pos + false_neg);

% Calculate F1 score
F1_score = 2 * prec * recall / (prec + recall);
%}
end