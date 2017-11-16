files = readFilesInPath('Results');

trials = [];
saccades = [];

for i = 1:length(files)
    file = files(i);
    load(['Results\' file{1}]);
    trials = [trials; results.trial];
    saccades = [saccades; results.saccades];
end

save('trials','trials');
save('saccades','saccades');