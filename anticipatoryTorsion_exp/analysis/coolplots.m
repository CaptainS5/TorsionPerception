%% Scatter plot?
clear all;
clc;
load('rawtorsion.mat')

torsionmeans = zeros(12,3);
for subject = 1:12
    nat = rawtorsion(:,1:2,subject);
    unnat = rawtorsion(:,3:4,subject);
    none = rawtorsion(:,5:6,subject);
    torsionmeans(subject,1) = mean(nat(nat~=0));
    torsionmeans(subject,2) = mean(unnat(unnat~=0));
    torsionmeans(subject,3) = mean(none(none~=0));
end
torsionmeans = [torsionmeans(:,1)-torsionmeans(:,3) torsionmeans(:,2)-torsionmeans(:,3)];

scatter([torsionmeans(1:6,1); torsionmeans(7:12,1)*-1] , [torsionmeans(1:6,2)*-1; torsionmeans(7:12,2)], 100, [3 3 3 3 3 3 4 4 4 4 4 4], 'filled')

%% Magnitude of horizontal ASP across blocks

load('horizontalnotflipped.mat')
horizontal = cat(3, horizontal(:,:,1:6)*-1, horizontal(:,:,7:12)); 
horz = mean(mean(horizontal),3);
%b = bar(horz, 'FaceColor', [.9 .5 .2]);

figure(1)
hold on
for i = 1:length(horz)
    h=bar(i,horz(i));
    if i > 4
        set(h,'FaceColor',[0.3 0.3 0.3]);
    else
        set(h,'FaceColor',[0.7 0.7 0.7]);
    end
end
hold off

hold on; 
errorbar(mean(mean(horizontal),3), std(mean(horizontal),[],3)./4, 'k.')

xlim([0.4 6.6])


box off;
set(gcf, 'color', 'w');
xlabel('Block', 'fontsize', 20);
ylabel('Horizontal Velocity (deg/s)', 'fontsize', 20);
set(gca, 'fontsize', 20);
set(gca, 'fontweight', 'bold');


%% Lineplots for each observer across blocks

load('horizontaldata.mat')
load('torsiondata.mat')

f = figure
for subject = 1:12
    for i = 1:6
        subplot(3,2,i)
        if subject < 7
            r = plot(horizontaldata(:,i,subject)', 'linewidth', 3, 'color', [.4 .6 0]);
        else
            l = plot(horizontaldata(:,i,subject)', 'linewidth', 3, 'color', [0 .3 .7]);
        end
        ylim([-8 8])
        xlim([1 10])
        set(gca, 'fontweight', 'bold')
        box off;
        if i > 4
            xlabel('Bin', 'fontsize', 14);
        end
        if mod(i,2) == 1
            ylabel('Horizontal Velocity (deg/s)', 'fontsize', 14);
        end
        hold on;
    end
    hold on;
end
set(gcf, 'color', 'w');
set(f, 'Position', [0,0 900 900])
legend([r l], {'Right', 'Left'}, 'Location','northeast');

%% more cool plots   - horizontal


load('horizontaldata.mat')
load('torsiondata.mat')

horizontaldata = cat(3, horizontaldata(:,:,1:6)*-1, horizontaldata(:,:,7:12));

nonehorizontal = nanmean(horizontaldata(:,5:6,:),2);
nathorizontal = nanmean(horizontaldata(:,1:2,:),2);
unnathorizontal = nanmean(horizontaldata(:,3:4,:),2);

% nonehorizontal = mean(nonehorizontal,3);
% nathorizontal = mean(nathorizontal,3);
% unnathorizontal = mean(unnathorizontal,3);

f =  figure
% nate = errorbar( mean(nathorizontal,3), std(nathorizontal,[],3)/3, 'k.', 'linewidth', 1.2);
% hold on;
% unnate = errorbar( mean(unnathorizontal,3), std(unnathorizontal,[],3)/3, 'k.', 'linewidth', 1.2);
% hold on;
% nonee = errorbar( mean(nonehorizontal,3), std(nonehorizontal,[],3)/3, 'k.', 'linewidth', 1.2);
xNone = [1:10]';
h1= fill([xNone;flipud(xNone)],[mean(nathorizontal,3)-std(nathorizontal,[],3)/3;flipud(mean(nathorizontal,3)+std(nathorizontal,[],3)/3)],[.3 .3 .8],'linestyle','none');
set(h1,'facealpha',.2)
hold on;
h2= fill([xNone;flipud(xNone)],[mean(unnathorizontal,3)-std(unnathorizontal,[],3)/3;flipud(mean(unnathorizontal,3)+std(unnathorizontal,[],3)/3)],[.8 .3 .3],'linestyle','none');
set(h2,'facealpha',.2)
hold on;
h3= fill([xNone;flipud(xNone)],[mean(nonehorizontal,3)-std(nonehorizontal,[],3)/3;flipud(mean(nonehorizontal,3)+std(nonehorizontal,[],3)/3)],[.3 .3 .3],'linestyle','none');
set(h3,'facealpha',.2)
hold on;
nat = plot( mean(nathorizontal,3), 'linewidth', 3, 'color', [0 0.2 0.9]);
hold on;
unnat = plot( mean(unnathorizontal,3), 'linewidth', 3, 'color', [0.9 0.2 0]);
hold on;
none = plot( mean(nonehorizontal,3), 'linewidth', 3, 'color', [0.2 0.2 0.2]);


xlabel('Bin', 'fontsize', 20);
ylabel('Horizontal Velocity (deg/s)', 'fontsize', 20);

ylim([0 4])
xlim([1 10])
set(gca, 'fontweight', 'bold')
box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 20);
set(gca, 'linewidth', 1.3);
set(f, 'PaperOrientation', 'landscape');
legend([nat unnat none], {'Natural', 'Unnatural', 'No Rotation'}, 'Location','northeast');
set(f, 'Position', [0,0 1000 600])


%% more cool plots   - torsion


load('horizontaldata.mat')
load('torsiondata.mat')

torsiondata = cat(3, torsiondata(:,:,1:6), torsiondata(:,:,7:12)*-1);

nonetorsion = nanmean(torsiondata(:,5:6,:),2);
nattorsion = nanmean(torsiondata(:,1:2,:),2);
unnattorsion = nanmean(torsiondata(:,3:4,:),2);

% nonehorizontal = mean(nonehorizontal,3);
% nathorizontal = mean(nathorizontal,3);
% unnathorizontal = mean(unnathorizontal,3);

f = figure
% nate = errorbar( mean(nathorizontal,3), std(nathorizontal,[],3)/3, 'k.', 'linewidth', 1.2);
% hold on;
% unnate = errorbar( mean(unnathorizontal,3), std(unnathorizontal,[],3)/3, 'k.', 'linewidth', 1.2);
% hold on;
% nonee = errorbar( mean(nonehorizontal,3), std(nonehorizontal,[],3)/3, 'k.', 'linewidth', 1.2);
xNone = [1:10]';
h1= fill([xNone;flipud(xNone)],[mean(nattorsion,3)-std(nattorsion,[],3)/3;flipud(mean(nattorsion,3)+std(nattorsion,[],3)/3)],[.3 .3 .8],'linestyle','none');
set(h1,'facealpha',.2)
hold on;
h2= fill([xNone;flipud(xNone)],[mean(unnattorsion,3)-std(unnattorsion,[],3)/3;flipud(mean(unnattorsion,3)+std(unnattorsion,[],3)/3)],[.8 .3 .3],'linestyle','none');
set(h2,'facealpha',.2)
hold on;
h3= fill([xNone;flipud(xNone)],[mean(nonetorsion,3)-std(nonetorsion,[],3)/3;flipud(mean(nonetorsion,3)+std(nonetorsion,[],3)/3)],[.3 .3 .3],'linestyle','none');
set(h3,'facealpha',.2)
hold on;
nat = plot( mean(nattorsion,3), 'linewidth', 3, 'color', [0 0.2 0.9]);
hold on;
unnat = plot( mean(unnattorsion,3), 'linewidth', 3, 'color', [0.9 0.2 0]);
hold on;
none = plot( mean(nonetorsion,3), 'linewidth', 3, 'color', [0.2 0.2 0.2]);


xlabel('Bin', 'fontsize', 20);
ylabel('Torsion Velocity (deg/s)', 'fontsize', 20);

ylim([-0.5 1])
xlim([1 10])
set(gca, 'fontweight', 'bold')
box off;
set(gcf, 'color', 'w');
set(gca, 'fontsize', 20);
set(gca, 'linewidth', 1.3);
set(f, 'PaperOrientation', 'landscape');
legend([nat unnat none], {'Natural', 'Unnatural', 'No Rotation'}, 'Location','northeast');
set(f, 'Position', [0,0 1000 600])

