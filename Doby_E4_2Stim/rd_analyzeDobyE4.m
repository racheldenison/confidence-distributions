% rd_analyzeDobyE4.m

% load in 'data'

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
figure
plot(repmat(contrasts',1,2), accMean)
ylim([.5 1])
legend(num2str(attConds'))
xlabel('contrast')
ylabel('proportion correct')

figure
plot(repmat(contrasts',1,2), confMean)
ylim([1 4])
legend(num2str(attConds'))
xlabel('contrast')
ylabel('mean confidence rating')

figure
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
            ylabel(sprintf('%d%%', 100*contrasts(iContrast)))
            ylim([0 200*(3/7)])
        else
            ylim([0 200])
        end
    end
end
        
        