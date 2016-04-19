clc;
close all;
clearvars;

%PsychJavaTrouble
global hd; 

init_psych;

escKey = KbName('ESCAPE');
fKey = KbName('f');
gKey = KbName('g');
hKey = KbName('h');
jKey = KbName('j');

Xp = hd.centerx;
Yp = hd.centery;

Ytext = Yp-60;
Ydot = Yp+60;

Xtext = [Xp-160 Xp-80 Xp Xp+80 Xp+160];
Xdot = Xtext+20;

white = [255 255 255];
dotSizePix = 20;

DrawFormattedText(window, '2', Xtext(1), Ytext, white);
DrawFormattedText(window, '5', Xtext(2), Ytext, white);
DrawFormattedText(window, '3', Xtext(3), Ytext, white);
DrawFormattedText(window, '4', Xtext(4), Ytext, white);
DrawFormattedText(window, '3', Xtext(5), Ytext, white);
Screen('DrawDots', window, [Xdot(1) Ydot], dotSizePix, white, [], 2);
Screen('Flip', window);


ListenChar(2);
HideCursor;

actual = 1;

continuar = true;
while continuar

    [~, keyCode, ~] = KbPressWait;
    
        tstart = GetSecs;
        if ~keyCode(escKey)                
                actual = actual + 1;
                if actual > 5
                    actual = 1;
                end
                DrawFormattedText(window, '2', Xtext(1), Ytext, white);
                DrawFormattedText(window, '5', Xtext(2), Ytext, white);
                DrawFormattedText(window, '3', Xtext(3), Ytext, white);
                DrawFormattedText(window, '4', Xtext(4), Ytext, white);
                DrawFormattedText(window, '3', Xtext(5), Ytext, white);
                Screen('DrawDots', window, [Xdot(actual) Ydot], dotSizePix, white, [], 2);
                Screen('Flip', window);
        else
            continuar = false;
        end   
    
end


ListenChar(1);
ShowCursor;
Screen('CloseAll'); % Cierro ventana del Psychtoolbox

