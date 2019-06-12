experiment = 14;
subjectlist = { '04' '05' '06' '07' '08' '09' '11' '12' '13' '15' '16' '17'};
rotDirList  = [   0    0    1    1    1    0  0  0  1  1  1  1];

raw_data_X = zeros(200,450,3,length(subjectlist));
raw_data_Y = zeros(200,450,3,length(subjectlist));
raw_data_T = zeros(200,450,3,length(subjectlist));

for subj = 1:length(subjectlist)
    
    subject = subjectlist{subj};
    blocklist = {'02' '04' '06' '08' '10' '12'};
    NaturalFirst = rotDirList(subj);
    block1X = [];
    block2X = [];
    block3X = [];
    block1Y = [];
    block2Y = [];
    block3Y = [];
    block1T = [];
    block2T = [];
    block3T = [];
    block1Ons = [];
    block2Ons = [];
    block3Ons = [];
    for block = 1:6

        % read in data and socscalexy
        filename = ['Subject' subject '_Block' blocklist{block} '_R.dat'];
        filelocation = ['D:\admin-austin\TorsionAnticipation\TorsionAnticipation\exp' num2str(experiment) '\subj' subject];
        data = readDataFile(filename, filelocation);
        data = socscalexy(data);

        % get mean velocities for RIGHT eye
        RXvels = [];
        RYvels = [];
        RTvels = [];
        errors = load(['./ErrorFiles/Exp' num2str(experiment) '_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
        Ronsets = [];
        [header, logData] = readLogFile(block*2, ['subject' subject 'log.txt'] , filelocation);
        sampleRate = 200;
        for n = 1:10
            for i = n*10-9:n*10
%                 if errors.errorStatus(i) == 3
%                     RXvels = [RXvels; nan(1,450)];
%                     RTvels = [RTvels; nan(1,450)];
%                     Ronsets = [Ronsets; nan];
%                 end
                if errors.errorStatus(i) == 0 && data.startFrames(i) + 429 <= length(data.DT_filt)
                    %RXvels = [RXvels; data.DX_filt(data.startFrames(i)+50:data.startFrames(i)+249)'];
                    %RTvels = [RTvels; data.DY_filt(data.startFrames(i)+50:data.startFrames(i)+249)'];
                    trial = setupTrial(data, header, logData, i);
                    currentTrial = i;
                    analyzeTrial;
                    RXvels = [RXvels; trial.frames.DX_noSac(1:450)'];
                    RYvels = [RYvels; trial.frames.DY_noSac(1:450)'];
                    RTvels = [RTvels; trial.frames.DT_noSac(1:450)'];
                    Ronsets = [Ronsets; pursuit.onset];
                else
                    RXvels = [RXvels; nan(1,450)];
                    RYvels = [RYvels; nan(1,450)];
                    RTvels = [RTvels; nan(1,450)];
                    Ronsets = [Ronsets; nan];
                end
            end
        end


        if block < 3
            block1X = [block1X; RXvels];
        elseif block < 5
            block2X = [block2X; RXvels];
        else
            block3X = [block3X; RXvels];
        end
        
        if block < 3
            block1Y = [block1Y; RYvels];
        elseif block < 5
            block2Y = [block2Y; RYvels];
        else
            block3Y = [block3Y; RYvels];
        end

        if block < 3
            block1T = [block1T; RTvels];
        elseif block < 5
            block2T = [block2T; RTvels];
        else
            block3T = [block3T; RTvels];
        end

        if block < 3
            block1Ons = [block1Ons; Ronsets];
        elseif block < 5
            block2Ons = [block2Ons; Ronsets];
        else
            block3Ons = [block3Ons; Ronsets];
        end

    end

    %Swap first 2 blocks with 3rd and 4th blocks if not Natural First
    if NaturalFirst
        natVelsX = block1X;
        unnatVelsX = block2X;
        noneVelsX = block3X;
    else
        natVelsX = block2X;
        unnatVelsX = block1X;
        noneVelsX = block3X;
    end
    
    if NaturalFirst
        natVelsY = block1Y;
        unnatVelsY = block2Y;
        noneVelsY = block3Y;
    else
        natVelsY = block2Y;
        unnatVelsY = block1Y;
        noneVelsY = block3Y;
    end

    if NaturalFirst
        natVelsT = block1T;
        unnatVelsT = block2T;
        noneVelsT = block3T;
    else
        natVelsT = block2T;
        unnatVelsT = block1T;
        noneVelsT = block3T;
    end

    if NaturalFirst
        natons = block1Ons;
        unnatons = block2Ons;
        noneons = block3Ons;
    else
        natons = block2Ons;
        unnatons = block1Ons;
        noneons = block3Ons; 
    end
    
    
    subject_raw_data_X = cat(3, natVelsX, unnatVelsX, noneVelsX);
%     save(['subject' subjectlist{subj} 'exp14_horizontal_velocity.mat'], 'subject_raw_data_X')
    
    subject_raw_data_Y = cat(3, natVelsY, unnatVelsY, noneVelsY);

    subject_raw_data_T = cat(3, natVelsT, unnatVelsT, noneVelsT);
%     save(['subject' subjectlist{subj} 'exp14_torsion_velocity.mat'], 'subject_raw_data_T')

    raw_data_X(:,:,:,subj) = subject_raw_data_X;
    raw_data_Y(:,:,:,subj) = subject_raw_data_Y;
    raw_data_T(:,:,:,subj) = subject_raw_data_T;
    
end

save('exp14_raw_horizontal_velocity.mat', 'raw_data_X')
save('exp14_raw_vertical_velocity.mat', 'raw_data_Y')
save('exp14_raw_torsion_velocity.mat', 'raw_data_T')
