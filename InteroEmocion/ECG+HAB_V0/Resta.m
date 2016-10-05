function [ reiniciar_prueba ] = Resta( n, log_txt )
%RESTA
global hd;
global parallel_port;
global pportobj pportaddr;
reiniciar_prueba= false;
labels= '1              2              3               4              5\n\n';

for i=1:70
    
    numMat(1)= n-13;
    numMat(2)= n-10;
    numMat(3)= n-3;
    numMat(4)= n-100;
    numMat(5)= floor(100*rand + floor((n-13)/100)*100);
    
    x_index=randperm(size(numMat,2));
    
    for j=1:5
        NewnumMat(j)= numMat(x_index(j));
    end
    
    Screen('TextSize', hd.window, 40);
    DrawFormattedText(hd.window, [num2str(n) '\n\n\n\n' labels num2str(NewnumMat(1)) '         ' num2str(NewnumMat(2)) '         ' num2str(NewnumMat(3)) '          ' num2str(NewnumMat(4)) '          ' num2str(NewnumMat(5))], 'center', 'center', [255 255 255]);
    
    Screen('Flip', hd.window);
    
    keyCode(49) = 0;
    keyCode(50) = 0;
    keyCode(51) = 0;
    keyCode(52) = 0;
    keyCode(53) = 0;
    keyCode(80) = 0;
    keyCode(13) = 0;
    keyIsDown   = 0;
    
    salir=false;
    initTime=GetSecs;
    
    while (GetSecs < initTime + 20) && salir==false %Mientras que no pasen 20 seg y haya respondido bien se queda
            
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            
            if keyCode(80) == 1  % Salgo del programa con la letra p
                
                PsychPortAudio('Close',hd.pahandle);
                PsychPortAudio('Close',hd.pahandle2);
                Screen('CloseAll'); % Cierro ventana del Psychtoolbox
                fclose(log_txt);
                
            end
            
            if keyIsDown              % Se queda en este loop hasta que presione la respuesta;
                
                tiempo_rta= GetSecs;                
                Results=find(keyCode);
                for j=1:5
                    
                    
                    if (Results==(49+(j-1)))% || (Results==97)
                        
                        if parallel_port
                            io32(pportobj,pportaddr,120+j) %Envio data por puerto paralelo
                            WaitSecs(0.01);
                            io32(pportobj,pportaddr,0)
                        end
                        
                                                
                        Option=j;
                                          

                        if (NewnumMat(Option)==numMat(1))
                            WaitSecs(1);
                            salir=true; %Si responde bien paso al próximo número
                            
                            fprintf(log_txt,'%d', NewnumMat(Option));
                            fprintf(log_txt,';');
                            fprintf(log_txt,'%d',numMat(1));
                            fprintf(log_txt,';');
                            fprintf(log_txt,'%d',1); %Si acierta, accuracy=1
                            fprintf(log_txt,';');                            
                            fprintf(log_txt,'%d',tiempo_rta-initTime);
                            fprintf(log_txt,';');
                            fprintf(log_txt,'%d',tiempo_rta);
                            fprintf(log_txt,'\n');

                            
                        else
                            reiniciar_prueba=true;
                            
                            fprintf(log_txt,'%d', NewnumMat(Option));
                            fprintf(log_txt,';');
                            fprintf(log_txt,'%d',numMat(1));
                            fprintf(log_txt,';');
                            fprintf(log_txt,'%d',0);% Si se equivoca, accuracy=0
                            fprintf(log_txt,';');                            
                            fprintf(log_txt,'%d',tiempo_rta-initTime);
                            fprintf(log_txt,';');
                            fprintf(log_txt,'%d',tiempo_rta);
                            fprintf(log_txt,'\n');
                            return; %Vuelvo a empezar
                        end
                    end
                    
                end
            end
            
    end
    if salir==false
        reiniciar_prueba=true;
        return; %Vuelvo a empezar
    end
    n=n-13;
end
end

