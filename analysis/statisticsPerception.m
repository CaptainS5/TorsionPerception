% all statistic analysis and results for perception Exp2
% 07/12/2018 Xiuyun Wu
clear all; close all; clc
% might be useful as a reference...
% % one-way repeated measure anova...
%     % sf
%     tempT1 = table(cAICc(:, 1), cAICc(:, 2), cAICc(:, 3), cAICc(:, 4),...
%         'VariableNames', {'m1' 'm2' 'm3' 'm4'});
%     Meas = table([1 2 3 4]','VariableNames',{'Measurements'});
%     rm{1} = fitrm(tempT1, 'm1-m4~1', 'WithinDesign', Meas);
%     ranovatbl{1} = ranova(rm{1});
%     stats{1}.gnames = {'StandardMixture'; 'WithBiasMixture'; 'Swap'; 'WithBiasSwap'};
%     stats{1}.n = (length(name)-2)*ones(1, 4);
%     stats{1}.source = 'anova1';
%     stats{1}.means = mean(cAICc);
%     stats{1}.df = ranovatbl{1}{2, 2};
%     stats{1}.s = sqrt(ranovatbl{1}{2, 3});
%     [c{1} m{1} h{1} nms{1}] = multcompare(stats{1});
%     saveas(h{1}, ['sf_', fCons{j}, colN, '_', csf, '.pdf'])

names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol'};
conditions = [25 50 100 200];
trialBaseAll = 60;
trialExpAll = 288;

% load data
load(['dataBase_all', num2str(size(names, 2))]);
load(['dataPercept_all', num2str(size(names, 2))]);

%% valid trial numbers
for t = 1:size(names, 2)
    idxBase = find(strcmp(dataBaseTrial.sub, names{t}));
    validBase(t, 1) = length(idxBase);
    idxExp = find(strcmp(dataPercept.sub, names{t}));
    validExp(t, 1) = length(idxExp);
end

disp(['baseline excluded trial number: ', num2str(mean(1-validBase/trialBaseAll)), ' +- ', num2str(std(1-validBase/trialBaseAll))])
disp(['exp excluded trial number: ', num2str(mean(1-validExp/trialExpAll)), ' +- ', num2str(std(1-validExp/trialExpAll))])

% %% repeated measures ANOVA with speed and direction
% data = dataPercept;
% for t = 1:size(names, 2)
%     tempI = find(strcmp(data.sub, names{t}));
%     data.subN(tempI, 1) = t;
% end
% stats = rm_anova2(data.angleError, data.subN, data.rotationSpeed, -data.initialDirection, {'rotationSpeed', 'afterDirection'})