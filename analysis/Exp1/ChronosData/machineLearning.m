% Since TreeBagger uses randomness we will get different results each
% time we run this.
% This makes sure we get the same results every time we run the code.
rng default

subjectList = [1 2 3 4 6 8 16 18];
experimentList = [1 2 4 12 13];
importance = [];

subject = 99;
experiment = 99;

% for subject = subjectList
%     
%     for experiment = experimentList
        
        
        
        
        data = eyeDataFiltered(eyeDataFiltered(:,3)==0,:);%(eyeDataFiltered(:,2)==subject&eyeDataFiltered(:,1)==experiment,:);
        
        data = data(randperm(size(data,1)),:);
        
%         if  length(data) == 0
%            continue; 
%         end
        
        split = round(length(data)*0.75);
        
        trainData = data(1:split,:);
        testData = data(split+1:length(data),:);
        
        features = trainData(:,[8 11 12 14 15 16 24 27]);
        %features = trainData(:,4:26);
        classLabels = trainData(:,4);
        
        % How many trees do you want in the forest?
        nTrees = 40;
        
        % Train the TreeBagger (Decision Forest).
        B = TreeBagger(nTrees,features,classLabels,'OOBVarImp','on','Method','classification');
        [oobPredictions, oobScores] = oobPredict(B);
        oobPredictions = str2double(oobPredictions);
        [conf,classorder] = confusionmat(classLabels,oobPredictions);
        correct = conf(1,1)+conf(2,2);
        incorrect = conf(2,1)+conf(1,2);
        ratio = correct/(incorrect+correct);
        

        importance = [importance; B.OOBPermutedPredictorDeltaError];
        %Use the trained Decision Forest.
        predChar = B.predict(testData(:,[8 11 12 14 15 16 24 27]));
        %predChar = B.predict(testData(:,4:26));
        predictions = str2double(predChar);
        actualData = testData(:,4);
        correctPredicitions = mean(actualData == predictions);
        
        disp(['Subject ' num2str(subject) ' Experiment ' num2str(experiment) ' Training: ' num2str(ratio) ' Test: ' num2str(correctPredicitions) ' ' num2str(length(data))]);
        
%     end
% end