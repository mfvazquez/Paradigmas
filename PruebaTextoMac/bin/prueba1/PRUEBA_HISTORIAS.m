 
clc;
sca;
close all;
clearvars;

ListenChar(2);
HideCursor;
hd = init_psych();

textoCentrado('Juan y Gastón son ávidos escaladores de montaña\n y a menudo suben juntos. Juan quiere salir en secreto\n con la novia de Gastón, y PLANEA MATAR A GASTÓN\n LA PRÓXIMA VEZ QUE LOS DOS VAYAN\n A ESCALAR JUNTOS. Varias semanas después,\n Juan y Gastón van a escalar. Mientras están\n descendiendo por la pared de un empinado\n acantilado, Juan toma un cuchillo y corta\n las cuerdas de apoyo de Gastón. Gastón cae\n en picada por las rocas. Casi todos los\n huesos de su cuerpo se rompen con el impacto.\n Los gritos de Gastón son amortiguados por\n la sangre espesa y espumosa que fluye de su\n boca mientras se desangra hasta morir.', 0.04);
Screen('Flip', hd.window);
KbWait; 

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;
