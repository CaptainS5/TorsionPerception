% Xiuyun Wu, 10/23/2018
% direction, initial angle1, reversal angle1, all are target
% properties--needs to check the target side to see which side the
% stimulus is
clear all; close all; clc

global trial

names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol' 'FScontrol' 'XWcontrol' 'SCcontrol' 'JFcontrol'};
conditions = [25 50 100 200];
load('meanLatencyExp1')
cd ..
analysisF = pwd;
folder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1stYear\TorsionPerception\data'};
direction = [-1 1]; % initial direction; in the plot shows the direction after reversal
trialPerCon = 72; % for each rotation speed, all directions together though...
torsionThreshold = 8*ones(size(names));
torsionFrames = 3*ones(size(names));
eyeName = {'L' 'R'};
endNames = {'BeforeReversal' 'AfterReversal'};

cd ..
load(['dataBase_all', num2str(size(names, 2)), '.mat'])

for endN = 1:2
    endName = endNames{endN};
    trialData = table(); % organize into long format
    trialDeleted = zeros(1, length(names));
    for subj = 1:length(names)
        cd(analysisF)
        % Subject details
        subject = names{subj};
        counts = {zeros(size(conditions)) zeros(size(conditions))};
        
        countLt = 1;
        dataTemp = table();
        for block = 1:6
            errorsL = load(['Errorfiles\Exp' num2str(block) '_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_L_errorFile.mat']);
            errorsR = load(['Errorfiles\Exp' num2str(block) '_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_R_errorFile.mat']);
            
            % load response data for trial information
            dataFile = dir([folder{:} '\' subject '\response' num2str(block) '_*.mat']);
            load([folder{:} '\' subject '\' dataFile.name]) % resp is the response data for the current block
            
            for t = 1:size(resp, 1) % trial number
                if errorsL.errorStatus(t)==0 || errorsR.errorStatus(t)==0
                    if countLt>1
                        dataTemp{countLt, :} = NaN;
                    end
                    dataTemp.sub(countLt, 1) = subj;
                    
                    dirIdx = find(direction==resp.initialDirection(t)); % 1-clockwise, 2-counterclockwise
                    conIdx = find(conditions==resp.rotationSpeed(t));
                    
                    dataTemp.rotationSpeed(countLt, 1) = resp.rotationSpeed(t);
                    dataTemp.afterReversalD(countLt, 1) = -direction(dirIdx); % 1-clockwise, -1 counterclockwise
                    dataTemp.targetSide(countLt, 1) = resp.targetSide(t);
                    
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
%                     if dataTemp.perceptualError(countLt, 1)>-10
                        currentTrial = t;
                        if errorsL.errorStatus(t)==0 % valid trial
                            eye = 1;
                            % read in data and socscalexy
                            filename = ['session_' num2str(block,'%.2i') '_' eyeName{eye} '.dat'];
                            data = readDataFile(filename, [folder{:} '\' subject '\chronos']);
                            data = socscalexy(data);
                            [header, logData] = readLogFile(block, ['response' num2str(block,'%.2i') '_' subject] , [folder{:} '\' subject]);
                            sampleRate = 200;
                            
                            % get mean velocities
                            % setup trial
                            trial = setupTrial(data, header, logData, currentTrial);
                            trial.torsionFrames = torsionFrames(subj);
                            
                            %% choose the time window here
                            tempLatency = meanLatency(conIdx);
                            tempLatencyB = meanLatencyB(conIdx);
                            if strcmp(endName, 'AtReversal') % at reversal
                                trial.stim_onset = trial.stim_reversalOnset; % reversal
                                trial.stim_offset = trial.stim_reversalOffset + ms2frames(tempLatency*1000); % reversal
                            elseif strcmp(endName, 'BeforeReversal')
                                trial.stim_onset = ms2frames((logData.fixationDuration(currentTrial)+tempLatencyB)*1000); % 120ms latency
                                trial.stim_offset = trial.stim_reversalOnset; % reversal
                            elseif strcmp(endName, 'AfterReversal') 
                                trial.stim_onset = trial.stim_reversalOffset + ms2frames(tempLatency*1000);
                                trial.stim_offset = trial.stim_reversalOffset + ms2frames(logData.durationAfter(currentTrial)*1000); % end of display
                            end
                            
                            find saccades;
                            [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                            [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                            [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subj), 0);
                            
                            % analyze saccades
                            [trial] = analyzeSaccades(trial, saccades);
                            clear saccades;
                            
                            % remove saccades
                            trial = removeSaccades(trial);
                            
                            %% analyze torsion
                            pursuit.onset = trial.stim_onset; % the frame to start torsion analysis
                            [torsion, trial] = analyzeTorsion(trial, pursuit);
                            % end of analyzeTrial
                            
                            startFrame = trial.stim_onset;
                            endFrame = trial.stim_offset;
                            
%                             if abs(torsion.slowPhases.meanSpeed)<30
                                
                                %% retinal torsion angle
                                dataTemp.LtorsionPosition(countLt, 1) = nanmean(torsion.slowPhases.onsetPosition);
                                
                                %% torsion velocity
                                dataTemp.LtorsionVelT(countLt, 1) = torsion.slowPhases.meanSpeed;
                                
                                %% torsion magnitude
                                dataTemp.LtorsionAngleTotal(countLt, 1) = torsion.slowPhases.totalAngle;
                                dataTemp.LtorsionAngleCW(countLt, 1) = torsion.slowPhases.totalAngleCW;
                                dataTemp.LtorsionAngleCCW(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                                
                                %% saccade numbers
                                dataTemp.LsacNumT(countLt, 1) = trial.saccades.T.number;
                                dataTemp.LsacNumTCW(countLt, 1) = trial.saccades.T_CW.number;
                                dataTemp.LsacNumTCCW(countLt, 1) = trial.saccades.T_CCW.number;
                                
                                %% saccade sum amplitudes
                                dataTemp.LsacAmpSumT(countLt, 1) = trial.saccades.T.sum;
                                dataTemp.LsacAmpSumTCW(countLt, 1) = trial.saccades.T_CW.sum;
                                dataTemp.LsacAmpSumTCCW(countLt, 1) = trial.saccades.T_CCW.sum;
                                
                                %% saccade mean amplitudes
                                dataTemp.LsacAmpMeanT(countLt, 1) = trial.saccades.T.meanAmplitude;
                                dataTemp.LsacAmpMeanTCW(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                                dataTemp.LsacAmpMeanTCCW(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
%                             end
                        end
                        if errorsR.errorStatus(t)==0 % valid trial
                            eye = 2;
                            % read in data and socscalexy
                            filename = ['session_' num2str(block,'%.2i') '_' eyeName{eye} '.dat'];
                            data = readDataFile(filename, [folder{:} '\' subject '\chronos']);
                            data = socscalexy(data);
                            [header, logData] = readLogFile(block, ['response' num2str(block,'%.2i') '_' subject] , [folder{:} '\' subject]);
                            sampleRate = 200;
                            
                            % get mean velocities
                            % setup trial
                            trial = setupTrial(data, header, logData, currentTrial);
                            trial.torsionFrames = torsionFrames(subj);
                            
                            %% choose the time window here
                            tempLatency = meanLatency(conIdx);
                            if strcmp(endName, 'AtReversal') % at reversal
                                trial.stim_onset = trial.stim_reversalOnset; % reversal
                                trial.stim_offset = trial.stim_reversalOnset + ms2frames(tempLatency*1000); % reversal
                            elseif strcmp(endName, 'BeforeReversal')
                                trial.stim_onset = ms2frames((logData.fixationDuration(currentTrial)+tempLatency)*1000); % 120ms latency
                                trial.stim_offset = trial.stim_reversalOnset; % reversal
                            elseif strcmp(endName, 'AfterReversal') 
                                trial.stim_onset = trial.stim_reversalOnset + ms2frames(tempLatency*1000);
                                trial.stim_offset = trial.stim_reversalOffset + ms2frames(logData.durationAfter(currentTrial)*1000); % end of display
                            end
                            
                            find saccades;
                            [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                            [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                            [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subj), 0);
                            
                            % analyze saccades
                            [trial] = analyzeSaccades(trial, saccades);
                            clear saccades;
                            
                            % remove saccades
                            trial = removeSaccades(trial);
                            
                            %% analyze torsion
                            pursuit.onset = trial.stim_onset; % the frame to start torsion analysis
                            [torsion, trial] = analyzeTorsion(trial, pursuit);
                            % end of analyzeTrial
                            
                            startFrame = trial.stim_onset;
                            endFrame = trial.stim_offset;
                            
%                             if abs(torsion.slowPhases.meanSpeed)<20
                                
                                %% retinal torsion angle
                                dataTemp.RtorsionPosition(countLt, 1) = nanmean(torsion.slowPhases.onsetPosition);
                                
                                %% torsion velocity
                                dataTemp.RtorsionVelT(countLt, 1) = torsion.slowPhases.meanSpeed;
                                
                                %% torsion magnitude
                                dataTemp.RtorsionAngleTotal(countLt, 1) = torsion.slowPhases.totalAngle;
                                dataTemp.RtorsionAngleCW(countLt, 1) = torsion.slowPhases.totalAngleCW;
                                dataTemp.RtorsionAngleCCW(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                                
                                %% saccade numbers
                                dataTemp.RsacNumT(countLt, 1) = trial.saccades.T.number;
                                dataTemp.RsacNumTCW(countLt, 1) = trial.saccades.T_CW.number;
                                dataTemp.RsacNumTCCW(countLt, 1) = trial.saccades.T_CCW.number;
                                
                                %% saccade sum amplitudes
                                dataTemp.RsacAmpSumT(countLt, 1) = trial.saccades.T.sum;
                                dataTemp.RsacAmpSumTCW(countLt, 1) = trial.saccades.T_CW.sum;
                                dataTemp.RsacAmpSumTCCW(countLt, 1) = trial.saccades.T_CCW.sum;
                                
                                %% saccade mean amplitudes
                                dataTemp.RsacAmpMeanT(countLt, 1) = trial.saccades.T.meanAmplitude;
                                dataTemp.RsacAmpMeanTCW(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                                dataTemp.RsacAmpMeanTCCW(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
%                             end
                        end
                        countLt = countLt+1;
%                     end
                end
            end
        end
%         [dataTempP, trialDeletedP, idxP] = cleanData(dataTemp, 'perceptualError');
%         [dataTempL, trialDeletedTL, idxL] = cleanData(dataTemp, 'LtorsionVelT');
%         [dataTempR, trialDeletedTR, idxR] = cleanData(dataTemp, 'RtorsionVelT');
%         idxD = unique([idxP; idxL; idxR]);
%         dataTemp(idxD, :) = [];
%         trialDeleted(subj) = length(idxD);
        trialData = [trialData; dataTemp];
    end
    cd([analysisF '\analysis functions'])
    save(['dataLong', endName, '.mat'], 'trialData'); %, 'trialDeleted');
end