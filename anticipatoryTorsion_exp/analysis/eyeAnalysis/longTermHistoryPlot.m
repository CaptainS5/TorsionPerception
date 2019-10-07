% Load Experiment 16 raw data
T_exp16 = load('exp16_raw_torsion_velocity_updated.mat');

T_exp16 = T_exp16.raw_data_T;

 

% Load Experiment 14 raw data

T_exp14 = load('raw_torsion_velocity_exp14.mat');

T_exp14 = T_exp14.raw_data_T;

T_exp14(:,:,:,7:end) = T_exp14(:,:,:,7:end)*-1;

 

T_exp14(:,:,:,2) = nanmean(cat(4,T_exp14(:,:,:,2),T_exp14(:,:,:,12)),4);

T_exp14(:,:,:,4) = nanmean(cat(4,T_exp14(:,:,:,4),T_exp14(:,:,:,11)),4);

T_exp14(:,:,:,3) = nanmean(cat(4,T_exp14(:,:,:,3),T_exp14(:,:,:,7)),4);

 

T_exp14= T_exp14(:,:,:,[1 2 3 4 5 6 8 9 10]);

 

% anticipatory section only

torsion_natural = T_exp14(:,91:110,1,:);

torsion_unnatural = T_exp14(:,91:110,2,:);

torsion_no = T_exp14(:,91:110,3,:);

 

torsion_natural_trial_average = nanmean(nanmean(torsion_natural,2),4);

torsion_unnatural_trial_average = nanmean(nanmean(torsion_unnatural,2),4);

torsion_no_trial_average = nanmean(nanmean(torsion_no,2),4);
 

torsion_natural_cummean = cumsum(torsion_natural_trial_average)./((1:length(torsion_natural_trial_average))');

torsion_unnatural_cummean = cumsum(torsion_unnatural_trial_average)./((1:length(torsion_unnatural_trial_average))');

torsion_no_cummean = cumsum(torsion_no_trial_average)./((1:length(torsion_no_trial_average))');

% individual cumulated mean...
for ii = 1:9
    temp = nanmean(torsion_natural,2);
    torsion_natural_trial_averageIndividual(1:200, ii) = temp(1:200, 1, 1, ii);
    temp = nanmean(torsion_unnatural,2);
    torsion_unnatural_trial_averageIndividual(1:200, ii) = temp(1:200, 1, 1, ii);
    temp = nanmean(torsion_no,2);
    torsion_no_trial_averageIndividual(1:200, ii) = temp(1:200, 1, 1, ii);
end
% each column is one participant, each row is one trial in chronological
% order
denom = repmat((1:length(torsion_natural_trial_averageIndividual))', 1, 9);
torsion_natural_cummeanIndividual = cumsum(torsion_natural_trial_averageIndividual, 1, 'omitnan')./denom;
torsion_unnatural_cummeanIndividual = cumsum(torsion_unnatural_trial_averageIndividual, 1, 'omitnan')./denom;
torsion_no_cummeanIndividual = cumsum(torsion_no_trial_averageIndividual, 1, 'omitnan')./denom;

figure
hold on
for ii = 1:9
    if ii==1 || ii==6 || ii==7
        plot(torsion_no_cummeanIndividual(:, ii), '--')
    else
        plot(torsion_no_cummeanIndividual(:, ii))
    end
end
legend({'s1' 's2' 's3' 's4' 's5' 's6' 's7' 's8' 's9'})
set(gca,'FontSize',18)
set(gca,'linewidth',1.3);
% ylim([-0.5,1])
set(gca,'YTick',[-0.5,0,0.5,1]);
xlim([0,200])
set(gca,'XTick',[1 50 100 150 200]);
xlabel('Number of Trials')
ylabel('Anticipatory Torsion Velocity (deg/s)')
set(gcf,'color','w');
set(gca, 'fontweight', 'bold')
box off;
saveas(gca, 'noRotationLongTermIndividual.pdf')

figure
hold on
for ii = 1:9
    if ii==1 || ii==6 || ii==7
        plot(torsion_natural_cummeanIndividual(:, ii), '--')
    else
        plot(torsion_natural_cummeanIndividual(:, ii))
    end
end
legend({'s1' 's2' 's3' 's4' 's5' 's6' 's7' 's8' 's9'})
title('natural rotation')
 

torsion_natural_cumstd = cumstd(torsion_natural_trial_average);

torsion_unnatural_cumstd = cumstd(torsion_unnatural_trial_average);

torsion_no_cumstd = cumstd(torsion_no_trial_average);

 

f = figure;

% X range to plot

x_range = 1:200;

hold on;

 

nat = plot(x_range,torsion_natural_cummean,'b','linewidth', 3);

unnat = plot(x_range,torsion_unnatural_cummean,'g','linewidth', 3);

no = plot(x_range,torsion_no_cummean,'k','linewidth', 3);

 

 

% Stuff to make it look pretty

set(gca,'FontSize',18)

set(gca,'linewidth',1.3);

ylim([-0.5,1])

set(gca,'YTick',[-0.5,0,0.5,1]);

xlim([0,200])

set(gca,'XTick',[1 50 100 150 200]);

xlabel('Number of Trials')

ylabel('Anticipatory Torsion Velocity (deg/s)')

set(gcf,'color','w');

set(gca, 'fontweight', 'bold')

box off;

legend([nat, unnat, no],{'natural', 'unnatural', 'no rotation'})


