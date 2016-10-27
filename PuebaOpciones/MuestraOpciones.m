textos_opciones.pregunta = '¿Cuán acertadas cree que fueron sus\n respuestas en una escala de 1 a 9?';
textos_opciones.minimo = 'Nada';
textos_opciones.medio = '';
textos_opciones.maximo = 'Mucho';

global hd;
global escKey;
global rightKey;
global leftKey;
global downKey;

KbName('UnifyKeyNames');
escKey = KbName('ESCAPE');
rightKey = KbName('RightArrow');
leftKey = KbName('LeftArrow');
downKey = KbName('DownArrow');

ListenChar(2);
HideCursor;

hd = init_psych;
Respuesta(textos_opciones);
Salir;