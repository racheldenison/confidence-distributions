% rd_analyzeAttentionConfidence.m

load([pathToExpt('data') '/rd_p1_run02_notrain_20150226_172125.mat'])

%% setup
nBlocks = Test.n.blocks;
nSectionsPerBlock = Test.n.sections;
nTrialsPerSection = Test.n.trials;

%% read out data into trial matrix
trialIdx = 1;
for iBlock = 1:nBlocks
    for iSec = 1:nSectionsPerBlock
        for iTrial = 1:nTrialsPerSection
            % left stim (R)
            trialOrder = Test.R.trial_order{iBlock}(iSec,iTrial);
            sigma = Test.R.sigma{iBlock}(iSec,iTrial);
            phase = Test.R.phase{iBlock}(iSec,iTrial);
            draws = Test.R.draws{iBlock}(iSec,iTrial);
            
            % right stim (R2)
            trialOrder2 = Test.R2.trial_order{iBlock}(iSec,iTrial);
            sigma2 = Test.R2.sigma{iBlock}(iSec,iTrial);
            phase2 = Test.R2.phase{iBlock}(iSec,iTrial);
            draws2 = Test.R2.draws{iBlock}(iSec,iTrial);
            
            % attention (R2)
            probe = Test.R2.probe{iBlock}(iSec,iTrial);
            cue = Test.R2.cue{iBlock}(iSec,iTrial);
            validity = probe==cue; % 1=valid, 0=invalid
            
            if probe==1
            	targetClass = trialOrder;
                targetSigma = sigma;
                targetPhase = phase;
                targetOrient = draws;
                targetSide = 1;
            else
                targetClass = trialOrder2;
                targetSigma = sigma2;
                targetPhase = phase2;
                targetOrient = draws2;
                targetSide = 2;
            end
            
            % responses
            tf = Test.responses{iBlock}.tf(iSec,iTrial);
            c = Test.responses{iBlock}.c(iSec,iTrial);
            conf = Test.responses{iBlock}.conf(iSec,iTrial);
            rt = Test.responses{iBlock}.rt(iSec,iTrial);
            class1 = c==1;
            
            trials_headers = {'classL','sigmaL','phaseL','orientL', ...
                'classR','sigmaR','phaseR','orientR','cue','respCue','validity',...
                'targetClass','targetSigma','targetPhase','targetOrient','targetSide',...
                'respClass','respConf','acc','RT','respClass1'};
            
            trials(trialIdx,:) = [trialOrder sigma phase draws ...
                trialOrder2 sigma2 phase2 draws2 cue probe validity ...
                targetClass targetSigma targetPhase targetOrient targetSide ...
                c conf tf rt class1];
            
            trialIdx = trialIdx + 1;
        end
    end
end

%% analyze data
% by orientation, for valid/invalid
validities = unique(trials(:,strcmp(trials_headers,'validity')));
dOr = 5;
orientBinEdges = -45:dOr:45;
nOrients = numel(orientBinEdges)-1;

for iV = 1:numel(validities)
    wV = trials(:,strcmp(trials_headers,'validity')) == validities(iV);
    for iOrient = 1:nOrients
        orientBin = orientBinEdges(iOrient:iOrient+1);
        wL = trials(:,strcmp(trials_headers,'targetOrient')) > orientBin(1);
        wH = trials(:,strcmp(trials_headers,'targetOrient')) <= orientBin(2);
        
        w = wV & wL & wH;
        totals.all{iV,iOrient} = trials(w,:);
        totals.means(iOrient,:,iV) = mean(trials(w,:),1);
        totals.std(iOrient,:,iV) = std(trials(w,:),0,1);
        totals.ste(iOrient,:,iV) = std(trials(w,:),0,1)./sqrt(nnz(w));
    end
end

%% plot 
for iV = 1:numel(validities)
    class1Prop(:,iV) = totals.means(:,strcmp(trials_headers,'respClass1'),iV);
    class1PropSte(:,iV) = totals.ste(:,strcmp(trials_headers,'respClass1'),iV);
    
    acc(:,iV) = totals.means(:,strcmp(trials_headers,'acc'),iV);
    accSte(:,iV) = totals.ste(:,strcmp(trials_headers,'acc'),iV);
end

orientBinCenters = orientBinEdges(1:end-1) + dOr/2;

figure
errorbar(repmat(orientBinCenters',1,2), class1Prop, class1PropSte)
xlabel('orientation')
ylabel('p(class1)')
legend('invalid','valid')

figure
errorbar(repmat(orientBinCenters',1,2), acc, accSte)
xlabel('orientation')
ylabel('accuracy')
legend('invalid','valid')
            