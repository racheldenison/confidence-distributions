% rd_simQamar.m
%
% The idea is to convolve narrow and wide orientation distribution pdfs
% with narrow and wide gaussians (simulating increased neural variability)
% to see if the resulting distributions lead to the same criterion choices
% as Qamar et al get with their generative model.

%% draw from unit Gaussian
n = 1000;
rSD = .5;
z = randn(n,1)*rSD; 

%% compute pdf and gaussian filters
b = max(z);
x = -b*1.25:0.01:b*1.25;
zp = normpdf(x,0,rSD);
f1 = normpdf(x,0,rSD/10);
f2 = normpdf(x,0,rSD*2);

%% do it with fspecial
% zps = fspecial('gaussian',[n 1], rSD);
% f1s = fspecial('gaussian',[n 1], rSD/10);
% f2s = fspecial('gaussian',[n 1], rSD/5);

%% convolve pdf with filters
zpf1 = conv(zp, f1, 'same');
zpf2 = conv(zp, f2, 'same');

%% renormalize to have max 1
zpn = zp/max(zp);
zpf1n = zpf1/max(zpf1);
zpf2n = zpf2/max(zpf2);

%% plot pdf and filters
figure
hold on
plot(x,zp)
plot(x,f1,'g')
plot(x,f2,'r')

%% plot pdf and convolved pdfs
figure
hold on
plot(x,zp)
plot(x,zpf1,'g')
plot(x,zpf2,'r')

%% plot normalized pdf
figure
hold on
plot(x,zpn)
plot(x,zpf1n,'g')
plot(x,zpf2n,'r')
