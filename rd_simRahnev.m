% rd_simRahnev.m
%
% What will happen to the mean and std of confidence distributions when
% there is only a criterion shift?

%% setup
% actual brain signal (target present trials only)
signal = randn(1000,1);
attSignal = signal;

% unattended signal same as attended signal
unattSignal = attSignal;

% unattended signal higher variance than attended signal
% unattSignal = signal*1.5;

% ignore the left tail, where people are making the wrong response
% signal(signal<-1) = [];
attSignal(attSignal<-1) = [];
unattSignal(unattSignal<-1) = [];
nAtt = numel(attSignal);
nUnatt = numel(unattSignal);

% assume people give ratings using many critera
% here we see what happens when criteria are lower for unattended trials
attCrit = -1:0.5:2;

% fixed criteria
% unattCrit = attCrit;

% shifting the criteria
% unattCrit = attCrit-0.4;
% unattCrit = [unattCrit unattCrit(end) + 0.5];

% compressing the criteria
unattCrit = -1:0.45:2;
unattCrit(numel(attCrit)+1:end) = []; % maintain number of criteria

attConf = zeros(nAtt,1);
unattConf = zeros(nUnatt,1);

%% sample for the case where ratings are just high/low with one criterion
% attConf(signal>attCrit) = 1;
% attConf(signal<attCrit) = 0;
% 
% unattConf(signal>unattCrit) = 1;
% unattConf(signal<unattCrit) = 0;

%% calculate confidence ratings
for i = length(attCrit):-1:1
    attConf(attSignal<attCrit(i)) = i-1; % 0 for the first bin, etc
end
attConf(attSignal>attCrit(end)) = length(attCrit);

for i = length(unattCrit):-1:1
    unattConf(unattSignal<unattCrit(i)) = i-1; % 0 for the first bin, etc
end
unattConf(unattSignal>unattCrit(end)) = length(unattCrit);

%% means and stds of the confidence distributions
confMeans = [mean(attConf) mean(unattConf)];
confStds = [std(attConf) std(unattConf)];

%% plot figures
figure
subplot(2,2,1)
hold on
hist(unattSignal)
set(get(gca,'child'),'FaceColor','g','EdgeColor','k');
hist(attSignal)
ylims = get(gca,'YLim');
plot([attCrit; attCrit], ylims, 'b')
plot([unattCrit; unattCrit], ylims, 'g')
title('internal signal with criteria')

subplot(2,2,2)
hist(attConf)
title('attended confidence')

subplot(2,2,3)
hist(unattConf)
title('unattended confidence')

subplot(2,2,4)
hold on
bar([confMeans; confStds])
set(gca, 'XTick', [1 2])
set(gca, 'XTickLabel', {'conf mean','conf std'})
legend('attended','unattended')



