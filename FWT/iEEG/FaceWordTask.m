%% Face Word Task - Version 5
function FWT()
% Clear the workspace
    close all;
    clear all;
    sca;

    addpath('lib\xlwrite\xlwrite');
    loadPOI;

    %cd F:\Paradigmas\FWT\FWT %% Path to the experiment folder

    Name=input('\nIngrese su nombre:','s');
    % % Setup PTB with some default values
    % PsychDefaultSetup(2);
    % 
    % % Seed the random number generator. Here we use the an older way to be
    % % compatible with older systems. Newer syntax would be rng('shuffle'). Look
    % % at the help function of rand "help rand" for more information
    % rand('seed', sum(100 * clock));

    % Set the screen number to the external secondary monitor if there is one
    % connected
    screenNumber = max(Screen('Screens'));

    % Define black, white and grey
    white = WhiteIndex(screenNumber);
    grey = white / 2;
    black = BlackIndex(screenNumber);

    % Open the screen
    % [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2);


    %% set Psychtoolbox preferences

    % Screen('Preference', 'ConserveVRAM', 64);  %agregado
    Screen('Preference', 'Verbosity', 0);
    % Screen('Preference', 'VisualDebugLevel',0);

    % Screen('Preference', 'VBLTimestampingMode', 1);
    % Screen('Preference', 'TextRenderer', 1);
    Screen('Preference', 'TextAntiAliasing', 2);
    % Screen('Preference', 'TextAlphaBlending',1);

    HideCursor();

    %open Psychtoolbox main window
    [window,windowRect] = Screen('OpenWindow', screenNumber, black);


    % Flip to clear
    Screen('Flip', window);

    % Query the frame duration
    ifi = Screen('GetFlipInterval', window);

    % Set the text size
    Screen('TextSize', window, 20);

    % Query the maximum priority level
    %topPriorityLevel = MaxPriority(window);

    % Get the centre coordinate of the window
    [xCenter, yCenter] = RectCenter(windowRect);

    % Set the blend funciton for the screen
    %Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    PsyParams.window = window;
    PsyParams.xCenter = xCenter;
    PsyParams.yCenter = yCenter;
    PsyParams.black = black;
    PsyParams.white = white;
    PsyParams.grey = grey;

    %----------------------------------------------------------------------
    %                       Timing Information
    %----------------------------------------------------------------------

    % Interstimulus interval time in seconds and frames
    isiTimeSecs = 0.5;
    isiTimeFrames = round(isiTimeSecs / ifi);

    % Numer of frames to wait before re-drawing
    waitframes = 1;


    %----------------------------------------------------------------------
    %                       Keyboard information
    %----------------------------------------------------------------------

    % Define the keyboard keys that are listened for. We will be using the left
    % and right arrow keys as response keys for the task and the escape key as
    % a exit/reset key

    escapeKey = KbName('esc');
    vKey = KbName('v');
    bKey = KbName('b');

    key.ExitKey = escapeKey;
    key.CaraKey = vKey;
    key.NoCaraKey = bKey;

    key_inv.ExitKey = escapeKey;
    key_inv.CaraKey = bKey;
    key_inv.NoCaraKey = vKey;

    keys{1,1} = key;
    keys{1,2} = key_inv;

    %----------------------------------------------------------------------
    %                         Response matrix
    %----------------------------------------------------------------------

    % Seven row matrix: the first row will record the word we present,
    % the second row the correct response, the third row the tag, the fourth, the
    % subject's response, the fifht, if it was correct, the sixth row, the time 
    % they took to make their response, and the seventh, the block number


    %----------------------------------------------------------------------
    %                          Inicializo Datos
    %----------------------------------------------------------------------

    load('data/practicas.mat');
    load('data/estimulos.mat');

    respMat = cell(1,8);

    respMat{1,1} = cell(6, length(estimulos{1,1}));
    respMat{1,2} = cell(6, length(estimulos{1,2}));
    respMat{1,3} = cell(6, length(estimulos{1,3}));
    respMat{1,4} = cell(6, length(estimulos{1,4}));
    respMat{1,5} = cell(6, length(estimulos{1,5}));
    respMat{1,6} = cell(6, length(estimulos{1,6}));
    respMat{1,7} = cell(6, length(estimulos{1,7}));
    respMat{1,8} = cell(6, length(estimulos{1,8}));

    mensaje_practica1 = ['A continuación le presentaremos algunas '...
                 'palabras sueltas \n\n\n En cada caso, debe indicar si '...
                 'la palabra involucra o no un ROSTRO HUMANO \n\n\n\n '...
                 'Ejemplos de palabras que SÍ involucran un ROSTRO HUMANO '...
                 'son: \n\n cachete, flequillo y chiflar \n\n\n Ejemplos de '...
                 'palabras que NO involucran un ROSTRO HUMANO son: \n\n palma, '...
                 'pulsera y anotar \n\n\n\n Para indicar que SÍ, presione la '...
                 'tecla V con el dedo ÍNDICE \n\n\n Para indicar que NO, '...
                 'presione la tecla B con el dedo MEDIO \n\n\n\n IMPORTANTE:\n\n '...
                 'Debe responder lo más rápido posible, \n\n sin pensar demasiado '...
                 'el significado de la palabra \n\n (no analice, sólo reaccione) \n\n\n\n '...
                 'Hagámos unos intentos de práctica '];


    mensaje_practica2 = ['¿Listo para continuar? \n\n\n\n Ahora deberá hacer exactamente'...
                 ' lo mismo \n\n\n Al igual que antes, debe indicar si la '...
                 'palabra involucra o no un ROSTRO HUMANO \n\n\n\n La única '...
                 'diferencia es que deberá cambiar de dedo para sus '...
                 'respuestas \n\n\n\n Para indicar que SI, presione la '...
                 'tecla B con el dedo MEDIO \n\n\n Para indicar que NO, '...
                 'presione la tecla V con el dedo ÍNDICE \n\n\n\n '...
                 'IMPORTANTE:\n\n Debe responder lo más rápido posible, \n\n '...
                 'sin pensar demasiado en el significado de la palabra \n\n '...
                 '(no analice, sólo reaccione) \n\n\n\n Hagamos unos '...
                 'intentos de práctica '];

    mensaje_experimental = '¡Muy bien! \n\n ¿Listo para la prueba? \n\n Comencemos ';

    mensajes_practicas = {mensaje_practica1 mensaje_practica2};

    mensaje_pausa = ['Momento de pausa. \n\n Tómese unos instantes para descansar y \n\n '...
            'cuando esté listo presione cualquier tecla para continuar'];

    mensaje_despedida = '¡Eso es todo! \n\n ¡Muchas gracias por su participación! ';

    %----------------------------------------------------------------------
    %                          Corrida del paradigma
    %----------------------------------------------------------------------

    ListenChar(2)

    for i = 1:length(estimulos)
    practica_id = mod(i,2);
    if (practica_id == 0) 
    practica_id = 2; 
    end

    [~, EXIT] = run_fwt(PsyParams, practicas{1,practica_id}, mensajes_practicas{practica_id}, keys{practica_id});
    if (EXIT) 
    break; 
    end

    [respMat{1,i}, EXIT] = run_fwt(PsyParams, estimulos{1,i}, mensaje_experimental, keys{practica_id} ,respMat{1,i});
    if (EXIT) 
    break; 
    end


    if (practica_id == 2)
    Screen('TextSize', window, 20);
    DrawFormattedText(window, mensaje_pausa, 'center', 'center', white);
    Screen('Flip', window);
    KbStrokeWait;
    end
    % End of experiment screen. We clear the screen once they have made their
    % response

    end

    if (~EXIT)
    DrawFormattedText(window, mensaje_despedida, 'center', 'center', white);
    Screen('Flip', window);
    KbStrokeWait;
    ListenChar(0);
    ShowCursor();
    sca;
    end

    %----------------------------------------------------------------------
    %                          Guardado del Log
    %----------------------------------------------------------------------

    if (~exist('log','dir')) 
    mkdir log;
    mkdir log/mat;
    end

    for i = 1:length(respMat)
    xlwrite(['log\' Name '.xls'], respMat{1,i}, ['Bloque ' int2str(i)], 'A1');

    end

    save(['log\mat\log_' Name], 'respMat');
end