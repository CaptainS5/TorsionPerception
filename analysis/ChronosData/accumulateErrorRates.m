files = readFilesInPath('ErrorFiles');

trials = 0;
error1 = 0;
error2 = 0;
error3 = 0;
errors = 0;

for i = 1:length(files)
    file = files(i);
    load(['ErrorFiles\' file{1}]);
    trials = trials + length(errorStatus);
    error1 = error1 + sum(errorStatus == 1);
    error2 = error2 + sum(errorStatus == 2);
    error3 = error3 + sum(errorStatus == 3);
    errors = errors + sum(errorStatus ~= 0);
end

disp(trials);
disp(errors);
disp(errors/trials);
disp(error1);
disp(error2);
disp(error3);
disp(error1/errors);
disp(error2/errors);
disp(error3/errors);

