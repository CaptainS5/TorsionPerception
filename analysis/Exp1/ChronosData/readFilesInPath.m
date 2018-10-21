function [files] = readFilesInPath(path)

    if ~path
        path = '';
    end
    
    logFiles = dir(path);
    files = {};

    for i = 3:length(logFiles) %first two are '.' and '..'
        files{i-2} = logFiles(i).name;
    end
end