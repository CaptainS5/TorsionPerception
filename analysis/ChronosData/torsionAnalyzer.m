%Setup keys
enterKey = 13;

fig = figure('Position', [10 10 screenSize(3), screenSize(4)],'Name','Analyze Torsion');
hold on;
data.segments(data.segments<-100) = NaN;


currentTrial = 0;





while(true)
    waitforbuttonpress
    
    clf;
    ylim([-5 5])
    hold on;
    
    colors = {[0 0 1], [1 0 0], [0 1 0], [1 0 1], [0 1 1], [0.8,0.7,0.6]};
    
    currentTrial = currentTrial +1;
    trial = setupTrial(data, logData, saccades, currentTrial);
    
    
    on = trial.startFrame-20;
    off = trial.endFrame;
    
    numberOfSegments = length(data.segments(1,:))
    if mod(numberOfSegments, 2) == 1
        numberOfSegments = numberOfSegments -1;
    end
    
    legendString = [];
    
    for i = 1:numberOfSegments

        plot(data.segments(on:off,i),'Color',cell2mat(colors(i)))

    end
      
    plot(data.X_filt(on:off),'k:');
    plot(data.Y_filt(on:off),'Color', [0.7 0.7 0.7],'LineStyle',':');
    plot(data.T_filt(on:off),'k');
    
    legend(num2str(currentTrial));
    
    hold off;
end




