
clc;
sca;
close all;
clearvars;

ListenChar(2);
HideCursor;
hd = init_psych();


historia = fileread('historia_1.txt');

textoCentrado(historia, 0.04);
Screen('Flip', hd.window);
KbWait; 

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;
