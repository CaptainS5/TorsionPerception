function [results] = saveSaccades(results, trial)


%% save every single quickphase

for i = 1:length(trial.saccades.X.onsets)
    currentOnset = trial.saccades.X.onsets(i);
    currentOffset = trial.saccades.X.offsets(i);
    entry = writeSaccadeEntry(0, currentOnset, currentOffset, trial);
    currentResults(1,~cellfun(@isempty,entry)) = [entry{~cellfun(@isempty,entry)}];
    currentResults(1,cellfun(@isempty,entry)) = NaN;
    results.saccades = [results.saccades; currentResults];
end

for i = 1:length(trial.saccades.Y.onsets)
    currentOnset = trial.saccades.Y.onsets(i);
    currentOffset = trial.saccades.Y.offsets(i);
    entry = writeSaccadeEntry(1, currentOnset, currentOffset, trial);
    currentResults(1,~cellfun(@isempty,entry)) = [entry{~cellfun(@isempty,entry)}];
    currentResults(1,cellfun(@isempty,entry)) = NaN;
    results.saccades = [results.saccades; currentResults];
end

for i = 1:length(trial.saccades.T.onsets)
    currentOnset = trial.saccades.T.onsets(i);
    currentOffset = trial.saccades.T.offsets(i);
    entry = writeSaccadeEntry(2, currentOnset, currentOffset, trial);
    currentResults(1,~cellfun(@isempty,entry)) = [entry{~cellfun(@isempty,entry)}];
    currentResults(1,cellfun(@isempty,entry)) = NaN;
    results.saccades = [results.saccades; currentResults];
end


end