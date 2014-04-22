% rd_simQamar2.m

% Simulate narrow and wide distributions (cat 1 and 2) convolved with
% narrow and wide distributions (low internal noise nad high internal
% noise) to see if the criterion is always where the distributions
% intersect

%% setup
mu = 0;
sigma1 = 3;
sigma2 = 12;
xsigma1 = 0;
xsigma2 = 8;
n = 1000;

%% get the stimulus distribution
% s is the stimulus presented on each trial
s1 = normrnd(mu, sigma1, n, 1);
s2 = normrnd(mu, sigma2, n, 1);

%% simulate x
% x is the sensory measurement (internal signal) on each trial
% for iTrial = 1:numel(s1)
%     x1(iTrial) = normrnd(s1(iTrial), xsigma1);
%     x2(iTrial) = normrnd(s2(iTrial), xsigma2);
% end
x1s1 = normrnd(s1, xsigma1);
x1s2 = normrnd(s2, xsigma1);
x2s1 = normrnd(s1, xsigma2);
x2s2 = normrnd(s2, xsigma2);

%% find means and stds of resulting x distributions
[muhat(1,1) sighat(1,1)] = normfit(x1s1);
[muhat(2,1) sighat(2,1)] = normfit(x2s1);
[muhat(1,2) sighat(1,2)] = normfit(x1s2);
[muhat(2,2) sighat(2,2)] = normfit(x2s2);

%% plots
histCenters = -60:60;
% stimulus distributions
figure
hold on
hist(s1, histCenters)
hist(s2, histCenters)
hh = get(gca,'child');
set(hh(1),'FaceColor','none','EdgeColor','r');
set(hh(2),'FaceColor','b','EdgeColor','k');
xlabel('s')
ylabel('number of trials')
title(sprintf('stim distro: sigma1 = %1.1f, sigma2 = %1.1f', sigma1, sigma2))

% x1 distributions
figure
hold on
hist(x1s1, histCenters)
hist(x1s2, histCenters)
hh = get(gca,'child');
set(hh(1),'FaceColor','none','EdgeColor','r');
set(hh(2),'FaceColor','b','EdgeColor','k');
xlabel('x')
ylabel('number of trials')
title(sprintf('x distro: sigma1 = %1.1f, sigma2 = %1.1f, xsigma = %1.1f', ...
    sigma1, sigma2, xsigma1))

% x2 distributions
figure
hold on
hist(x2s1, histCenters)
hist(x2s2, histCenters)
hh = get(gca,'child');
set(hh(1),'FaceColor','none','EdgeColor','r');
set(hh(2),'FaceColor','b','EdgeColor','k');
xlabel('x')
ylabel('number of trials')
title(sprintf('x distro: sigma1 = %1.1f, sigma2 = %1.1f, xsigma = %1.1f', ...
    sigma1, sigma2, xsigma2))

% stds of x distributions
figure
bar(sighat')
xlabel('stimulus')
ylabel('standard deviation of x')
legend('x1','x2','Location','best')

% fit pdfs
ylims = [0 .15];
figure
% x1
subplot(1,2,1)
hold on
plot(histCenters, normpdf(histCenters, muhat(1,1), sighat(1,1)))
plot(histCenters, normpdf(histCenters, muhat(1,2), sighat(1,2)),'r')
ylim(ylims)
xlabel('x1')
% x2
subplot(1,2,2)
hold on
plot(histCenters, normpdf(histCenters, muhat(2,1), sighat(2,1)))
plot(histCenters, normpdf(histCenters, muhat(2,2), sighat(2,2)),'r')
ylim(ylims)
xlabel('x2')
legend('s1','s2')
rd_supertitle(sprintf('sigma1 = %1.1f, sigma2 = %1.1f, xsigma1 = %1.1f, xsigma2 = %1.1f', ... sigma1, sigma2, xsigma2))
    sigma1, sigma2, xsigma1, xsigma2))
