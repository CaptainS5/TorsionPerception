function [decision] = showResponseModule(display, parameter)

% Setup display
display.width = display.size(3) - display.size(1);
display.height = display.size(4) - display.size(2);
Screen('TextSize', display.windowPointer, 25);

% Setup colors
black=BlackIndex(display.windowPointer);
dark_grey = [100 100 100];
grey = [150 150 150];

% Set arrow positions
arrowUpPosition = [display.width/3+90 display.height/2-15];
arrowDownPosition = [display.width/3+90 display.height/2+25];

% Set text position
fasterPosition = [display.width/3+120 display.height/2-20];
slowerPosition = [display.width/3+120 display.height/2+20];

% Setup keys
upKey = 38;
downKey = 40;
escapeKey = 27;


while(true)
    Screen('FillRect', display.windowPointer, grey);
    
    if(parameter.torsion)
        drawArrowUp(arrowUpPosition, black);
        drawArrowDown(arrowDownPosition, black);
        drawText(fasterPosition, black, 'faster');
        drawText(slowerPosition, black, 'slower');
    end
    
    Screen('Flip',display.windowPointer);
    
    [keyIsDown, ~, keyCode, ~] = KbCheck();
    if(keyIsDown == 1)
        
        %Faster
        if(keyCode(upKey) == 1)
            
            Screen('Flip',display.windowPointer);
            pause(0.5)
            decision = 1;
            break;
        end
        
        %Slower
        if(keyCode(downKey) == 1)
            
            Screen('Flip',display.windowPointer);
            pause(0.5);
            decision = 0;
            break;
        end
        
        %Exit
        if(keyCode(escapeKey) == 1)
            Screen('CloseAll');
            return;
        end
    end
end

    function [] = drawArrowUp(position, color)
        Screen('DrawLine', display.windowPointer ,color , position(1) + 10, position(2), position(1) + 10, position(2) + 25, 3);
        Screen('DrawLine', display.windowPointer ,color , position(1), position(2) + 10, position(1) + 10, position(2), 3);
        Screen('DrawLine', display.windowPointer ,color , position(1) + 10, position(2), position(1) + 20, position(2) + 10, 3);
    end

    function [] = drawArrowDown(position, color)
        Screen('DrawLine', display.windowPointer ,color , position(1) + 10, position(2), position(1) + 10, position(2) + 25, 3);
        Screen('DrawLine', display.windowPointer ,color , position(1), position(2) + 15, position(1) + 10, position(2) + 25, 3);
        Screen('DrawLine', display.windowPointer ,color , position(1) + 10, position(2) + 25, position(1) + 20, position(2) + 15, 3);
    end

    function [] = drawText(position, color, text)
        DrawFormattedText(display.windowPointer ,...
            text ,...
            position(1) , position(2), color);
    end

end



