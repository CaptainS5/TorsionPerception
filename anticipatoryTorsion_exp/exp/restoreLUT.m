function restoreLUT(screen)


% Make a backup copy of original LUT into origLUT.
origLUT=Screen('ReadNormalizedGammaTable', screen);

try
    [w rect] =Screen('OpenWindow', screen);
    load('originalLUT.mat')
    Screen('FillRect', w, [0 0 0], rect);
    
    
    Screen('FillRect', w, [150 0 0], [100 100 200 200]);
    Screen('FillRect', w, [0 150 0], [100 100 200 200]+200);
    Screen('FillRect', w, [0 0 150], [100 100 200 200]+400);
    Screen('FillRect', w, [150 0 150], [300 100 400 200]+100);
    Screen('Flip',w);
    pause(1);
    
    Screen('LoadNormalizedGammaTable', w, originalLUT);
    
    Screen('FillRect', w, [150 0 0], [100 100 200 200]);
    Screen('FillRect', w, [0 150 0], [100 100 200 200]+200);
    Screen('FillRect', w, [0 0 150], [100 100 200 200]+400);
    Screen('FillRect', w, [150 0 150], [300 100 400 200]+200);
    Screen('Flip',w);
    
    pause(1);
    
    Screen('LoadNormalizedGammaTable', w, originalLUT);
    Screen('FillRect', w, [150 0 0], [100 100 200 200]);
    Screen('FillRect', w, [0 150 0], [100 100 200 200]+200);
    Screen('FillRect', w, [0 0 150], [100 100 200 200]+400);
    Screen('FillRect', w, [150 0 150], [300 100 400 200]+300);
    Screen('Flip',w);
    
    pause(1);
    
    Screen('CloseAll');
catch ME
    Screen('LoadNormalizedGammaTable', w, originalLUT);
end
end