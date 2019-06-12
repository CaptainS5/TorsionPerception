clear all;
close('all');
load('saccades.mat');
try
    load('allTorsionalSaccades.mat');
    disp('Saccade file loaded.');
catch  %#ok<CTCH>
    allTorsionalSaccades = [];
    disp('Saccade file created.');
end


experiment = 13;

startBlock = 2;
endBlock= 8;

subject = 6;
numberOfTrials = 100;

eye = 0;

torsionalSaccades = [];

for block = startBlock:endBlock
    
    for trial = 1:numberOfTrials
        
        relevantSaccades = saccades(saccades(:,1) == experiment & saccades(:,2) == trial & saccades(:,3) == subject & saccades(:,4) == block & saccades(:,5) == eye,:);
        numberOfRelevantSaccades = size(relevantSaccades,1);
        
        xSaccades = relevantSaccades(relevantSaccades(:,10)==0,:);
        ySaccades = relevantSaccades(relevantSaccades(:,10)==1,:);
        tSaccades = relevantSaccades(relevantSaccades(:,10)==2,:);
        
        startFrame = 1;
        endFrame = 400;
        
        for i = 1:size(tSaccades,1)
            
            tEntry = tSaccades(i,:);
            tEntry(19) = NaN;
            tEntry(20) = NaN;
            
            tStart = tSaccades(i,11);
            tEnd = tSaccades(i,12);
            
            for j = 1:size(xSaccades,1)
                xStart = xSaccades(j,11);
                xEnd = xSaccades(j,12);
                
                if (xStart >= tStart && xStart <= tEnd) || (tStart >= xStart && tStart <= xEnd)
                    tEntry(19) = xStart - tStart;
                end
                
            end
            
            for j = 1:size(ySaccades,1)
                yStart = ySaccades(j,11);
                yEnd = ySaccades(j,12);
                
                if (yStart >= tStart && yStart <= tEnd) || (tStart >= yStart && tStart <= yEnd)
                    tEntry(20) = yStart - tStart;
                end
                
            end
            
            torsionalSaccades = [torsionalSaccades; tEntry];
            
        end
        
    end
end

% allTorsionalSaccades = [allTorsionalSaccades; torsionalSaccades];
% save('allTorsionalSaccades','allTorsionalSaccades');