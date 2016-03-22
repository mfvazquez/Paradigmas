clc;
sca;
close all;
clearvars;

%PsychJavaTrouble
global hd; 

init_psych;

escKey = KbName('ESCAPE');
rightKey = KbName('RightArrow');
leftKey = KbName('LeftArrow');
downKey = KbName('DownArrow');

white = [255 255 255];

[xCenter, yCenter] = RectCenter(scrnsize);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

xPos = 0.25*screenXpixels;
xLength = screenXpixels * 0.05;
yLength = screenYpixels * 0.1;

baseRectBack = [0 0 xLength*10 yLength];
rectBack = baseRectBack + xPos;
Screen('FillRect', window, white, rectBack);


baseRect = [0 0 xLength yLength];
rect = baseRect + xPos;
red = [255 0 0];
DrawFormattedText(window, '1',xPos , xPos, red);

Screen('Flip', window);

% % % Xp = hd.centerx;
% % % Yp = hd.centery;
% % % 
% % % Ytext = Yp-60;
% % % Ydot = Yp+60;
% % % 
% % % Xtext = [Xp-120 Xp-40 Xp+40 Xp+120];
% % % Xdot = Xtext+20;
% % % 
% % % 
% % % dotSizePix = 20;
% % % 
% % % DrawFormattedText(window, '2', Xtext(1), Ytext, white);
% % % DrawFormattedText(window, '4', Xtext(2), Ytext, white);
% % % DrawFormattedText(window, '1', Xtext(3), Ytext, white);
% % % DrawFormattedText(window, '3', Xtext(4), Ytext, white);
% % % Screen('Flip', window);


ListenChar(2);
HideCursor;

actual = 1;

continuar = true;
while continuar

    [keyIsDown, secs, keyCode] = KbCheck;
    
    if keyIsDown
% % %         if keyCode(gKey) && actual == 1
% % %             actual = 2;
% % %             DrawFormattedText(window, '2', Xtext(1), Ytext, white);
% % %             DrawFormattedText(window, '4', Xtext(2), Ytext, white);
% % %             DrawFormattedText(window, '1', Xtext(3), Ytext, white);
% % %             DrawFormattedText(window, '3', Xtext(4), Ytext, white);
% % %             Screen('DrawDots', window, [Xdot(2) Ydot], dotSizePix, white, [], 2);
% % %             Screen('Flip', window);
% % %         elseif keyCode(jKey) && actual == 2
% % %             actual = 3;
% % %             DrawFormattedText(window, '2', Xtext(1), Ytext, white);
% % %             DrawFormattedText(window, '4', Xtext(2), Ytext, white);
% % %             DrawFormattedText(window, '1', Xtext(3), Ytext, white);
% % %             DrawFormattedText(window, '3', Xtext(4), Ytext, white);
% % %             Screen('DrawDots', window, [Xdot(3) Ydot], dotSizePix, white, [], 2);
% % %             Screen('Flip', window);
% % %         elseif keyCode(fKey) && actual == 3
% % %             actual = 4;
% % %             DrawFormattedText(window, '2', Xtext(1), Ytext, white);
% % %             DrawFormattedText(window, '4', Xtext(2), Ytext, white);
% % %             DrawFormattedText(window, '1', Xtext(3), Ytext, white);
% % %             DrawFormattedText(window, '3', Xtext(4), Ytext, white);
% % %             Screen('DrawDots', window, [Xdot(4) Ydot], dotSizePix, white, [], 2);
% % %             Screen('Flip', window);
% % %         elseif keyCode(hKey) && actual == 4
% % %             actual = 1;
% % %             DrawFormattedText(window, '2', Xtext(1), Ytext, white);
% % %             DrawFormattedText(window, '4', Xtext(2), Ytext, white);
% % %             DrawFormattedText(window, '1', Xtext(3), Ytext, white);
% % %             DrawFormattedText(window, '3', Xtext(4), Ytext, white);
% % %             Screen('DrawDots', window, [Xdot(1) Ydot], dotSizePix, white, [], 2);
% % %             Screen('Flip', window);
        if keyCode(escKey)
            continuar = false;
        end   
   
    end
    
end


ListenChar(1);
ShowCursor;
Screen('CloseAll'); % Cierro ventana del Psychtoolbox

