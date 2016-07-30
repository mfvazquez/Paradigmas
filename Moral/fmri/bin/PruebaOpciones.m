function Moral()

clc;
sca;
close all;
% clearvars;

addpath(fullfile('..','lib'));

%PsychJavaTrouble
global hd; 

% -------------------- CONSTANTES -------------------------------------

LARGO_OPCIONES = 35;

textos_conducta.pregunta = '¿En términos de conducta moral, cómo calificaría la acción de Juan?';
textos_conducta.pregunta = AgregarFinLinea(textos_conducta.pregunta, LARGO_OPCIONES);
textos_conducta.minimo = 'Totalmente mala';
textos_conducta.medio = 'Neutral';
textos_conducta.maximo = 'Totalmente buena';

textos_danio.pregunta = '¿Qué tan dañino considera que fue el resultado de la acción de Juan?';
textos_danio.pregunta = AgregarFinLinea(textos_danio.pregunta, LARGO_OPCIONES);
textos_danio.minimo = 'Nada dañino';
textos_danio.medio = 'Neutral';
textos_danio.maximo = 'Muy dañino';

tamanio_fijacion = 0.05;
tamanio_historia = 0.035;

LARGO_LINEA = 65;

INSTRUCCIONES = 'A continuación se le presentarán una serie de situaciones. Por favor léalas y responda las preguntas usando las escalas correspondientes.';
INSTRUCCIONES = AgregarFinLinea(INSTRUCCIONES, round(LARGO_LINEA/2));
% -------------------- TECLAS A UTILIZAR -------------------------------

global escKey;
global rightKey;
global leftKey;
global downKey;

KbName('UnifyKeyNames');
escKey = KbName('ESCAPE');
rightKey = KbName('RightArrow');
leftKey = KbName('LeftArrow');
downKey = KbName('DownArrow');

% ------------------- INICIALIZO PSYCHOTOOLBOX ------------------------
% ListenChar(2);
HideCursor;
hd = init_psych();

% ------------------- INICIO DEL PARADIGMA ----------------------------

% ------------------- INTRODUCCION -----------------------------------
 
% dibujarOpciones(2, textos_conducta);
DrawFormattedText(hd.window, 'a', 'center', 'center', hd.white, [],[],[],[],[],[10 62 146 69]);
Screen('Flip', hd.window);
KbWait;
% ---------------------- FIN DEL PARADIGMA ---------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
% ListenChar(1);
ShowCursor;

end
