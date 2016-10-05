
%countdown.m
%display countdown on active psychtoolbox screen

%countdown to start of calibration stims
    mins=3;
    IniTime= GetSecs;
    
    while (GetSecs - IniTime)<(mins*60)
                
    countDown= (mins*60)-(GetSecs - IniTime); %Tomo los minutos del cowntdown
    when= (GetSecs+1)/1000;
    minute= floor(countDown/60);
    secs= floor(mod(countDown,60));
    mils=strrep(num2str(mod(countDown,60)- secs, '%.2f'),['0.'],'');
    txt=[num2str(minute) ':' num2str(secs) ':' mils(1:2)];
    % PRESENT STARTING Screen
    Screen('TextSize', hd.window, 60);
    DrawFormattedText(hd.window, txt, 'center', 'center', [255 255 255]);
    flipTime = Screen('Flip', hd.window, when);
    end
