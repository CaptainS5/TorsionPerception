function [ results, resultFile ] = setupResultFile(header)
%% setupResultFile
%   This function prepares the result file, which is later filled the
%   function saveTrialResults.m
%   Result file is a matrix (.mat-file) that can be later loaded
%   and opened in Matlab.
%   If the file already exists, it is opened, otherwise it gets created.
%
%% inputs
%   header:     the header read by the readLogFile.m function
%
%% outputs
%   results:    the trial data from all analyses. Structure of two
%               matrices: 1) trial: results from pursuit, saccades and
%               torsion, 2) results from saccade blocks for Listing's plane
%               analysis
%   resultFile: name of the results file, e.g., result_exp10_subj1.mat


%% set up result file name
resultFile = ['result_exp' num2str(header.experiment) '_subj' num2str(header.subjectID) 'TESTTEST.mat'];
resultFile = fullfile(pwd,'Results',resultFile);
try
    load(resultFile);
    disp('Result file loaded');
catch  %#ok<CTCH>
    results.trial = [];
    results.saccades = [];
    disp('No result file found. Created a new one.');
end


end

