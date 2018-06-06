%% Parameters
% mean evidence (-0.4, 0.8, or 1.5)
mu = 1.5;

% Standard deviation of evidence
theta = 1;

% Number of trials
ntrials = 5;

% Number of taps per trial
ntaps = 4;

%% Simulation
% Generate and accumulate evidence
randmat = randn(ntrials, ntaps) + mu;
randmat2 = cumsum(randmat,2);

%% Plotting
% Initate matrices to store reformatted data
accum_evi = zeros(ntrials, (ntaps-1)*2+1);
tap_num = zeros(ntaps * 2,1);

% Reformat data for plotting
accum_evi(:,1) = randmat2(:,1);
accum_evi(:,2) = randmat2(:,1);
tap_num(1) = 0;
tap_num(2) = 1;
tap_num(3) = 1;

for i = 1 : (ntaps-1)
    ind1 = (i-1)*2+1;
    ind2 = i*2;
    
    accum_evi(:,ind1:ind2) = repmat(randmat2(:,i),[1,2]);
    tap_num((ind1+3) : (ind2+3)) = i+1;
end

accum_evi(:,end) = randmat2(:,ntaps);
accum_evi = [zeros(2,ntrials);accum_evi'];

% Plot
plot(tap_num,accum_evi,'o-')
xlim([0 5])
xlabel('Tap number')
ylabel('Evidence')