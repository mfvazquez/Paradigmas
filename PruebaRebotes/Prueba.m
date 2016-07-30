
clc;
sca;
close all;
clearvars;
%PsychJavaTrouble

% ------------------- CONSTANTES GLOBALES -----------------------------
global hd; 
global escKey;
global UpONKey;
global DownONKey;
global UpOFFKey;
global DownOFFKey;

% -------------------- TECLAS A UTILIZAR -------------------------------
KbName('UnifyKeyNames');
escKey = KbName('ESCAPE');

UpONKey = KbName('F');
DownONKey = KbName('D');

UpOFFKey = KbName('J');
DownOFFKey = KbName('H');

INCREMENTO = 0.005;
% ------------------- INICIALIZO PSYCHOTOOLBOX ------------------------
%     ListenChar(2);
HideCursor;
hd = init_psych();


OnTime = 1;
OffTime = 1;

continuar = true;
inicio = true;
blinkON = false;
texto = ['Tiempo en ON: ' num2str(OnTime) '\n Tiempo en OFF: ' num2str(OffTime) ];
textoCentrado(texto);
Screen('Flip', hd.window);
while continuar
    if inicio
        tstart = GetSecs;
        inicio = false;
    end
    
    [keyIsDown,secs, keyCode] = KbCheck;
    if keyCode(escKey)
        continuar = false;
        
    end
       
    if keyCode(UpONKey)
        OnTime = OnTime + INCREMENTO;
    end
    
    if keyCode(DownONKey)
        OnTime = OnTime - INCREMENTO;
        if OnTime < 0
            OnTime = 0;
        end
    end
    
    if keyCode(UpOFFKey)
        OffTime = OffTime + INCREMENTO;
    end
    
    if keyCode(DownOFFKey)
        OffTime = OffTime - INCREMENTO;
        if OffTime < 0
            OffTime = 0;
        end
    end
    

    texto = ['Tiempo en ON: ' num2str(OnTime) '\n Tiempo en OFF: ' num2str(OffTime) ];
    textoCentrado(texto);
    
    if GetSecs - tstart < OnTime
        blink(true);
        Screen('Flip', hd.window);
    elseif GetSecs - tstart < OnTime + OffTime && GetSecs - tstart > OnTime
        blink(false);
        Screen('Flip', hd.window);
    end
    
    if GetSecs - tstart > OnTime + OffTime
        inicio = true;
    end
% %     WaitSecs(INCREMENTO/2);
end


% ---------------------- FIN DEL PARADIGMA ---------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;

