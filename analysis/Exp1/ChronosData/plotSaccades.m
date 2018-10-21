clear all;
close('all');
load('saccades.mat');

experiment = 12;
block = 8;
subject = 1;
numberOfTrials = 1;
eye = 1;


for trial = 1:numberOfTrials
    
    filename = ['Exp' num2str(experiment) '_'];
    filename = [filename 'Subj' num2str(subject) '_'];
    filename = [filename 'Block' num2str(block) '_'];
    filename = [filename 'Eye' num2str(eye) '_'];
    filename = [filename 'Trial' num2str(trial) '_'];
    filename = fullfile(pwd, 'SaccadePlots', filename);
    
    
    
    relevantSaccades = saccades(saccades(:,1) == experiment & saccades(:,2) == trial & saccades(:,3) == subject & saccades(:,4) == block & saccades(:,5) == eye,:);
    numberOfRelevantSaccades = size(relevantSaccades,1);
    
    startFrame = 1;
    endFrame = 400;
     
    timeInMs = [-200 0 200 400 600 800 1000 1200 1400 1600 1800];
    tickStep = (2000/5)/(length(timeInMs)-1);
    figure;
    
    
    axis([startFrame endFrame -15 15]);
    %change frames to ms
    set(gca,'Xtick',startFrame:tickStep:endFrame,'XTickLabel',timeInMs);
    
    xlabel('Time(ms)', 'fontsize', 12);
    ylabel('CCW,toRight,Up    Position (degree)    CW,toLeft,Down', 'fontsize', 10);
    
    hold on;
    
    for i = 1:numberOfRelevantSaccades
        
        
        saccade = relevantSaccades(i,:);
        type = saccade(10);
        onset = saccade(11)/5+40;
        offset = saccade(12)/5+40;
        type_offset = 2 * type;
        onset_pos = saccade(13+type_offset);
        offset_pos = saccade(14+type_offset);
        if(type == 2)
            onset_pos = onset_pos*3;
            offset_pos = offset_pos*3;
        end
        
        colors = {'k','b','g'};
        
        
        plot(onset, onset_pos, 'Marker','o','MarkerSize',2,'Color',colors{type+1});
        plot(offset,offset_pos, 'Marker','o','MarkerSize',3,'Color',colors{type+1});
        plot([onset offset],[onset_pos offset_pos],'Color',colors{type+1});
        
    end
    
    translationalDirection = {'toRight','toLeft'};
    rotationalDirection = {'CW','CCW'};
    natural = {'unnatural','natural'};
    
    if saccade(6) == saccade(7)
        isNatural = 2;
    else
        isNatural = 1;
    end
    
    annotation('textbox',...
        [0.15 0.15 0.5 0.05],...
        'String',[translationalDirection{saccade(6)+1} ' ' rotationalDirection{saccade(7)+1} ' ' natural{isNatural}],...
        'LineStyle','none');
    
    saveas(gcf, [filename '.png']);
    
    close('all');
    
end