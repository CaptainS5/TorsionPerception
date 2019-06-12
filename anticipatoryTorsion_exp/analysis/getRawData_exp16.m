subjectlist = { '01' '02' '03' '04'  '06' '07' '08' '09' '10'};
blocklist = {'02' '04' '06' '08' '10' '12'};

% Mean torsion and horizontal velocity over single trial
torsionAnt = nan(200,3,length(subjectlist));
horizontalAnt = nan(200,3,length(subjectlist));
torsionPursuit = nan(200,3,length(subjectlist));
horizontalPursuit = nan(200,3,length(subjectlist));
numNonError = zeros(length(subjectlist),3);

% torsion and horizontal velocity at each sample for each trial
raw_data_X = zeros(200,450,3,length(subjectlist));
raw_data_Y = zeros(200,450,3,length(subjectlist));
raw_data_T = zeros(200,450,3,length(subjectlist));

for subj = 1:length(subjectlist)
    
    % Subject details
    subject = subjectlist{subj};

    counts = [ 0 0 0];
    
    num_nat = 0;
    num_unnat = 0;
    num_no = 0;
    
    for block = 1:6
        % read in data and socscalexy
        filename = ['Subject' subject '_Block' blocklist{block} '_R.dat'];
        filelocation = ['D:\admin-austin\TorsionAnticipation\TorsionAnticipation\exp16\subj' subject];
        data = readDataFile(filename, filelocation);
        data = socscalexy(data);
        [header, logData] = readLogFile(block*2, ['subject' subject 'log.txt'] , filelocation);
        sampleRate = 200;  
        
        % get mean velocities for RIGHT eye
        Rvels = [];
        
        antStart = 90;
        antEnd = 109;
        
        pursuitStart = 110;
        pursuitEnd = 449;
        
        errors = load(['./ErrorFiles/Exp16_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
        
        for t = 1:100
            if logData.rotationalDirection(t) == 1
                num_nat = num_nat  + 1;
            elseif logData.rotationalDirection(t) == -1
                num_unnat = num_unnat + 1;
            else
                num_no = num_no + 1;
            end
            
            if errors.errorStatus(t) == 0
                currentTrial = t;
                analyzeTrial;
                if logData.rotationalDirection(t) == 1
                    counts(1) = counts(1)+1;

                    tAntInd = find(isnan(torsionAnt(:,1,subj)), 1, 'first');
                    hAntInd = find(isnan(horizontalAnt(:,1,subj)), 1, 'first');
                    tPurInd = find(isnan(torsionPursuit(:,1,subj)), 1, 'first');
                    hPurInd = find(isnan(horizontalPursuit(:,1,subj)), 1, 'first');
%                     rawXInd = find(raw_data_X(:,1,1,subj)==0, 1, 'first');
%                     rawTInd = find(raw_data_T(:,1,1,subj)==0, 1, 'first');

                    rawXInd = num_nat;
                    rawYInd = num_nat;
                    rawTInd = num_nat;

                    torsionAnt(tAntInd,1,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                    horizontalAnt(hAntInd,1,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                    torsionPursuit(tPurInd,1,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd));
                    horizontalPursuit(hPurInd,1,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                    
                    raw_data_X(rawXInd,:,1,subj) = trial.frames.DX_noSac(1:450);
                    raw_data_Y(rawXInd,:,1,subj) = trial.frames.DY_noSac(1:450);
                    raw_data_T(rawTInd,:,1,subj) = trial.frames.DT_noSac(1:450);
                elseif logData.rotationalDirection(t) == -1

                    counts(2) = counts(2)+1;

                    tAntInd = find(isnan(torsionAnt(:,2,subj)), 1, 'first');
                    hAntInd = find(isnan(horizontalAnt(:,2,subj)), 1, 'first');
                    tPurInd = find(isnan(torsionPursuit(:,2,subj)), 1, 'first');
                    hPurInd = find(isnan(horizontalPursuit(:,2,subj)), 1, 'first');
%                     rawXInd = find(raw_data_X(:,1,2,subj)==0, 1, 'first');
%                     rawYInd = find(raw_data_Y(:,1,2,subj)==0, 1, 'first');
%                     rawTInd = find(raw_data_T(:,1,2,subj)==0, 1, 'first');
                    
                    rawXInd = num_unnat;
                    rawYInd = num_unnat;
                    rawTInd = num_unnat;

                    torsionAnt(tAntInd,2,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                    horizontalAnt(hAntInd,2,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                    torsionPursuit(tPurInd,2,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd));
                    horizontalPursuit(hPurInd,2,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                    
                    raw_data_X(rawXInd,:,2,subj) = trial.frames.DX_noSac(1:450);
                    raw_data_Y(rawYInd,:,2,subj) = trial.frames.DY_noSac(1:450);
                    raw_data_T(rawTInd,:,2,subj) = trial.frames.DT_noSac(1:450);
                elseif logData.rotationalDirection(t) == 0
                    counts(3) = counts(3)+1;

                    tAntInd = find(isnan(torsionAnt(:,3,subj)), 1, 'first');
                    hAntInd = find(isnan(horizontalAnt(:,3,subj)), 1, 'first');
                    tPurInd = find(isnan(torsionPursuit(:,3,subj)), 1, 'first');
                    hPurInd = find(isnan(horizontalPursuit(:,3,subj)), 1, 'first');
%                     rawXInd = find(raw_data_X(:,1,3,subj)==0, 1, 'first');
%                     rawYInd = find(raw_data_Y(:,1,3,subj)==0, 1, 'first');
%                     rawTInd = find(raw_data_T(:,1,3,subj)==0, 1, 'first');
                    
                    rawXInd = num_no;
                    rawYInd = num_no;
                    rawTInd = num_no;

                    torsionAnt(tAntInd,3,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                    horizontalAnt(hAntInd,3,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                    torsionPursuit(tPurInd,3,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd));
                    horizontalPursuit(hPurInd,3,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                    
                    raw_data_X(rawXInd,:,3,subj) = trial.frames.DX_noSac(1:450);
                    raw_data_Y(rawYInd,:,3,subj) = trial.frames.DY_noSac(1:450);
                    raw_data_T(rawTInd,:,3,subj) = trial.frames.DT_noSac(1:450);
                end
            end
        end
    end
    numNonError(subj,:) = counts;
end

raw_data_X(raw_data_X == 0) = nan;
raw_data_Y(raw_data_Y == 0) = nan;
raw_data_T(raw_data_T == 0) = nan;
save('exp16_raw_horizontal_velocity.mat', 'raw_data_X')
save('exp16_raw_vertical_velocity.mat', 'raw_data_Y')
save('exp16_raw_torsion_velocity.mat', 'raw_data_T')

