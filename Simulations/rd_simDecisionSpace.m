% rd_simDecisionSpace.m

%% build templates
orientationDifference = 90; % 90 (coarse), 2 (fine)

% make grating templates
tv = rd_makeStimulus(100,0); % contrast=100 is a hack to get a noise-free grating
th = rd_makeStimulus(100,orientationDifference);

deltaT = tv-th;
tbar = (tv+th)/2;

% an example evidence calculation
gv20 = rd_makeStimulus(.2);
evv20 = deltaT(:)'*(gv20(:)-tbar(:))

% similarity to v minus similarity to h
tv(:)'*gv20(:) - th(:)'*gv20(:) % this is exactly equal to evv20

%% contrast refers to the level of noise
% for many trials (many images)
nTrials = 1000;
contrasts = [.1 .2 .3 .4 .5];
for iContrast = 1:numel(contrasts)
    contrast = contrasts(iContrast);
    for iTrial = 1:nTrials
        gv = rd_makeStimulus(contrast);
        evv(iTrial,iContrast) = deltaT(:)'*(gv(:)-tbar(:));
    end
end

mean(evv)
std(evv)

figure
hold on
for iContrast = 1:numel(contrasts)
    hist(evv(:,iContrast))
end
xlabel('evidence')
ylabel('trial count')

figure
hold all
plot(contrasts, mean(evv)-mean(mean(evv)))
plot(contrasts, std(evv)-mean(std(evv)))
legend('mean','std')
xlabel('contrast')
ylabel('evidence')

%% contrast refers to the image intensity
% for many trials (many images)
nTrials = 1000;
contrasts = [.1 .2 .3 .4 .5];
for iContrast = 1:numel(contrasts)
    contrast = contrasts(iContrast);
    for iTrial = 1:nTrials
        gv = rd_makeStimulus(1);
        gv = ((gv/255-.5)*contrast + .5)*255;
        evv(iTrial,iContrast) = deltaT(:)'*(gv(:)-tbar(:));
    end
end

mean(evv)
std(evv)

figure
hold on
for iContrast = 1:numel(contrasts)
    hist(evv(:,iContrast))
end
xlabel('evidence')
ylabel('trial count')

figure
hold all
plot(contrasts, mean(evv)-mean(mean(evv)))
plot(contrasts, std(evv)-mean(std(evv)))
legend('mean','std')
xlabel('contrast')
ylabel('evidence')


