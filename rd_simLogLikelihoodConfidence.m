% rd_simLogLikelihoodConfidence.m

%% setup
mu = 5;
sigma = 1;
n = 1000;

s1 = mu/2;
s2 = -mu/2;

%% simulate x
% x (the sensory measurement) is a normal random variable with mean s1 or
% s2 (=+/-mu/2) and standard deviation sigma
% x|s1
x1 = normrnd(s1, sigma, n, 1);
x2 = normrnd(s2, sigma, n, 1);

x = [x1; x2];

%% calculate d
d1 = (x1*mu)/sigma^2;
d2 = (x2*mu)/sigma^2;

d = (x*mu)/sigma^2;

%% calculate confidence
conf1 = 1./(1+exp(-abs(d1)));
conf2 = 1./(1+exp(-abs(d2)));

conf = 1./(1+exp(-abs(d)));

%% d criteria
c = 0.5;
d1c = prctile(d1,c*100);
d2c = prctile(d2,c*100);

%% plots
% figure
% hist(d, 20)
% xlabel('d')
% ylabel('number of trials')
% title(sprintf('mu = %d, sigma = %1.1f', mu, sigma))

figure
hold on
hist(d1, 20)
hist(d2, 20)
hh = get(gca,'child');
set(hh(1),'FaceColor','none','EdgeColor','r');
set(hh(2),'FaceColor','b','EdgeColor','k');
ph = plot_vertical_line([d1c 0 d2c],[.5 .5 .5]);
set(ph,'LineWidth',2)
xlabel('d')
ylabel('number of trials')
title(sprintf('mu = %d, sigma = %1.1f', mu, sigma))

% figure
% hist(conf)
% xlabel('confidence')
% ylabel('number of trials')

figure
hold on
hist(conf1, 20)
hist(-conf2, 20)
hh = get(gca,'child');
set(hh(1),'FaceColor','none','EdgeColor','r');
set(hh(2),'FaceColor','b','EdgeColor','k');
% ph = plot_vertical_line([d1c 0 d2c],[.5 .5 .5]);
set(ph,'LineWidth',2)
xlabel('confidence')
ylabel('number of trials')
title(sprintf('mu = %d, sigma = %1.1f', mu, sigma))

% another way to do hist colors
% [nb1,xb1] = hist(d1, 20);
% bh1 = bar(xb1,nb1);
% [nb2,xb2] = hist(d2, 20);
% bh2 = bar(xb2,nb2);
% set(bh2,'facecolor',[0 1 0]);
