prompt = {'Enter baseline speed',...
    'Enter the speed levels in degrees, separated by spaces.'};
title = 'Speed Level Calculator';
answer = inputdlg(prompt, title);
baseline = answer{1};
baseline = str2double(baseline);
values = answer{2};

myvalues = str2num(values); %#ok<ST2NM>

speedLevels = (myvalues./baseline)*100-100;

speedLevels = num2str(speedLevels);

speedLevels = [speedLevels]; %#ok<NBRAK>
speedLevels = strrep(speedLevels, '     ', ';');
speedLevels = strrep(speedLevels, ' ', ';');

for i = 1:10
    speedLevels = strrep(speedLevels, ';;', ';');
end

prompt = ['Resulting speed levels. (Ready for copy and paste) ' sprintf('\n') 'Your input was: ' values];
inputdlg(prompt,title,1,{speedLevels}); 
