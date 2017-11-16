returnvalue = 1;



if(strcmp(evt.Key,'k'))
    currentTrial = evalin('base', 'currentTrial');
    trial = evalin('base', 'trial');
    torsion = evalin('base', 'torsion');
    currentTrial = currentTrial + 1;
    assignin('base','currentTrial',currentTrial);
%     analyzeTrial;
    plotResults;
    disp('Success?');
end



disp(evt.Key);

