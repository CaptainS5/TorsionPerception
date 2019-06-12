function [] = showBreakModule(display)

%Setup colors
black = BlackIndex(display.windowPointer);
grey = [150 150 150];

%Setup display
display.width = display.size(3);
display.height = display.size(4);

%Setup keys
f12Key = 123;

%Fill background
Screen('FillRect', display.windowPointer, grey);

DrawFormattedText(display.windowPointer ,...
    'Please wait for the next block to start.' ,...
    display.width/4 , display.height/2, black);

Screen('Flip',display.windowPointer);

%Wait until F12 is pressed
while(true)
    [keyIsDown, ~, keyCode, ~] = KbCheck();
    if(keyIsDown == 1)
        
        if(keyCode(f12Key) == 1)
            break;
        end
        
        if(keyCode(27) == 1)
            load('originalLUT.mat');
            Screen('LoadNormalizedGammaTable', display.windowPointer, originalLUT);
            pause(0.2);
            Screen('CloseAll');
        end
        
    end
    
    
    
    
end

