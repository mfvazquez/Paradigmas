%% Bloque Habilidades

fprintf(log_txt,'\n');
fprintf(log_txt,'Bloque Habilidades \n');
fprintf(log_txt,'Evento;');
fprintf(log_txt,'TiempoAbsoluto\n');

%Presentación de la prueba de habilidades
present_diapo( PruebaHab);
continuar_p;
WaitSecs(blacktime);

%Consigna de la prueba de habilidades
present_diapo( ConsignaHab);
continuar_p;
WaitSecs(blacktime);

%Marca de inicio
if parallel_port
    io32(pportobj,pportaddr,108) %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end

tiempo_inicio =GetSecs;

fprintf(log_txt,'Inicio countdown;');
fprintf(log_txt,'%d',tiempo_inicio);
fprintf(log_txt,'\n');

countdown;  %Inicio la cuenta regresiva de 3 minutos
tiempo_fin= GetSecs;
continuar_p;
WaitSecs(blacktime);

fprintf(log_txt,'Fin countdown;');
fprintf(log_txt,'%d',tiempo_fin);
fprintf(log_txt,'\n');

WaitSecs(blacktime);

%Marca de fin de cuenta regresiva
if parallel_port
    io32(pportobj,pportaddr,118) %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end

%Inicio de exposición
present_diapo(InicioExpos);
continuar_p;
WaitSecs(blacktime);
%Marca de inicio de discurso

if parallel_port
    io32(pportobj,pportaddr,109) %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end

tiempo_inicio_speech= GetSecs;

fprintf(log_txt,'Inicio discurso;');
fprintf(log_txt,'%d',tiempo_inicio_speech);
fprintf(log_txt,'\n');

minutosDiscurso=5;

VideoRecordingDemo(['Videos\Speech_' Name], minutosDiscurso); %el segundo argumento es el tiempo (en minutos) de duración del video

tiempo_fin_speech= GetSecs;

fprintf(log_txt,'Fin discurso;');
fprintf(log_txt,'%d',tiempo_fin_speech);
fprintf(log_txt,'\n');

%Marca de fin de discurso
if parallel_port
    io32(pportobj,pportaddr,119) %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end


%Consigna hab. Mat
present_diapo(ConsignaMat);
continuar_p;
WaitSecs(blacktime);

%Inicio del bloque mat.
present_diapo(InicioBloqMat);
continuar_p;
WaitSecs(blacktime);

%Marca de inicio de la prueba mat
if parallel_port
    io32(pportobj,pportaddr,110) %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end

Reiniciar_prueba= true;
InitMat= GetSecs;

fprintf(log_txt,'Inicio prueba matemática;');
fprintf(log_txt,'%d',InitMat);
fprintf(log_txt,'\n');

fprintf(log_txt,'\n');
fprintf(log_txt,'Prueba Matemática \n');
fprintf(log_txt,'Respuesta;');
fprintf(log_txt,'Respuesta correcta;');
fprintf(log_txt,'Accuracy;');
fprintf(log_txt,'TiempoRelativo;');
fprintf(log_txt,'TiempoAbsoluto\n');

minutos_bloqueMat=5;

while Reiniciar_prueba && (GetSecs-InitMat)<minutos_bloqueMat*60
    
    Reiniciar_prueba= Resta (1022, log_txt);
    
    if Reiniciar_prueba
        
        present_diapo(ERROR);
        WaitSecs(1);
        
        present_diapo(InformeError);
        WaitSecs(4);
        
    end
    
end

present_diapo(FinalHab);
continuar_p;
WaitSecs(blacktime);