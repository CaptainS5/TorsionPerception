% Xiuyun Wu, 10/17/2018
% direction, initial angle1, reversal angle1, all are target
% properties--needs to check the target side to see which side the
% stimulus is
clear all; close all; clc

global trial

% names = {'XWcontrolTest' 'XWcontrolTest2' 'XWcontrolTest3'};
% conditions = [25 50 100 200 400];
names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol' 'FScontrol' 'XWcontrol' 'SCcontrol' 'JFcontrol'};
conditions = [25 50 100 200];
cd ..
analysisF = pwd;
folder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\TorsionPerception\data'};
direction = [-1 1]; % initial direction; in the plot shows the direction after reversal
trialPerCon = 72; % for each rotation speed, all directions together though...
torsionThreshold = 8*ones(size(names));
torsionFrames = 3*ones(size(names));
eyeName = {'L' 'R'};
% eyeName = {'R'};
% change both paramters below, as well as time window in the loop
% around line 100
% checkAngle = -1; % 1-for direction after reversal, -1 for direction before reversal
% for the endName, also change around line70 for the time window used
% endName = '120msToReversal';
% endName = '120msAroundReversal';
% endName = '120msToEnd';
endName = 'atReversal';

trialData = table(); % organize into long format
conData = table();
countLc = 1;
trialDeleted = zeros(1, length(names));

cd ..
load(['dataBase_all', num2str(size(names, 2)), '.mat'])

for subj = 1:length(names)
    cd(analysisF)
    %     if subj <=2
    %         conditions = conditions0;
    %     elseif subj<=3
    %         conditions = conditions1;
    %     elseif subj<=5
    %         conditions = conditions2;
    %     else
    %         conditions = conditions3;
    %     end
    for eye = 1:size(eyeName, 2)
        % Subject details
        subject = names{subj};        
        counts = {zeros(size(conditions)) zeros(size(conditions))};
        
        countLt = 1;
        dataTemp = table();
        for block = 1:6
            % read in data and socscalexy
            filename = ['session_' num2str(block,'%.2i') '_' eyeName{eye} '.dat'];
            %             if subj==5 && block==5 % for KT, 5
            %                 data = readDataFile_KTb5(filename, [folder{:} '\' subject '\chronos']);
            %             elseif subj==6 && block==3 % for MS, 3-lost frames...
            %                 data = readDataFile_MSb3(filename, [folder{:} '\' subject '\chronos']);
            %             elseif subj==7 && block==1 % for IC, 1
            %                 data = readDataFile_ICb1(filename, [folder{:} '\' subject '\chronos']);
            %             elseif subj==9 && block==5 % for NY, 5-lost frames...
            %                 data = readDataFile_NYb5(filename, [folder{:} '\' subject '\chronos']);
            %             elseif subj==13 && block==4 % for NY, 5-lost frames...
            %                 data = readDataFile_RRb4(filename, [folder{:} '\' subject '\chronos']);
            %             else
            data = readDataFile(filename, [folder{:} '\' subject '\chronos']);
            %             end
            data = socscalexy(data);
            [header, logData] = readLogFile(block, ['response' num2str(block,'%.2i') '_' subject] , [folder{:} '\' subject]);
            sampleRate = 200;
            
            % load raw perception data for trial exclusion
            dataFile = dir([folder{:} '\' subject '\response' num2str(block) '_*.mat']);
            load([folder{:} '\' subject '\' dataFile.name]) % resp is the response data for the current block
            
            % get mean velocities for each eye
            errors = load(['Errorfiles\Exp' num2str(block) '_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_' eyeName{eye} '_errorFile.mat']);
            
            for t = 1:size(resp, 1) % trial number
                if errors.errorStatus(t)==0 % valid eye data trial
                    currentTrial = t;
                    % setup trial
                    trial = setupTrial(data, header, logData, currentTrial);
                    trial.torsionFrames = torsionFrames(subj);
                    
                    %% change the time window here
                                        % at reversal
                                        trial.stim_onset = trial.stim_reversal; % reversal
                                        trial.stim_offset = trial.stim_reversal+ms2frames(40+120); % reversal
                    %
                    % %                     trial.stim_onset = trial.stim_reversal+ms2frames(10); % reversal--if taken delay into account...
                    % %                     trial.stim_offset = trial.stim_reversal+ms2frames(50); % reversal
%                     % 120ms to reversal
%                     trial.stim_onset = ms2frames(logData.fixationDuration(currentTrial)*1000+120); % 120ms latency
%                     trial.stim_offset = trial.stim_reversal; % reversal
                    % % around reversal
                    %                     trial.stim_onset = trial.stim_reversal;
                    %                     trial.stim_offset = trial.stim_reversal + ms2frames((0.12)*1000); % 120ms after reversal
%                                                             % 120ms to end
%                                                             trial.stim_onset = trial.stim_reversal + ms2frames((0.12+0.04)*1000);
%                                                             trial.stim_offset = trial.stim_onset + ms2frames((logData.durationAfter(currentTrial)-0.12)*1000); % end of display
                    
                    find saccades;
                    [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                    % [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, trial.stimulusMeanVelocity);
                    [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                    [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subj), 0);
                    
                    % analyze saccades
                    [trial] = analyzeSaccades(trial, saccades);
                    clear saccades;
                    
                    % remove saccades
                    trial = removeSaccades(trial);
                    
                    %% analyze torsion
                    pursuit.onset = trial.stim_onset; % the frame to start torsion analysis
                    [torsion, trial] = analyzeTorsion(trial, pursuit);
                    % end of analyzeTrial
                    
                    dataTemp.sub(countLt, 1) = subj;
                    if strcmp(eyeName{eye}, 'L')
                        dataTemp.eye(countLt, 1) = 1; % 1-left,
                    elseif strcmp(eyeName{eye}, 'R')
                        dataTemp.eye(countLt, 1) = 2; % 2-right
                    end
                    
                    dirIdx = find(direction==resp.initialDirection(t)); % 1-clockwise, 2-counterclockwise
                    conIdx = find(conditions==resp.rotationSpeed(t));
                    
                    dataTemp.rotationSpeed(countLt, 1) = resp.rotationSpeed(t);
                    dataTemp.afterReversalD(countLt, 1) = -direction(dirIdx); % 1-clockwise, -1 counterclockwise
                    % this is the direction of the stimulus on the same side as the eye
                    if (dataTemp.eye(countLt, 1)==1 && resp.targetSide(t)==-1) || (dataTemp.eye(countLt, 1)==2 && resp.targetSide(t)==1) % same side
                        dataTemp.sameSideAfterReversalD(countLt, 1) = -direction(dirIdx); % 1-clockwise, -1 counterclockwise
                    else % different side
                        dataTemp.sameSideAfterReversalD(countLt, 1) = direction(dirIdx); % 1-clockwise, -1 counterclockwise
                    end
                    
                    dataTemp.targetSide(countLt, 1) = resp.targetSide(t);
                    
                    startFrame = trial.stim_onset;
                    endFrame = trial.stim_offset;
                    
                    %% perceptual error
                    resp.reportAngle(t) = resp.reportAngle(t)-90;
                    if resp.reportAngle(t) < 0
                        resp.reportAngle(t) = resp.reportAngle(t)+180;
                    end
                    resp.reversalAngle(t) = resp.reversalAngle(t)-90;
                    if resp.reversalAngle(t) < 0
                        resp.reversalAngle(t) = resp.reversalAngle(t)+180;
                    end
                    dataTemp.perceptualError(countLt, 1) = -(resp.reportAngle(t)-resp.reversalAngle(t))*resp.initialDirection(t);
                    if dataBase.a(subj, 1)~=0
                        if dataTemp.perceptualError(countLt, 1)>dataBase.b(subj, 1) && dataTemp.perceptualError(countLt, 1)<=dataBase.asympt(subj, 1)
                            dataTemp.perceptualError(countLt, 1) = (dataTemp.perceptualError(countLt, 1)-dataBase.b(subj, 1))./(dataBase.a(subj, 1)+1);
                        elseif dataTemp.perceptualError(countLt, 1)>dataBase.asympt(subj, 1)
                            dataTemp.perceptualError(countLt, 1) = dataTemp.perceptualError(countLt, 1)-(dataBase.asympt(subj, 1)-16);
                        elseif dataTemp.perceptualError(countLt, 1)<-dataBase.b(subj, 1) && dataTemp.perceptualError(countLt, 1)>=-dataBase.asympt(subj, 1)
                            dataTemp.perceptualError(countLt, 1) = (dataTemp.perceptualError(countLt, 1)+dataBase.b(subj, 1))./(dataBase.a(subj, 1)+1);
                        elseif dataTemp.perceptualError(countLt, 1)<-dataBase.asympt(subj, 1)
                            dataTemp.perceptualError(countLt, 1) = dataTemp.perceptualError(countLt, 1)+(dataBase.asympt(subj, 1)-16);
                        end
                    else
                        if dataTemp.perceptualError(countLt, 1)>dataBase.b(subj, 1)
                            dataTemp.perceptualError(countLt, 1) = dataTemp.perceptualError(countLt, 1) - dataBase.b(subj, 1);
                        elseif dataTemp.perceptualError(countLt, 1)<-dataBase.b(subj, 1)
                            dataTemp.perceptualError(countLt, 1) = dataTemp.perceptualError(countLt, 1) + dataBase.b(subj, 1);
                        end
                    end
                    %                     dataTemp.perceptualError(countLt, 1) = -(resp.reportAngle(t)-resp.reversalAngle(t))*resp.initialDirection(t)-dataBase.baseErrorMean(subj, 1);
                    
                    if dataTemp.perceptualError(countLt, 1)>-10 && abs(torsion.slowPhases.meanSpeed)<30
                        
                        %% retinal torsion angle
                        dataTemp.torsionPosition(countLt, 1) = nanmean(torsion.slowPhases.onsetPosition);
                        
                        %% torsion velocity
                        dataTemp.torsionVelT(countLt, 1) = torsion.slowPhases.meanSpeed;
                        
                        %% torsion velocity gain
                        dataTemp.torsionVGain(countLt, 1) = torsion.slowPhases.meanSpeed/conditions(conIdx);
                        
                        %% torsion magnitude
                        dataTemp.torsionAngleTotal(countLt, 1) = torsion.slowPhases.totalAngle;
                        dataTemp.torsionAngleCW(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        dataTemp.torsionAngleCCW(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                        % angle in the direction of target motion...
                        if dataTemp.afterReversalD(countLt, 1)==-1
                            dataTemp.torsionAngleTSame(countLt, 1) = -torsion.slowPhases.totalAngleCCW; % same as afterReversal angle
                            dataTemp.torsionAngleTAnti(countLt, 1) = torsion.slowPhases.totalAngleCW; % opposite to afterReversal angle
                            
                            dataTemp.sacNumTTSame(countLt, 1) = trial.saccades.T_CCW.number;
                            dataTemp.sacAmpSumTTSame(countLt, 1) = trial.saccades.T_CCW.sum;
                            dataTemp.sacAmpMeanTTSame(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
                            
                            dataTemp.sacNumTTAnti(countLt, 1) = trial.saccades.T_CW.number;
                            dataTemp.sacAmpSumTTAnti(countLt, 1) = trial.saccades.T_CW.sum;
                            dataTemp.sacAmpMeanTTAnti(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                        else
                            dataTemp.torsionAngleTSame(countLt, 1) = torsion.slowPhases.totalAngleCW; % same as afterReversal angle
                            dataTemp.torsionAngleTAnti(countLt, 1) = -torsion.slowPhases.totalAngleCCW; % opposite to afterReversal angle
                            
                            dataTemp.sacNumTTSame(countLt, 1) = trial.saccades.T_CW.number;
                            dataTemp.sacAmpSumTTSame(countLt, 1) = trial.saccades.T_CW.sum;
                            dataTemp.sacAmpMeanTTSame(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                            
                            dataTemp.sacNumTTAnti(countLt, 1) = trial.saccades.T_CCW.number;
                            dataTemp.sacAmpSumTTAnti(countLt, 1) = trial.saccades.T_CCW.sum;
                            dataTemp.sacAmpMeanTTAnti(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
                        end
                        %                         angles = [trialData.torsionAngleSame(countLt, 1) trialData.torsionAngleAnti(countLt, 1)];
                        %                         idx = find(abs(angles)==max(abs(angles(:))));
                        %                         trialData.torsionAngle(countLt, 1) = angles(idx);
                        
                        % angle in the direction of the rotation on the same side as the eye...
                        if (dataTemp.eye(countLt, 1)==1 && resp.targetSide(t)==-1) || (dataTemp.eye(countLt, 1)==2 && resp.targetSide(t)==1) % same side
                            if dataTemp.afterReversalD(countLt, 1)==-1
                                dataTemp.torsionAngleSSame(countLt, 1) = -torsion.slowPhases.totalAngleCCW; % same as afterReversal angle
                                dataTemp.torsionAngleSAnti(countLt, 1) = torsion.slowPhases.totalAngleCW; % opposite to afterReversal angle
                                
                                dataTemp.sacNumTSSame(countLt, 1) = trial.saccades.T_CCW.number;
                                dataTemp.sacAmpSumTSSame(countLt, 1) = trial.saccades.T_CCW.sum;
                                dataTemp.sacAmpMeanTSSame(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
                                
                                dataTemp.sacNumTSAnti(countLt, 1) = trial.saccades.T_CW.number;
                                dataTemp.sacAmpSumTSAnti(countLt, 1) = trial.saccades.T_CW.sum;
                                dataTemp.sacAmpMeanTSAnti(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                            else
                                dataTemp.torsionAngleSSame(countLt, 1) = torsion.slowPhases.totalAngleCW; % same as afterReversal angle
                                dataTemp.torsionAngleSAnti(countLt, 1) = -torsion.slowPhases.totalAngleCCW; % opposite to afterReversal angle
                                
                                dataTemp.sacNumTSSame(countLt, 1) = trial.saccades.T_CW.number;
                                dataTemp.sacAmpSumTSSame(countLt, 1) = trial.saccades.T_CW.sum;
                                dataTemp.sacAmpMeanTSSame(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                                
                                dataTemp.sacNumTSAnti(countLt, 1) = trial.saccades.T_CCW.number;
                                dataTemp.sacAmpSumTSAnti(countLt, 1) = trial.saccades.T_CCW.sum;
                                dataTemp.sacAmpMeanTSAnti(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
                            end
                        else % different side
                            if dataTemp.afterReversalD(countLt, 1)==-1
                                dataTemp.torsionAngleSSame(countLt, 1) = torsion.slowPhases.totalAngleCW; % same as afterReversal angle
                                dataTemp.torsionAngleSAnti(countLt, 1) = -torsion.slowPhases.totalAngleCCW; % opposite to afterReversal angle
                                
                                dataTemp.sacNumTSSame(countLt, 1) = trial.saccades.T_CW.number;
                                dataTemp.sacAmpSumTSSame(countLt, 1) = trial.saccades.T_CW.sum;
                                dataTemp.sacAmpMeanTSSame(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                                
                                dataTemp.sacNumTSAnti(countLt, 1) = trial.saccades.T_CCW.number;
                                dataTemp.sacAmpSumTSAnti(countLt, 1) = trial.saccades.T_CCW.sum;
                                dataTemp.sacAmpMeanTSAnti(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
                            else
                                dataTemp.torsionAngleSSame(countLt, 1) = -torsion.slowPhases.totalAngleCCW; % same as afterReversal angle
                                dataTemp.torsionAngleSAnti(countLt, 1) = torsion.slowPhases.totalAngleCW; % opposite to afterReversal angle
                                
                                dataTemp.sacNumTSSame(countLt, 1) = trial.saccades.T_CCW.number;
                                dataTemp.sacAmpSumTSSame(countLt, 1) = trial.saccades.T_CCW.sum;
                                dataTemp.sacAmpMeanTSSame(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
                                
                                dataTemp.sacNumTSAnti(countLt, 1) = trial.saccades.T_CW.number;
                                dataTemp.sacAmpSumTSAnti(countLt, 1) = trial.saccades.T_CW.sum;
                                dataTemp.sacAmpMeanTSAnti(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                            end
                        end
                        
                        %                         % just take the one that is not zero, if both
                        %                         % not zero, take the expected direction
                        %                         if torsion.slowPhases.totalAngleCW==0
                        %                             trialData.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                        %                         elseif torsion.slowPhases.totalAngleCCW==0
                        %                             trialData.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        %                         elseif trialData.afterReversalD(countLt, 1)*checkAngle==1
                        %                             trialData.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        %                         elseif trialData.afterReversalD(countLt, 1)*checkAngle==-1
                        %                             trialData.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                        %                         end
                        
                        %                     if checkAngle == -1 % the same as direction before reversal
                        %                         if trialData.afterReversalD(countLt, 1)==1 % direction after reversal is CW
                        %                             trialData.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                        %                         else
                        %                             trialData.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        %                         end
                        %                     elseif checkAngle == 1 % the same as direction after reversal
                        %                         if trialData.afterReversalD(countLt, 1)==1 % direction after reversal is CW
                        %                             trialData.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        %                         else
                        %                             trialData.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                        %                         end
                        %                     end
                        
                        %% saccade numbers
                        dataTemp.sacNumT(countLt, 1) = trial.saccades.T.number;
                        dataTemp.sacNumTCW(countLt, 1) = trial.saccades.T_CW.number;
                        dataTemp.sacNumTCCW(countLt, 1) = trial.saccades.T_CCW.number;
                        
                        %% saccade sum amplitudes
                        dataTemp.sacAmpSumT(countLt, 1) = trial.saccades.T.sum;
                        dataTemp.sacAmpSumTCW(countLt, 1) = trial.saccades.T_CW.sum;
                        dataTemp.sacAmpSumTCCW(countLt, 1) = trial.saccades.T_CCW.sum;
                        
                        %% saccade mean amplitudes
                        dataTemp.sacAmpMeanT(countLt, 1) = trial.saccades.T.meanAmplitude;
                        dataTemp.sacAmpMeanTCW(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                        dataTemp.sacAmpMeanTCCW(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
                        
                        countLt = countLt+1;
                    end
                end
            end
        end
        [dataTemp, trialDeletedP] = cleanData(dataTemp, 'perceptualError');
        [dataTemp, trialDeletedT] = cleanData(dataTemp, 'torsionVelT');
        trialDeleted(subj) = trialDeleted(subj) + trialDeletedP + trialDeletedT;
        trialData = [trialData; dataTemp];
    end
    
    %%
    for ii = 1:2 % two directions
        for eye = 1:size(eyeName, 2)
            for conI = 1:size(conditions, 2)
                % target motion as the reference direction
                conData.sub(countLc, 1) = subj;
                if strcmp(eyeName{eye}, 'L')
                    conData.eye(countLc, 1) = 1; % 1-left,
                elseif strcmp(eyeName{eye}, 'R')
                    conData.eye(countLc, 1) = 2; % 2-right
                end
                conData.rotationSpeed(countLc, 1) = conditions(conI);
                conData.afterReversalD(countLc, 1) = -direction(ii); % 1-clockwise, -1 counterclockwise, direction after reversal
                conData.sameSideAfterReversalD(countLc, 1) = -999;
                
                tempI = find(all(trialData{:, 1:4}==repmat(conData{countLc, 1:4}, [size(trialData, 1) 1]), 2));

                conData.perceptualErrorMean(countLc, 1) = nanmean(trialData.perceptualError(tempI, 1));
                conData.perceptualErrorStd(countLc, 1) = nanstd(trialData.perceptualError(tempI, 1));
                
                conData.torsionPosMean(countLc, 1) = nanmean(trialData.torsionPosition(tempI, 1));
                conData.torsionPosStd(countLc, 1) = nanstd(trialData.torsionPosition(tempI, 1));
                
                conData.torsionVelTMean(countLc, 1) = nanmean(trialData.torsionVelT(tempI, 1));
                conData.torsionVelTStd(countLc, 1) = nanstd(trialData.torsionVelT(tempI, 1));
                
                conData.torsionVelTGainMean(countLc, 1) = nanmean(trialData.torsionVGain(tempI, 1));
                conData.torsionVelTGainStd(countLc, 1) = nanstd(trialData.torsionVGain(tempI, 1));
                
                conData.torsionAngleTotalMean(countLc, 1) = nanmean(trialData.torsionAngleTotal(tempI, 1));
                conData.torsionAngleTotalStd(countLc, 1) = nanstd(trialData.torsionAngleTotal(tempI, 1));
                
                conData.torsionAngleCWMean(countLc, 1) = nanmean(trialData.torsionAngleCW(tempI, 1));
                conData.torsionAngleCWStd(countLc, 1) = nanstd(trialData.torsionAngleCW(tempI, 1));
                
                conData.torsionAngleCCWMean(countLc, 1) = nanmean(trialData.torsionAngleCCW(tempI, 1));
                conData.torsionAngleCCWStd(countLc, 1) = nanstd(trialData.torsionAngleCCW(tempI, 1));
                
                conData.torsionAngleTSameMean(countLc, 1) = nanmean(trialData.torsionAngleTSame(tempI, 1));
                conData.torsionAngleTSameStd(countLc, 1) = nanstd(trialData.torsionAngleTSame(tempI, 1));
                
                conData.torsionAngleTAntiMean(countLc, 1) = nanmean(trialData.torsionAngleTAnti(tempI, 1));
                conData.torsionAngleTAntiStd(countLc, 1) = nanstd(trialData.torsionAngleTAnti(tempI, 1));
                
                conData.torsionAngleSSameMean(countLc, 1) = -999;
                conData.torsionAngleSSameStd(countLc, 1) = -999;
                
                conData.torsionAngleSAntiMean(countLc, 1) = -999;
                conData.torsionAngleSAntiStd(countLc, 1) = -999;
                %
                %                 conData.torsionAngleMean(countLc, 1) = nanmean(trialData.torsionAngle(tempI, 1));
                %                 conData.torsionAngleStd(countLc, 1) = nanstd(trialData.torsionAngle(tempI, 1));
                
                conData.sacNumTMean(countLc, 1) = nanmean(trialData.sacNumT(tempI, 1));
                conData.sacNumTStd(countLc, 1) = nanstd(trialData.sacNumT(tempI, 1));
                
                conData.sacNumTCWMean(countLc, 1) = nanmean(trialData.sacNumTCW(tempI, 1));
                conData.sacNumTCWStd(countLc, 1) = nanstd(trialData.sacNumTCW(tempI, 1));
                
                conData.sacNumTCCWMean(countLc, 1) = nanmean(trialData.sacNumTCCW(tempI, 1));
                conData.sacNumTCCWStd(countLc, 1) = nanstd(trialData.sacNumTCCW(tempI, 1));
                
                conData.sacNumTTSameMean(countLc, 1) = nanmean(trialData.sacNumTTSame(tempI, 1));
                conData.sacNumTTSameStd(countLc, 1) = nanstd(trialData.sacNumTTSame(tempI, 1));
                
                conData.sacNumTTAntiMean(countLc, 1) = nanmean(trialData.sacNumTTAnti(tempI, 1));
                conData.sacNumTTAntiStd(countLc, 1) = nanstd(trialData.sacNumTTAnti(tempI, 1));
                
                conData.sacNumTSSameMean(countLc, 1) = -999;
                conData.sacNumTSSameStd(countLc, 1) = -999;
                
                conData.sacNumTSAntiMean(countLc, 1) = -999;
                conData.sacNumTSAntiStd(countLc, 1) = -999;
                
                conData.sacAmpSumTMean(countLc, 1) = nanmean(trialData.sacAmpSumT(tempI, 1));
                conData.sacAmpSumTStd(countLc, 1) = nanstd(trialData.sacAmpSumT(tempI, 1));
                
                conData.sacAmpSumTCWMean(countLc, 1) = nanmean(trialData.sacAmpSumTCW(tempI, 1));
                conData.sacAmpSumTCWStd(countLc, 1) = nanstd(trialData.sacAmpSumTCW(tempI, 1));
                
                conData.sacAmpSumTCCWMean(countLc, 1) = nanmean(trialData.sacAmpSumTCCW(tempI, 1));
                conData.sacAmpSumTCCWStd(countLc, 1) = nanstd(trialData.sacAmpSumTCCW(tempI, 1));
                
                conData.sacAmpSumTTSameMean(countLc, 1) = nanmean(trialData.sacAmpSumTTSame(tempI, 1));
                conData.sacAmpSumTTSameStd(countLc, 1) = nanstd(trialData.sacAmpSumTTSame(tempI, 1));
                
                conData.sacAmpSumTTAntiMean(countLc, 1) = nanmean(trialData.sacAmpSumTTAnti(tempI, 1));
                conData.sacAmpSumTTAntiStd(countLc, 1) = nanstd(trialData.sacAmpSumTTAnti(tempI, 1));
                
                conData.sacAmpSumTSSameMean(countLc, 1) = -999;
                conData.sacAmpSumTSSameStd(countLc, 1) = -999;
                
                conData.sacAmpSumTSAntiMean(countLc, 1) = -999;
                conData.sacAmpSumTSAntiStd(countLc, 1) = -999;
                
                conData.sacAmpMeanTMean(countLc, 1) = nanmean(trialData.sacAmpMeanT(tempI, 1));
                conData.sacAmpMeanTStd(countLc, 1) = nanstd(trialData.sacAmpMeanT(tempI, 1));
                
                conData.sacAmpMeanTCWMean(countLc, 1) = nanmean(trialData.sacAmpMeanTCW(tempI, 1));
                conData.sacAmpMeanTCWStd(countLc, 1) = nanstd(trialData.sacAmpMeanTCW(tempI, 1));
                
                conData.sacAmpMeanTCCWMean(countLc, 1) = nanmean(trialData.sacAmpMeanTCCW(tempI, 1));
                conData.sacAmpMeanTCCWStd(countLc, 1) = nanstd(trialData.sacAmpMeanTCCW(tempI, 1));
                
                conData.sacAmpMeanTTSameMean(countLc, 1) = nanmean(trialData.sacAmpMeanTTSame(tempI, 1));
                conData.sacAmpMeanTTSameStd(countLc, 1) = nanstd(trialData.sacAmpMeanTTSame(tempI, 1));
                
                conData.sacAmpMeanTTAntiMean(countLc, 1) = nanmean(trialData.sacAmpMeanTTAnti(tempI, 1));
                conData.sacAmpMeanTTAntiStd(countLc, 1) = nanstd(trialData.sacAmpMeanTTAnti(tempI, 1));
                
                conData.sacAmpMeanTSSameMean(countLc, 1) = -999;
                conData.sacAmpMeanTSSameStd(countLc, 1) = -999;
                
                conData.sacAmpMeanTSAntiMean(countLc, 1) = -999;
                conData.sacAmpMeanTSAntiStd(countLc, 1) = -999;
                
                conData.nonErrorTrialN(countLc, 1) = length(tempI);
                
                countLc = countLc+1;
                
                % same side stimulus motion as the direction reference
                conData.sub(countLc, 1) = subj;
                if strcmp(eyeName{eye}, 'L')
                    conData.eye(countLc, 1) = 1; % 1-left,
                elseif strcmp(eyeName{eye}, 'R')
                    conData.eye(countLc, 1) = 2; % 2-right
                end
                conData.rotationSpeed(countLc, 1) = conditions(conI);
                conData.afterReversalD(countLc, 1) = -999; % 1-clockwise, -1 counterclockwise, direction after reversal
                conData.sameSideAfterReversalD(countLc, 1) = -direction(ii); % 1-clockwise, -1 counterclockwise, direction after reversal
                
                tempI = find(all(trialData{:, 1:3}==repmat(conData{countLc, 1:3}, [size(trialData, 1) 1]), 2) & trialData.sameSideAfterReversalD==conData.sameSideAfterReversalD(countLc, 1));
                
                conData.perceptualErrorMean(countLc, 1) = nanmean(trialData.perceptualError(tempI, 1));
                conData.perceptualErrorStd(countLc, 1) = nanstd(trialData.perceptualError(tempI, 1));
                
                conData.torsionPosMean(countLc, 1) = nanmean(trialData.torsionPosition(tempI, 1));
                conData.torsionPosStd(countLc, 1) = nanstd(trialData.torsionPosition(tempI, 1));
                
                conData.torsionVelTMean(countLc, 1) = nanmean(trialData.torsionVelT(tempI, 1));
                conData.torsionVelTStd(countLc, 1) = nanstd(trialData.torsionVelT(tempI, 1));
                
                conData.torsionVelTGainMean(countLc, 1) = nanmean(trialData.torsionVGain(tempI, 1));
                conData.torsionVelTGainStd(countLc, 1) = nanstd(trialData.torsionVGain(tempI, 1));
                
                conData.torsionAngleTotalMean(countLc, 1) = nanmean(trialData.torsionAngleTotal(tempI, 1));
                conData.torsionAngleTotalStd(countLc, 1) = nanstd(trialData.torsionAngleTotal(tempI, 1));
                
                conData.torsionAngleCWMean(countLc, 1) = nanmean(trialData.torsionAngleCW(tempI, 1));
                conData.torsionAngleCWStd(countLc, 1) = nanstd(trialData.torsionAngleCW(tempI, 1));
                
                conData.torsionAngleCCWMean(countLc, 1) = nanmean(trialData.torsionAngleCCW(tempI, 1));
                conData.torsionAngleCCWStd(countLc, 1) = nanstd(trialData.torsionAngleCCW(tempI, 1));
                
                conData.torsionAngleTSameMean(countLc, 1) = -999;
                conData.torsionAngleTSameStd(countLc, 1) = -999;
                
                conData.torsionAngleTAntiMean(countLc, 1) = -999;
                conData.torsionAngleTAntiStd(countLc, 1) = -999;
                
                conData.torsionAngleSSameMean(countLc, 1) = nanmean(trialData.torsionAngleSSame(tempI, 1));
                conData.torsionAngleSSameStd(countLc, 1) = nanstd(trialData.torsionAngleSSame(tempI, 1));
                
                conData.torsionAngleSAntiMean(countLc, 1) = nanmean(trialData.torsionAngleSAnti(tempI, 1));
                conData.torsionAngleSAntiStd(countLc, 1) = nanstd(trialData.torsionAngleSAnti(tempI, 1));
                
                conData.sacNumTMean(countLc, 1) = nanmean(trialData.sacNumT(tempI, 1));
                conData.sacNumTStd(countLc, 1) = nanstd(trialData.sacNumT(tempI, 1));
                
                conData.sacNumTCWMean(countLc, 1) = nanmean(trialData.sacNumTCW(tempI, 1));
                conData.sacNumTCWStd(countLc, 1) = nanstd(trialData.sacNumTCW(tempI, 1));
                
                conData.sacNumTCCWMean(countLc, 1) = nanmean(trialData.sacNumTCCW(tempI, 1));
                conData.sacNumTCCWStd(countLc, 1) = nanstd(trialData.sacNumTCCW(tempI, 1));
                
                conData.sacNumTTSameMean(countLc, 1) = -999;
                conData.sacNumTTSameStd(countLc, 1) = -999;
                
                conData.sacNumTTAntiMean(countLc, 1) = -999;
                conData.sacNumTTAntiStd(countLc, 1) = -999;
                
                conData.sacNumTSSameMean(countLc, 1) = nanmean(trialData.sacNumTSSame(tempI, 1));
                conData.sacNumTSSameStd(countLc, 1) = nanstd(trialData.sacNumTSSame(tempI, 1));
                
                conData.sacNumTSAntiMean(countLc, 1) = nanmean(trialData.sacNumTSAnti(tempI, 1));
                conData.sacNumTSAntiStd(countLc, 1) = nanstd(trialData.sacNumTSAnti(tempI, 1));
                
                conData.sacAmpSumTMean(countLc, 1) = nanmean(trialData.sacAmpSumT(tempI, 1));
                conData.sacAmpSumTStd(countLc, 1) = nanstd(trialData.sacAmpSumT(tempI, 1));
                
                conData.sacAmpSumTCWMean(countLc, 1) = nanmean(trialData.sacAmpSumTCW(tempI, 1));
                conData.sacAmpSumTCWStd(countLc, 1) = nanstd(trialData.sacAmpSumTCW(tempI, 1));
                
                conData.sacAmpSumTCCWMean(countLc, 1) = nanmean(trialData.sacAmpSumTCCW(tempI, 1));
                conData.sacAmpSumTCCWStd(countLc, 1) = nanstd(trialData.sacAmpSumTCCW(tempI, 1));
                
                conData.sacAmpSumTTSameMean(countLc, 1) = -999;
                conData.sacAmpSumTTSameStd(countLc, 1) = -999;
                
                conData.sacAmpSumTTAntiMean(countLc, 1) = -999;
                conData.sacAmpSumTTAntiStd(countLc, 1) = -999;
                
                conData.sacAmpSumTSSameMean(countLc, 1) = nanmean(trialData.sacAmpSumTSSame(tempI, 1));
                conData.sacAmpSumTSSameStd(countLc, 1) = nanstd(trialData.sacAmpSumTSSame(tempI, 1));
                
                conData.sacAmpSumTSAntiMean(countLc, 1) = nanmean(trialData.sacAmpSumTSAnti(tempI, 1));
                conData.sacAmpSumTSAntiStd(countLc, 1) = nanstd(trialData.sacAmpSumTSAnti(tempI, 1));
                
                conData.sacAmpMeanTMean(countLc, 1) = nanmean(trialData.sacAmpMeanT(tempI, 1));
                conData.sacAmpMeanTStd(countLc, 1) = nanstd(trialData.sacAmpMeanT(tempI, 1));
                
                conData.sacAmpMeanTCWMean(countLc, 1) = nanmean(trialData.sacAmpMeanTCW(tempI, 1));
                conData.sacAmpMeanTCWStd(countLc, 1) = nanstd(trialData.sacAmpMeanTCW(tempI, 1));
                
                conData.sacAmpMeanTCCWMean(countLc, 1) = nanmean(trialData.sacAmpMeanTCCW(tempI, 1));
                conData.sacAmpMeanTCCWStd(countLc, 1) = nanstd(trialData.sacAmpMeanTCCW(tempI, 1));
                
                conData.sacAmpMeanTTSameMean(countLc, 1) = -999;
                conData.sacAmpMeanTTSameStd(countLc, 1) = -999;
                
                conData.sacAmpMeanTTAntiMean(countLc, 1) = -999;
                conData.sacAmpMeanTTAntiStd(countLc, 1) = -999;
                
                conData.sacAmpMeanTSSameMean(countLc, 1) = nanmean(trialData.sacAmpMeanTSSame(tempI, 1));
                conData.sacAmpMeanTSSameStd(countLc, 1) = nanstd(trialData.sacAmpMeanTSSame(tempI, 1));
                
                conData.sacAmpMeanTSAntiMean(countLc, 1) = nanmean(trialData.sacAmpMeanTSAnti(tempI, 1));
                conData.sacAmpMeanTSAntiStd(countLc, 1) = nanstd(trialData.sacAmpMeanTSAnti(tempI, 1));
                
                conData.nonErrorTrialN(countLc, 1) = length(tempI);
                
                countLc = countLc+1;
            end
        end
    end
    
end

cd([analysisF '\analysis functions'])
% merge directions, mark as 0
trialData.torsionVelTMerged = trialData.torsionVelT.*trialData.afterReversalD;
trialData.torsionVGainMerged = trialData.torsionVGain.*trialData.afterReversalD;
trialData.torsionPositionMerged = trialData.torsionPosition.*trialData.afterReversalD;

% target as a reference
tempI = find(trialData.afterReversalD==-1);
trialData.torsionAngleTSameMerged(tempI, 1) = -trialData.torsionAngleCCW(tempI, 1);
trialData.torsionAngleTAntiMerged(tempI, 1) = -trialData.torsionAngleCW(tempI, 1);

% same side stimulus as a reference
tempI = find(trialData.sameSideAfterReversalD==-1);
trialData.torsionAngleSSameMerged(tempI, 1) = -trialData.torsionAngleCCW(tempI, 1);
trialData.torsionAngleSAntiMerged(tempI, 1) = -trialData.torsionAngleCW(tempI, 1);

countLc = size(conData, 1)+1;
for subj=1:size(names, 2)
    %     if subj <=2
    %         conditions = conditions0;
    %     elseif subj<=3
    %         conditions = conditions1;
    %     elseif subj<=5
    %         conditions = conditions2;
    %     else
    %         conditions = conditions3;
    %     end
    for eye = 1:size(eyeName, 2)
        for ii = 1:size(conditions, 2)
            % target reference
            conData.sub(countLc, 1) = subj;
            if strcmp(eyeName{eye}, 'L')
                conData.eye(countLc, 1) = 1; % 1-left,
            elseif strcmp(eyeName{eye}, 'R')
                conData.eye(countLc, 1) = 2; % 2-right
            end
            conData.rotationSpeed(countLc, 1) = conditions(ii);
            conData.afterReversalD(countLc, 1) = 0; % direction after reversal merged
            conData.sameSideAfterReversalD(countLc, 1) = -999;
            
            tempI = find(all(trialData{:, 1:3}==repmat(conData{countLc, 1:3}, [size(trialData, 1) 1]), 2));
            
            conData.perceptualErrorMean(countLc, 1) = nanmean(trialData.perceptualError(tempI, 1));
            conData.perceptualErrorStd(countLc, 1) = nanstd(trialData.perceptualError(tempI, 1));
            
            conData.torsionPosMean(countLc, 1) = nanmean(trialData.torsionPositionMerged(tempI, 1));
            conData.torsionPosStd(countLc, 1) = nanstd(trialData.torsionPositionMerged(tempI, 1));
            
            conData.torsionVelTMean(countLc, 1) = nanmean(trialData.torsionVelTMerged(tempI, 1));
            conData.torsionVelTStd(countLc, 1) = nanstd(trialData.torsionVelTMerged(tempI, 1));
            
            conData.torsionVelTGainMean(countLc, 1) = nanmean(trialData.torsionVGainMerged(tempI, 1));
            conData.torsionVelTGainStd(countLc, 1) = nanstd(trialData.torsionVGainMerged(tempI, 1));
            
            conData.torsionAngleTotalMean(countLc, 1) = nanmean(trialData.torsionAngleTotal(tempI, 1));
            conData.torsionAngleTotalStd(countLc, 1) = nanstd(trialData.torsionAngleTotal(tempI, 1));
            
            conData.torsionAngleCWMean(countLc, 1) = nanmean(trialData.torsionAngleCW(tempI, 1));
            conData.torsionAngleCWStd(countLc, 1) = nanstd(trialData.torsionAngleCW(tempI, 1));
            
            conData.torsionAngleCCWMean(countLc, 1) = nanmean(trialData.torsionAngleCCW(tempI, 1));
            conData.torsionAngleCCWStd(countLc, 1) = nanstd(trialData.torsionAngleCCW(tempI, 1));
            
            conData.torsionAngleTSameMean(countLc, 1) = nanmean(trialData.torsionAngleTSameMerged(tempI, 1));
            conData.torsionAngleTSameStd(countLc, 1) = nanstd(trialData.torsionAngleTSameMerged(tempI, 1));
            
            conData.torsionAngleTAntiMean(countLc, 1) = nanmean(trialData.torsionAngleTAntiMerged(tempI, 1));
            conData.torsionAngleTAntiStd(countLc, 1) = nanstd(trialData.torsionAngleTAntiMerged(tempI, 1));
            
            conData.torsionAngleSSameMean(countLc, 1) = -999;
            conData.torsionAngleSSameStd(countLc, 1) = -999;
            
            conData.torsionAngleSAntiMean(countLc, 1) = -999;
            conData.torsionAngleSAntiStd(countLc, 1) = -999;
            
            %             conData.torsionAngleMean(countLc, 1) = nanmean(trialData.torsionAngleMerged(tempI, 1));
            %             conData.torsionAngleStd(countLc, 1) = nanstd(trialData.torsionAngleMerged(tempI, 1));
            
            conData.sacNumTMean(countLc, 1) = nanmean(trialData.sacNumT(tempI, 1));
            conData.sacNumTStd(countLc, 1) = nanstd(trialData.sacNumT(tempI, 1));
            
            conData.sacNumTCWMean(countLc, 1) = nanmean(trialData.sacNumTCW(tempI, 1));
            conData.sacNumTCWStd(countLc, 1) = nanstd(trialData.sacNumTCW(tempI, 1));
            
            conData.sacNumTCCWMean(countLc, 1) = nanmean(trialData.sacNumTCCW(tempI, 1));
            conData.sacNumTCCWStd(countLc, 1) = nanstd(trialData.sacNumTCCW(tempI, 1));
            
            conData.sacNumTTSameMean(countLc, 1) = nanmean(trialData.sacNumTTSame(tempI, 1));
            conData.sacNumTTSameStd(countLc, 1) = nanstd(trialData.sacNumTTSame(tempI, 1));
            
            conData.sacNumTTAntiMean(countLc, 1) = nanmean(trialData.sacNumTTAnti(tempI, 1));
            conData.sacNumTTAntiStd(countLc, 1) = nanstd(trialData.sacNumTTAnti(tempI, 1));
            
            conData.sacNumTSSameMean(countLc, 1) = -999;
            conData.sacNumTSSameStd(countLc, 1) = -999;
            
            conData.sacNumTSAntiMean(countLc, 1) = -999;
            conData.sacNumTSAntiStd(countLc, 1) = -999;
            
            conData.sacAmpSumTMean(countLc, 1) = nanmean(trialData.sacAmpSumT(tempI, 1));
            conData.sacAmpSumTStd(countLc, 1) = nanstd(trialData.sacAmpSumT(tempI, 1));
            
            conData.sacAmpSumTCWMean(countLc, 1) = nanmean(trialData.sacAmpSumTCW(tempI, 1));
            conData.sacAmpSumTCWStd(countLc, 1) = nanstd(trialData.sacAmpSumTCW(tempI, 1));
            
            conData.sacAmpSumTCCWMean(countLc, 1) = nanmean(trialData.sacAmpSumTCCW(tempI, 1));
            conData.sacAmpSumTCCWStd(countLc, 1) = nanstd(trialData.sacAmpSumTCCW(tempI, 1));
            
            conData.sacAmpSumTTSameMean(countLc, 1) = nanmean(trialData.sacAmpSumTTSame(tempI, 1));
            conData.sacAmpSumTTSameStd(countLc, 1) = nanstd(trialData.sacAmpSumTTSame(tempI, 1));
            
            conData.sacAmpSumTTAntiMean(countLc, 1) = nanmean(trialData.sacAmpSumTTAnti(tempI, 1));
            conData.sacAmpSumTTAntiStd(countLc, 1) = nanstd(trialData.sacAmpSumTTAnti(tempI, 1));
            
            conData.sacAmpSumTSSameMean(countLc, 1) = -999;
            conData.sacAmpSumTSSameStd(countLc, 1) = -999;
            
            conData.sacAmpSumTSAntiMean(countLc, 1) = -999;
            conData.sacAmpSumTSAntiStd(countLc, 1) = -999;
            
            conData.sacAmpMeanTMean(countLc, 1) = nanmean(trialData.sacAmpMeanT(tempI, 1));
            conData.sacAmpMeanTStd(countLc, 1) = nanstd(trialData.sacAmpMeanT(tempI, 1));
            
            conData.sacAmpMeanTCWMean(countLc, 1) = nanmean(trialData.sacAmpMeanTCW(tempI, 1));
            conData.sacAmpMeanTCWStd(countLc, 1) = nanstd(trialData.sacAmpMeanTCW(tempI, 1));
            
            conData.sacAmpMeanTCCWMean(countLc, 1) = nanmean(trialData.sacAmpMeanTCCW(tempI, 1));
            conData.sacAmpMeanTCCWStd(countLc, 1) = nanstd(trialData.sacAmpMeanTCCW(tempI, 1));
            
            conData.sacAmpMeanTTSameMean(countLc, 1) = nanmean(trialData.sacAmpMeanTTSame(tempI, 1));
            conData.sacAmpMeanTTSameStd(countLc, 1) = nanstd(trialData.sacAmpMeanTTSame(tempI, 1));
            
            conData.sacAmpMeanTTAntiMean(countLc, 1) = nanmean(trialData.sacAmpMeanTTAnti(tempI, 1));
            conData.sacAmpMeanTTAntiStd(countLc, 1) = nanstd(trialData.sacAmpMeanTTAnti(tempI, 1));
            
            conData.sacAmpMeanTSSameMean(countLc, 1) = -999;
            conData.sacAmpMeanTSSameStd(countLc, 1) = -999;
            
            conData.sacAmpMeanTSAntiMean(countLc, 1) = -999;
            conData.sacAmpMeanTSAntiStd(countLc, 1) = -999;
            
            conData.nonErrorTrialN(countLc, 1) = length(tempI);
            
            countLc = countLc+1;
            
            
            % same side stimulus reference
            conData.sub(countLc, 1) = subj;
            if strcmp(eyeName{eye}, 'L')
                conData.eye(countLc, 1) = 1; % 1-left,
            elseif strcmp(eyeName{eye}, 'R')
                conData.eye(countLc, 1) = 2; % 2-right
            end
            conData.rotationSpeed(countLc, 1) = conditions(ii);
            conData.afterReversalD(countLc, 1) = -999; % direction after reversal merged
            conData.sameSideAfterReversalD(countLc, 1) = 0;
            
            tempI = find(all(trialData{:, 1:3}==repmat(conData{countLc, 1:3}, [size(trialData, 1) 1]), 2));
            
            conData.perceptualErrorMean(countLc, 1) = nanmean(trialData.perceptualError(tempI, 1));
            conData.perceptualErrorStd(countLc, 1) = nanstd(trialData.perceptualError(tempI, 1));
            
            conData.torsionPosMean(countLc, 1) = nanmean(trialData.torsionPositionMerged(tempI, 1));
            conData.torsionPosStd(countLc, 1) = nanstd(trialData.torsionPositionMerged(tempI, 1));
            
            conData.torsionVelTMean(countLc, 1) = nanmean(trialData.torsionVelTMerged(tempI, 1));
            conData.torsionVelTStd(countLc, 1) = nanstd(trialData.torsionVelTMerged(tempI, 1));
            
            conData.torsionVelTGainMean(countLc, 1) = nanmean(trialData.torsionVGainMerged(tempI, 1));
            conData.torsionVelTGainStd(countLc, 1) = nanstd(trialData.torsionVGainMerged(tempI, 1));
            
            conData.torsionAngleTotalMean(countLc, 1) = nanmean(trialData.torsionAngleTotal(tempI, 1));
            conData.torsionAngleTotalStd(countLc, 1) = nanstd(trialData.torsionAngleTotal(tempI, 1));
            
            conData.torsionAngleCWMean(countLc, 1) = nanmean(trialData.torsionAngleCW(tempI, 1));
            conData.torsionAngleCWStd(countLc, 1) = nanstd(trialData.torsionAngleCW(tempI, 1));
            
            conData.torsionAngleCCWMean(countLc, 1) = nanmean(trialData.torsionAngleCCW(tempI, 1));
            conData.torsionAngleCCWStd(countLc, 1) = nanstd(trialData.torsionAngleCCW(tempI, 1));
            
            conData.torsionAngleTSameMean(countLc, 1) = -999;
            conData.torsionAngleTSameStd(countLc, 1) = -999;
            
            conData.torsionAngleTAntiMean(countLc, 1) = -999;
            conData.torsionAngleTAntiStd(countLc, 1) = -999;
            
            conData.torsionAngleSSameMean(countLc, 1) = nanmean(trialData.torsionAngleSSameMerged(tempI, 1));
            conData.torsionAngleSSameStd(countLc, 1) = nanstd(trialData.torsionAngleSSameMerged(tempI, 1));
            
            conData.torsionAngleSAntiMean(countLc, 1) = nanmean(trialData.torsionAngleSAntiMerged(tempI, 1));
            conData.torsionAngleSAntiStd(countLc, 1) = nanstd(trialData.torsionAngleSAntiMerged(tempI, 1));
            
            %             conData.torsionAngleMean(countLc, 1) = nanmean(trialData.torsionAngleMerged(tempI, 1));
            %             conData.torsionAngleStd(countLc, 1) = nanstd(trialData.torsionAngleMerged(tempI, 1));
            
            conData.sacNumTMean(countLc, 1) = nanmean(trialData.sacNumT(tempI, 1));
            conData.sacNumTStd(countLc, 1) = nanstd(trialData.sacNumT(tempI, 1));
            
            conData.sacNumTCWMean(countLc, 1) = nanmean(trialData.sacNumTCW(tempI, 1));
            conData.sacNumTCWStd(countLc, 1) = nanstd(trialData.sacNumTCW(tempI, 1));
            
            conData.sacNumTCCWMean(countLc, 1) = nanmean(trialData.sacNumTCCW(tempI, 1));
            conData.sacNumTCCWStd(countLc, 1) = nanstd(trialData.sacNumTCCW(tempI, 1));
            
            conData.sacNumTTSameMean(countLc, 1) = -999;
            conData.sacNumTTSameStd(countLc, 1) = -999;
            
            conData.sacNumTTAntiMean(countLc, 1) = -999;
            conData.sacNumTTAntiStd(countLc, 1) = -999;
            
            conData.sacNumTSSameMean(countLc, 1) = nanmean(trialData.sacNumTSSame(tempI, 1));
            conData.sacNumTSSameStd(countLc, 1) = nanstd(trialData.sacNumTSSame(tempI, 1));
            
            conData.sacNumTSAntiMean(countLc, 1) = nanmean(trialData.sacNumTSAnti(tempI, 1));
            conData.sacNumTSAntiStd(countLc, 1) = nanstd(trialData.sacNumTSAnti(tempI, 1));
            
            conData.sacAmpSumTMean(countLc, 1) = nanmean(trialData.sacAmpSumT(tempI, 1));
            conData.sacAmpSumTStd(countLc, 1) = nanstd(trialData.sacAmpSumT(tempI, 1));
            
            conData.sacAmpSumTCWMean(countLc, 1) = nanmean(trialData.sacAmpSumTCW(tempI, 1));
            conData.sacAmpSumTCWStd(countLc, 1) = nanstd(trialData.sacAmpSumTCW(tempI, 1));
            
            conData.sacAmpSumTCCWMean(countLc, 1) = nanmean(trialData.sacAmpSumTCCW(tempI, 1));
            conData.sacAmpSumTCCWStd(countLc, 1) = nanstd(trialData.sacAmpSumTCCW(tempI, 1));
            
            conData.sacAmpSumTTSameMean(countLc, 1) = -999;
            conData.sacAmpSumTTSameStd(countLc, 1) = -999;
            
            conData.sacAmpSumTTAntiMean(countLc, 1) = -999;
            conData.sacAmpSumTTAntiStd(countLc, 1) = -999;
            
            conData.sacAmpSumTSSameMean(countLc, 1) = nanmean(trialData.sacAmpSumTSSame(tempI, 1));
            conData.sacAmpSumTSSameStd(countLc, 1) = nanstd(trialData.sacAmpSumTSSame(tempI, 1));
            
            conData.sacAmpSumTSAntiMean(countLc, 1) = nanmean(trialData.sacAmpSumTSAnti(tempI, 1));
            conData.sacAmpSumTSAntiStd(countLc, 1) = nanstd(trialData.sacAmpSumTSAnti(tempI, 1));
            
            conData.sacAmpMeanTMean(countLc, 1) = nanmean(trialData.sacAmpMeanT(tempI, 1));
            conData.sacAmpMeanTStd(countLc, 1) = nanstd(trialData.sacAmpMeanT(tempI, 1));
            
            conData.sacAmpMeanTCWMean(countLc, 1) = nanmean(trialData.sacAmpMeanTCW(tempI, 1));
            conData.sacAmpMeanTCWStd(countLc, 1) = nanstd(trialData.sacAmpMeanTCW(tempI, 1));
            
            conData.sacAmpMeanTCCWMean(countLc, 1) = nanmean(trialData.sacAmpMeanTCCW(tempI, 1));
            conData.sacAmpMeanTCCWStd(countLc, 1) = nanstd(trialData.sacAmpMeanTCCW(tempI, 1));
            
            conData.sacAmpMeanTTSameMean(countLc, 1) = -999;
            conData.sacAmpMeanTTSameStd(countLc, 1) = -999;
            
            conData.sacAmpMeanTTAntiMean(countLc, 1) = -999;
            conData.sacAmpMeanTTAntiStd(countLc, 1) = -999;
            
            conData.sacAmpMeanTSSameMean(countLc, 1) = nanmean(trialData.sacAmpMeanTSSame(tempI, 1));
            conData.sacAmpMeanTSSameStd(countLc, 1) = nanstd(trialData.sacAmpMeanTSSame(tempI, 1));
            
            conData.sacAmpMeanTSAntiMean(countLc, 1) = nanmean(trialData.sacAmpMeanTSAnti(tempI, 1));
            conData.sacAmpMeanTSAntiStd(countLc, 1) = nanstd(trialData.sacAmpMeanTSAnti(tempI, 1));
            
            conData.nonErrorTrialN(countLc, 1) = length(tempI);
            
            countLc = countLc+1;
        end
    end
end
%
% % normalization
% for ii = 1:size(conData, 1)
%     if conData.afterReversalD(ii, 1)==0
%         arr = find(all(trialData{:, 1:3}==repmat(conData{ii, 1:3}, [size(trialData, 1) 1]), 2));
%         trialData.perceptualErrMergedNorm(arr, 1) = (trialData.perceptualError(arr, 1)-conData.perceptualErrorMean(ii, 1))./conData.perceptualErrorStd(ii, 1);
%         trialData.torsionVelTMergedNorm(arr, 1) = (trialData.torsionVelTMerged(arr, 1)-conData.torsionVelTMean(ii, 1))./conData.torsionVelTStd(ii, 1);
%     else
%         arr = find(all(trialData{:, 1:4}==repmat(conData{ii, 1:4}, [size(trialData, 1) 1]), 2));
%         trialData.perceptualErrNorm(arr, 1) = (trialData.perceptualError(arr, 1)-conData.perceptualErrorMean(ii, 1))./conData.perceptualErrorStd(ii, 1);
%         trialData.torsionVelTNorm(arr, 1) = (trialData.torsionVelT(arr, 1)-conData.torsionVelTMean(ii, 1))./conData.torsionVelTStd(ii, 1);
%     end
% end

save(['dataLong', endName, '.mat'], 'trialData', 'conData', 'trialDeleted');