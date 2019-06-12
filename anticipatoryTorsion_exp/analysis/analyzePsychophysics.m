% Analysis of Psychophysics in TorsionAnticipation experiment
% created by Austin Rothwell - Feb 2 2017

subjectlist = { '04' '05' '06' '07' '08' '09' '11' '12' '13' '15' '16' '17'};
natfirst = [0 0 1 1 1 0 0 0 1 1 1 1];
totalCorrect = [];
totalNumCorrect = [];
totalNumFaster = [];
totalNatFaster = [];
totalUnnatFaster = [];
totalNatCorrect = [];
totalUnnatCorrect = [];
for subj = 1:length(subjectlist)
    numCorrect = [0 0 0 0 0];
    numFaster = [0 0 0 0 0];
    natFaster = [0 0 0 0 0];
    unnatFaster = [0 0 0 0 0];
    correctTrials = [];
    natCorrect = [0 0 0 0 0];
    unnatCorrect = [0 0 0 0 0];
    
    for block = 1:4
        
        % read in log file
        selectedLogFile = ['\subject' subjectlist{subj} 'log.txt'];
        folder = ['D:\admin-austin\TorsionAnticipation\TorsionAnticipation\exp14\subj' subjectlist{subj}];
        [header, logData] = readLogFile(block*2, selectedLogFile, folder);

        % find correct responses
        for trial = 1:length(logData.trial)
            if logData.randomSpeed(trial) > 0 && logData.decision(trial) > 0 
                correctTrials = [correctTrials logData.trial(trial)];
                if logData.randomSpeed(trial) == -8
                    numCorrect(1) = numCorrect(1)+1;
                elseif logData.randomSpeed(trial) == -4
                   numCorrect(2)=numCorrect(2)+1;
                elseif logData.randomSpeed(trial) == 0
                   numCorrect(3)=numCorrect(3)+1;
                elseif logData.randomSpeed(trial) == 4
                   numCorrect(4)=numCorrect(4)+1;
                elseif logData.randomSpeed(trial) == 8
                   numCorrect(5)=numCorrect(5)+1;
                end
            end
            if logData.randomSpeed(trial) < 0 && logData.decision(trial) == 0 
                correctTrials = [correctTrials logData.trial(trial)];
                if logData.randomSpeed(trial) == -8
                    numCorrect(1) = numCorrect(1)+1;
                elseif logData.randomSpeed(trial) == -4
                   numCorrect(2)=numCorrect(2)+1;
                elseif logData.randomSpeed(trial) == 0
                   numCorrect(3)=numCorrect(3)+1;
                elseif logData.randomSpeed(trial) == 4
                   numCorrect(4)=numCorrect(4)+1;
                elseif logData.randomSpeed(trial) == 8
                   numCorrect(5)=numCorrect(5)+1;
                end
            end
            if logData.randomSpeed(trial) == 0 
                correctTrials = [correctTrials logData.trial(trial)];
                if logData.randomSpeed(trial) == -8
                    numCorrect(1) = numCorrect(1)+1;
                elseif logData.randomSpeed(trial) == -4
                   numCorrect(2)=numCorrect(2)+1;
                elseif logData.randomSpeed(trial) == 0
                   numCorrect(3)=numCorrect(3)+1;
                elseif logData.randomSpeed(trial) == 4
                   numCorrect(4)=numCorrect(4)+1;
                elseif logData.randomSpeed(trial) == 8
                   numCorrect(5)=numCorrect(5)+1;
                end
            end
            
            
            
            if logData.decision(trial) > 0 
                if logData.randomSpeed(trial) == -8
                    numFaster(1) = numFaster(1)+1;
                elseif logData.randomSpeed(trial) == -4
                   numFaster(2)=numFaster(2)+1;
                elseif logData.randomSpeed(trial) == 0
                   numFaster(3)=numFaster(3)+1;
                elseif logData.randomSpeed(trial) == 4
                   numFaster(4)=numFaster(4)+1;
                elseif logData.randomSpeed(trial) == 8
                   numFaster(5)=numFaster(5)+1;
                end
            end
            
            if natfirst(subj)
                if block <3 
                if logData.decision(trial) > 0
                    if logData.randomSpeed(trial) == -8
                        natFaster(1) = natFaster(1)+1;
                    elseif logData.randomSpeed(trial) == -4
                       natFaster(2)=natFaster(2)+1;
                    elseif logData.randomSpeed(trial) == 0
                       natFaster(3)=natFaster(3)+1;
                    elseif logData.randomSpeed(trial) == 4
                       natFaster(4)=natFaster(4)+1;
                    elseif logData.randomSpeed(trial) == 8
                       natFaster(5)=natFaster(5)+1;
                    end
                end
            else
                if logData.decision(trial) > 0 
                    if logData.randomSpeed(trial) == -8
                        unnatFaster(1) = unnatFaster(1)+1;
                    elseif logData.randomSpeed(trial) == -4
                       unnatFaster(2)=unnatFaster(2)+1;
                    elseif logData.randomSpeed(trial) == 0
                       unnatFaster(3)=unnatFaster(3)+1;
                    elseif logData.randomSpeed(trial) == 4
                       unnatFaster(4)=unnatFaster(4)+1;
                    elseif logData.randomSpeed(trial) == 8
                       unnatFaster(5)=unnatFaster(5)+1;
                    end
                end
                end
            else
                if block > 2 
                if logData.decision(trial) > 0
                    if logData.randomSpeed(trial) == -8
                        natFaster(1) = natFaster(1)+1;
                    elseif logData.randomSpeed(trial) == -4
                       natFaster(2)=natFaster(2)+1;
                    elseif logData.randomSpeed(trial) == 0
                       natFaster(3)=natFaster(3)+1;
                    elseif logData.randomSpeed(trial) == 4
                       natFaster(4)=natFaster(4)+1;
                    elseif logData.randomSpeed(trial) == 8
                       natFaster(5)=natFaster(5)+1;
                    end
                end
            else
                if logData.decision(trial) > 0 
                    if logData.randomSpeed(trial) == -8
                        unnatFaster(1) = unnatFaster(1)+1;
                    elseif logData.randomSpeed(trial) == -4
                       unnatFaster(2)=unnatFaster(2)+1;
                    elseif logData.randomSpeed(trial) == 0
                       unnatFaster(3)=unnatFaster(3)+1;
                    elseif logData.randomSpeed(trial) == 4
                       unnatFaster(4)=unnatFaster(4)+1;
                    elseif logData.randomSpeed(trial) == 8
                       unnatFaster(5)=unnatFaster(5)+1;
                    end
                end
                end
            end
          
            
            
         end
%         if natfirst(subj)
%             if block <= 2
%                 natCorrect = natCorrect + (numCorrect - natCorrect);
%             else
%                 unnatCorrect = unnatCorrect + (numCorrect - (unnatCorrect);
%             end
%         else
%             if block > 2
%                 natCorrect = natCorrect + (numCorrect - natCorrect);
%             else
%                 unnatCorrect = unnatCorrect + (numCorrect - unnatCorrect);
%             end
%         end
    end
%     totalNatCorrect = [totalNatCorrect; natCorrect]
%     totalUnnatCorrect = [totalUnnatCorrect; unnatCorrect]
    totalNumCorrect = [totalNumCorrect; numCorrect];
    totalCorrect = [totalCorrect length(correctTrials)];
    totalNumFaster = [totalNumFaster; numFaster];
    totalNatFaster = [totalNatFaster; natFaster];
    totalUnnatFaster = [totalUnnatFaster; unnatFaster];
end

scores = [[4 5 6 7 8 9 11 12 13 15 16 17]' totalCorrect'];

totalNumCorrect(:,1:2) = 80 - totalNumCorrect(:,1:2);
totalNumCorrect(:,3) =  totalNumCorrect(:,3) - 40;

means = totalNumCorrect/80;

totalPropFaster = totalNumFaster ./ 80

totalPropNatFaster = totalNatFaster ./ 40;
totalPropUnnatFaster = totalUnnatFaster ./ 40;


natural_faster_exp14 = totalPropNatFaster([1 5 6 8 9 10],:);
natural_faster_exp14 = [natural_faster_exp14; mean(totalPropNatFaster([2 12],:)); mean(totalPropNatFaster([4 11],:)); mean(totalPropNatFaster([3 7],:))]

unnatural_faster_exp14 = totalPropUnnatFaster([1 5 6 8 9 10],:);
unnatural_faster_exp14 = [unnatural_faster_exp14; mean(totalPropUnnatFaster([2 12],:)); mean(totalPropUnnatFaster([4 11],:)); mean(totalPropUnnatFaster([3 7],:))]


%%

% figure
% errorbar(mean(totalNumFaster(1:6,:)), std(totalNumFaster(1:6,:)),'linewidth', 1, 'color', 'k')
% hold on;
% errorbar(mean(totalNumFaster(7:12,:)), std(totalNumFaster(7:12,:)),'linewidth', 1, 'color', 'k')
% 
% hold on;
% plot(mean(totalNumFaster(1:6,:)),'linewidth', 3, 'color', 'b')
% plot(mean(totalNumFaster(7:12,:)),'linewidth', 3, 'color', 'r')


figure

shift = rand(12*5,1)*0.3-.10;

scatter([zeros(12,1)+1; zeros(12,1)+2; zeros(12,1)+3; zeros(12,1)+4; zeros(12,1)+5]+shift, totalPropNatFaster(:),  'b')
hold on;
scatter([zeros(12,1)+1; zeros(12,1)+2; zeros(12,1)+3; zeros(12,1)+4; zeros(12,1)+5]+shift, totalPropUnnatFaster(:), 'r')
% plot(totalNatFaster', 'color', 'b');
% hold on;
% plot(totalUnnatFaster', 'color', 'r');
hold on;
e1 = errorbar(mean(totalPropNatFaster), std(totalPropNatFaster)/3, 'o', 'color', 'k', 'linewidth', 1.3);
e2 = errorbar(mean(totalPropUnnatFaster), std(totalPropUnnatFaster)/3, 'o', 'color', 'k', 'linewidth', 1.3);
hold on;




% Palamedes settings
    StimLevels = [1 2 3 4 5];
    NumPos = mean(totalNatFaster);
    OutOfNum = [40 40 40 40 40];
    PF = @PAL_Logistic; 

    % PF options:
    %     @PAL_Logistic
    %     @PAL_Weibull
    %     @PAL_Gumbel (i.e., log-Weibull)
    %     @PAL_Quick
    %     @PAL_logQuick
    %     @PAL_CumulativeNormal
    %     @PAL_Gumbel
    %     @PAL_HyperbolicSecant

    % ParamsValues:
    % paramsValues(1) - alpha (threshold at 50%)
    % paramsValues(2) - beta (slope)
    % paramsValues(3) - gamma (guess rate)
    % paramsValues(4) - lambda (lapse rate)
    paramsValues = [0.5 1 0 0];
    paramsFree = [1 1 0 0]; %which of the four parameters are free parameters

    % create psychometric function
    [paramsValues LL exitFlag] = PAL_PFML_Fit(StimLevels, NumPos, OutOfNum, paramsValues, paramsFree, PF);
    PropCorrectData = mean(totalPropNatFaster);
    StimLevelsFine = [min(StimLevels):(max(StimLevels) - min(StimLevels))./1000:max(StimLevels)];
    Fit = PF(paramsValues, StimLevelsFine);
    plot(StimLevels, PropCorrectData, 'b.', 'markersize', 20);
    nat = plot(StimLevelsFine, Fit, 'b-', 'linewidth', 2);
    hold on;
    NumPos = mean(totalUnnatFaster);
    [paramsValues LL exitFlag] = PAL_PFML_Fit(StimLevels, NumPos, OutOfNum, paramsValues, paramsFree, PF);
    PropCorrectData = mean(totalPropUnnatFaster);
    StimLevelsFine = [min(StimLevels):(max(StimLevels) - min(StimLevels))./1000:max(StimLevels)];
    Fit = PF(paramsValues, StimLevelsFine);
    plot(StimLevels, PropCorrectData, 'r.', 'markersize', 20);
    unnat = plot(StimLevelsFine, Fit, 'r-', 'linewidth', 2);

hold on;
% nat = plot(mean(totalNatFaster),'linewidth', 3, 'color', 'b');
% unnat = plot(mean(totalUnnatFaster),'linewidth', 3, 'color', 'r');
% n = fit([1 2 3 4 5]',mean(totalNatFaster)', ft);
% nat = plot(n,[1 2 3 4 5]',mean(totalNatFaster)');
% hold on;
% u = fit([1 2 3 4 5]',mean(totalUnnatFaster)', 'poly2');
% unnat = plot(u, [1 2 3 4 5]', mean(totalUnnatFaster)');
% hold on;
% set(nat, 'color', 'b', 'linewidth', 3);
% set(unnat, 'color', 'r', 'linewidth', 3);
ylim([0, 1])
xlim([0.75, 5.25])
set(gca, 'Ytick', [0:0.5:1]) 
set(gca, 'fontsize', 20);
set(gca, 'fontweight', 'bold')
set(gcf, 'color', 'w');
set(gca, 'linewidth', 1.3);
labels = [166 173 180 187 194];
tickStep = (1000/5)/(length(labels)-1);
set(gca, 'XTick', 1:5, 'XTickLabel', labels);
box off;
xlabel('Rotation Speed (deg/s)', 'fontsize', 25);
ylabel('Proportion Faster', 'fontsize', 25);
legend([nat unnat], {'Natural', 'Unnatural'}, 'Location','southeast')




%%
% PALAMEDES
for i = 1:length(subjectlist)
    
    % Palamedes settings
    StimLevels = [0.92 0.94 1 1.04 1.08];
    NumPos = totalNumCorrect(i,:);
    OutOfNum = [80 80 80 80 80];
    PF = @PAL_Logistic; 

    % PF options:
    %     @PAL_Logistic
    %     @PAL_Weibull
    %     @PAL_Gumbel (i.e., log-Weibull)
    %     @PAL_Quick
    %     @PAL_logQuick
    %     @PAL_CumulativeNormal
    %     @PAL_Gumbel
    %     @PAL_HyperbolicSecant

    % ParamsValues:
    % paramsValues(1) - alpha (threshold at 50%)
    % paramsValues(2) - beta (slope)
    % paramsValues(3) - gamma (guess rate)
    % paramsValues(4) - lambda (lapse rate)
    paramsValues = [1 50 0 0];
    paramsFree = [1 1 0 0]; %which of the four parameters are free parameters

    % create psychometric function
    [paramsValues LL exitFlag] = PAL_PFML_Fit(StimLevels, NumPos, OutOfNum, paramsValues, paramsFree, PF);
    PropCorrectData = NumPos./OutOfNum;
    StimLevelsFine = [min(StimLevels):(max(StimLevels) - min(StimLevels))./1000:max(StimLevels)];
    Fit = PF(paramsValues, StimLevelsFine);
    plot(StimLevels, PropCorrectData, 'k.', 'markersize', 40);
    title('Psychometric functions!');
    xlabel('Rotation speed');
    ylabel('Proportion of FASTER responses');
    set(gca, 'fontsize', 12);
    axis([.9 1.1 0 1]);
    hold on;
    plot(StimLevelsFine, Fit, 'g-', 'linewidth', 2);
    % bootstrap SD and goodness of fit
    B = 50;
    %[SD paramsSim LLSim converged] = PAL_PFML_BootstrapNonParametric(StimLevels, NumPos, OutOfNum, paramsValues, paramsFree, B, PF);
    [SD paramsSim LLSim converged] = PAL_PFML_BootstrapParametric(StimLevels, OutOfNum, paramsValues, paramsFree, B, PF);

    [Dev pDev DevSim converged] = PAL_PFML_GoodnessOfFit(StimLevels,NumPos, OutOfNum, paramsValues, paramsFree, B, PF);
    hold on;
end
    


