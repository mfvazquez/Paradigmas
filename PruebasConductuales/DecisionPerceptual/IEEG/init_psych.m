function hd = init_psych()
   
    global hd
    ListenChar(2);
    HideCursor;

    hd.bgcolor = [0 0 0] ;
    hd.dispscreen = 0;
    hd.itemsize = 100;
    hd.wsize = (hd.itemsize/2)+30;

    hd.textsize = 60;
    hd.textfont = 'Helvetica';
    hd.textcolor = [255 255 255];%[255 255 255]
    hd.ontime = 150/1000;
    hd.offtime = 850/1000;

    blacktime=500/1000;
    debounce=100/1000;
    
    hd.white = [255 255 255];
    hd.black = [0 0 0];
    hd.red = [255 0 0];
    hd.green = [0 255 0];
    hd.blue = [0 0 255];


%   Screen('Preference', 'Verbosity', 0);

    Screen('Preference', 'TextRenderer', 1);
    Screen('Preference', 'TextAntiAliasing', 2);
    Screen('Preference', 'TextAlphaBlending',1);

    Screen('Preference', 'SkipSyncTests', 0);

    % Open Psychtoolbox main window

    [window,scrnsize] = Screen('OpenWindow', hd.dispscreen, hd.bgcolor);
    hd.window = window;
    hd.centerx = scrnsize(3)/2;
    hd.centery = scrnsize(4)/2;
    hd.scrnsize = scrnsize;

    % Adjust requested SOA so that it is an exact multiple of the base refresh
    % interval of the monitor at the current refresh rate.

    refreshInterval = Screen('GetFlipInterval',hd.window);
    hd.ontime = ceil(hd.ontime/refreshInterval) * refreshInterval;
    hd.offtime = ceil(hd.offtime/refreshInterval) * refreshInterval;
    fprintf('\nUsing ON time of %dms with OFF time of %dms.\n', round(hd.ontime*1000), round(hd.offtime*1000));
    Screen('TextFont',hd.window,hd.textfont);

    %Screen settings

    xCenter=hd.centerx;
    yCenter=hd.centery;

    %Teclas de respuesta
    KbName('UnifyKeyNames');

    topPriorityLevel = MaxPriority(window);
    Priority(topPriorityLevel);

    %Para que los dots sean circulares.
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
end
