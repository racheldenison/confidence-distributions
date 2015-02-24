% rd_simVariability.m

x = -10:10;
mu = 0;
sigma = 3;

y = normpdf(x, mu, sigma);

est = x*y';

nTrials = 100;

for i = 1:nTrials
    noise = rand(size(x));
    
    estNoise(i) = (x.*noise)*y';
end

