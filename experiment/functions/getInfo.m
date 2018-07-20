function info = getInfo(currentBlock, rStyle, expTyp, eyeTracker)
% using GUI to gather sub information/manipulate parameters

global info

info.dateTime = clock;

% questions and defaults
n = 1;
q{n} = 'subID'; defaults{n} = 'JFcontrol'; n = n+1;
q{n} = 'Eyetracker(1) or not(0)'; defaults{n} = num2str(eyeTracker); n = n+1;
q{n} = 'ReportStyle(lower: -1; higher: 1)'; defaults{n} = num2str(rStyle); n = n+1; %L-lower; H-higher
q{n} = 'Block'; defaults{n} = num2str(currentBlock); n = n+1;
% q{n} = 'To block'; defaults{n} = '5'; n = n+1;
q{n} = 'Experiment type(-1=base, 0=baseTorsion, 1=exp, 2=control)'; defaults{n} = num2str(expTyp); n = n+1;

answer = inputdlg(q, 'Experiment basic information', 1, defaults);

% return value
n = 1;
info.subID = answer(n); n = n+1;
info.eyeTracker = str2num(answer{n}); n = n+1;
info.reportStyle = str2num(answer{n}); n = n+1;
info.block = str2num(answer{n}); n = n+1;
% info.toBlock = str2num(answer{n}); n = n+1;
info.expType = str2num(answer{n}); n = n+1;

info.fileNameTime = [info.subID{1}, '_', sprintf('%d-%d-%d_%d%d', info.dateTime(1:5))];

% save(['Info_', info.fileNameTime], 'info')

end

