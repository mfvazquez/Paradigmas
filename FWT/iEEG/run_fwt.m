function [respMat, EXIT]= run_fwt(PsyParams, estimulos, mensaje, keys ,respMat)
    
    experimental = (nargin == 5);
    if (~experimental) 
        respMat = []; 
    end
    EXIT = 0;

    BLINK_DURATION = 0.02;
    
    numTrials = size(estimulos, 2);
    
    window = PsyParams.window;
    xCenter = PsyParams.xCenter;
    yCenter = PsyParams.yCenter;
    black = PsyParams.black;
    white = PsyParams.white;

    ExitKey = keys.ExitKey;
    CaraKey = keys.CaraKey;
    NoCaraKey = keys.NoCaraKey;

   
    %Si pasan un quinto argumento a la funcion entonces es un bloque experimental
    %y no de practica

    for trial = 1:numTrials


        % Cue to determine whether a response has been made
        respToBeMade = true;

        % If this is the first trial we present a start screen and wait for a
        % key-press
        if trial == 1       
            Screen('TextSize', window, 20);
            DrawFormattedText(window, mensaje, 'center', 'center', white);
            Screen('Flip', window);
            KbStrokeWait;     
            Screen('TextSize', window, 40);

        end

        % Flip again to sync us to the vertical retrace at the same time as
        % drawing our fixation point
        Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
        Screen('Flip', window);
        WaitSecs(0.2);

        tStart = GetSecs;

       % Draw the word
       DrawFormattedText(window, char(estimulos(1, trial)), 'center', 'center', white);
       
        if (experimental)
            blink(PsyParams, BLINK_DURATION);
       else
           Screen('Flip', window);
       end
       % Flip to the screen
        
        WaitSecs(0.3);

%         if (experimental)
%             io32(pportobj,pportaddr,0)
%         end
        
        response=[];
        accuracy=[];

        while respToBeMade == true && (GetSecs-tStart)<2.99

            if (GetSecs-tStart)>0.29

                Screen('FillRect', window, black)
                Screen('Flip', window);


            end

            % Check the keyboard. The person should press the
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(ExitKey)
                ShowCursor;
                ListenChar(0)
                sca;
                EXIT = 1;
                return
                
           
            elseif keyCode(CaraKey)
                respToBeMade = false;
                
                if experimental
                    response = 1;
                    if response==cell2mat(estimulos(4, trial))
                        accuracy=1; 
                    else
                        accuracy=0; 
                    end
                    blink(PsyParams, BLINK_DURATION);
                end
                
            elseif keyCode(NoCaraKey)
                respToBeMade = false;
                if experimental
                    response = 2;
                    if response==cell2mat(estimulos(4, trial))
                        accuracy=1; 
                    else
                        accuracy=0; 
                    end
                    blink(PsyParams, BLINK_DURATION);
                end                

            end


        end

        tEnd = GetSecs;
        rt = tEnd - tStart;
        
        Screen('FillRect', window, black)
        Screen('Flip', window);


        % Record the trial data into out data matrix
        if experimental
            respMat{1, trial} = estimulos(1,trial);
            respMat{2, trial} = estimulos(2,trial);
            respMat{3, trial} = estimulos(3,trial);
            respMat{4, trial} = response;
            respMat{5, trial} = accuracy;
            respMat{6, trial} = rt;
        end
        
        WaitSecs(0.5);

    end
end