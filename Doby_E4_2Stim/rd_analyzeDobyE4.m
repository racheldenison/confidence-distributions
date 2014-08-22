% rd_analyzeDobyE4.m

%% setup
subjectID = 'waPilot_20140819';

dataDir = 'data';
figDir = 'figures';

saveFigs = 1;

%% load data
data = rd_loadData(dataDir, subjectID);
data = data.data;

%% initialize variables
contrast = [];
attended = [];
answer = [];
answer2 = [];
rt = [];
correct = [];

%% read out data
for iBlock = 1:numel(data)
    contrast = [contrast data{iBlock}.contrast_shown];
    attended = [attended data{iBlock}.question_about_attended];
    answer = [answer data{iBlock}.answer];
    answer2 = [answer2 5-data{iBlock}.answer2];
    rt = [rt data{iBlock}.rt];
    correct = [correct 1-data{iBlock}.made_mistake];
end

trials = [contrast' attended' answer' answer2' rt' correct'];

%% summary analysis
contrasts = unique(contrast);
attConds = unique(attended);
for iContrast = 1:numel(contrasts)
    wContrast = contrast==contrasts(iContrast);
    for iAtt = 1:numel(attConds)
        wAtt = attended==attConds(iAtt);
        
        w = wContrast & wAtt;
        totals.all{iContrast,iAtt} = trials(w,:);
        
        totals.means(iContrast,:,iAtt) = mean(trials(w,:));
        totals.stds(iContrast,:,iAtt) = std(trials(w,:));
    end
end

accMean = squeeze(totals.means(:,6,:));
confMean = squeeze(totals.means(:,4,:));

%% plot figures
f(1) = figure;
plot(repmat(contrasts',1,2), accMean)
ylim([.5 1])
legend(num2str(attConds'),'Location','best')
xlabel('contrast')
ylabel('proportion correct')
title(subjectID)

f(2) = figure;
plot(repmat(contrasts',1,2), confMean)
ylim([1 4])
legend(num2str(attConds'),'Location','best')
xlabel('contrast')
ylabel('mean confidence rating')
title(subjectID)

f(3) = figure;
nC = numel(contrasts);
nA = numel(attConds);
for iContrast = 1:nC
    for iAtt = 1:nA
        subplot(nC,nA,(iContrast-1)*nA+iAtt)
        hist(totals.all{iContrast,iAtt}(:,4))
        xlim([0 4])
        if iContrast==1
            title(sprintf('attended = %d', attConds(iAtt)))
        end
        if iAtt==1
            if round(100*contrasts(iContrast))~=100*contrasts(iContrast)
                ylabel(sprintf('%1.1f%%', 100*contrasts(iContrast)))
            else
                ylabel(sprintf('%d%%', 100*contrasts(iContrast)))
            end
            ylim([0 200*(3/7)])
        else
            ylim([0 200])
        end
    end
end
rd_supertitle(subjectID)

%% save figures
if saveFigs
    figNames = {'acc','conf','confdist'};
    rd_saveAllFigs(f, figNames, [subjectID '_DobyE42Stim'], figDir);
end
        
        