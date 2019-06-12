function [pursuit] = analyzePursuit(trial, pursuit)

openLoopDuration = ms2frames(140);
closedLoop = pursuit.onset+ms2frames(200):trial.stim_offset-ms2frames(200); %dummy value. need to talk about that.

startFrame = pursuit.onset;
% if there is a saccade in the first x milliseconds, all pursuit values are
% NaN, else calculate open-loop values
if trial.saccades.firstSaccadeOnset - (pursuit.onset - trial.stim_onset) < ms2frames(70)
   
    pursuit.onsetOnSaccade = 1;
    pursuit.onset = trial.saccades.firstSaccadeOffset + trial.stim_onset;
    pursuit.initialMeanVelocity = NaN;
    pursuit.initialPeakVelocity = NaN;
    pursuit.initialMeanAcceleration = NaN;
    
else
    %% open-loop phase
    pursuit.onsetOnSaccade = 0;
    endFrame = min([(pursuit.onset+openLoopDuration) trial.saccades.firstSaccadeOnset]);
    
    pursuit.initialMeanVelocity = nanmean(abs(trial.frames.DX_noSac(startFrame:endFrame)));
    pursuit.initialPeakVelocity = max(abs(trial.frames.DX_noSac(startFrame:endFrame)));
    pursuit.initialMeanAcceleration = nanmean(abs(trial.frames.DDX_filt(startFrame:endFrame))); %no need to remove saccades, since open-loop phase stops at first saccade anyway
    
    
end



%% complete trial

endFrame = trial.stim_offset-ms2frames(200);

pursuit.gain = nanmean(abs(trial.frames.DX_noSac(closedLoop)))/10;

% calculate position error
horizontalError = trial.frames.S(startFrame:endFrame)-trial.frames.X_noSac(startFrame:endFrame);
verticalError = 0-trial.frames.Y_noSac(startFrame:endFrame);
pursuit.positionError = nanmean(sqrt((horizontalError.^2 + verticalError.^2)));


% calculate velocity error
horizontalError = trial.frames.DS(startFrame:endFrame)-trial.frames.DX_noSac(startFrame:endFrame);
verticalError = 0-trial.frames.DY_noSac(startFrame:endFrame);
pursuit.velocityError = nanmean(sqrt((horizontalError.^2 + verticalError.^2)));

end