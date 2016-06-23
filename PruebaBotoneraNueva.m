clc
clear all
WaitSecs(1);
display 'inicio'
esperar = true;
while esperar
    tecla = GetChar;
    if tecla == '5'
        esperar = false;
    end
    WaitSecs(0.01);
end


% [~, keyCode, ~] = KbPressWait;
% find(keyCode)

% PsychHID('KbCheck')


