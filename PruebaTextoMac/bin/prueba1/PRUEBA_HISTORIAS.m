 
clc;
sca;
close all;
clearvars;

ListenChar(2);
HideCursor;
hd = init_psych();

textoCentrado('Juan y Gast�n son �vidos escaladores de monta�a\n y a menudo suben juntos. Juan quiere salir en secreto\n con la novia de Gast�n, y PLANEA MATAR A GAST�N\n LA PR�XIMA VEZ QUE LOS DOS VAYAN\n A ESCALAR JUNTOS. Varias semanas despu�s,\n Juan y Gast�n van a escalar. Mientras est�n\n descendiendo por la pared de un empinado\n acantilado, Juan toma un cuchillo y corta\n las cuerdas de apoyo de Gast�n. Gast�n cae\n en picada por las rocas. Casi todos los\n huesos de su cuerpo se rompen con el impacto.\n Los gritos de Gast�n son amortiguados por\n la sangre espesa y espumosa que fluye de su\n boca mientras se desangra hasta morir.', 0.04);
Screen('Flip', hd.window);
KbWait; 

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;
