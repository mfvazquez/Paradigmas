% function [exit, grabacion] = PresentarGrabacion(hd, texto, tiempos, recObj)
      
%     global TAMANIO_TEXTO triggerlevel

    tiempos.duracion = 5;
    tiempos.silencio = 0.2;
    exit = false;
    
    tstart = GetSecs;
    recObj = audiorecorder(22050, 16, 1);
    recObj.record;
    WaitSecs(0.3);
    triggerlevel = 0.15;
    grabacion.inicio_t = GetSecs;
    
    
%     TextoCentrado(texto, TAMANIO_TEXTO ,hd);    
%     [~, grabacion.on_set] = Screen('Flip', hd.window);  
    id_start = recObj.TotalSamples;
    
    id_inicio = id_start;
    seguir_grabando = true;
    continuar = true;
    while continuar

        canal = recObj.getaudiodata;
        id_final = length(canal);
        canal = canal(id_inicio:id_final);

        idx = find(abs(canal) >= triggerlevel, 1 );

        if ~isempty(idx)
            grabacion.id_hablo = idx + id_inicio - 1 - id_start;
            continuar = false;        
        end
        
        id_inicio = id_final;

        if GetSecs - grabacion.inicio_t >= tiempos.duracion
            seguir_grabando = false;
            continuar = false;
        end
    end
    
    display caca

    %% TERMINA DE GRABAR
    while seguir_grabando
        if GetSecs - grabacion.inicio_t + tiempos.silencio >= tiempos.duracion
            WaitSecs(tiempos.duracion - (GetSecs - grabacion.inicio_t));
            display pedo
        else
            display pis
            WaitSecs(tiempos.silencio);
        end
            
        canal = recObj.getaudiodata;
        id_final = length(canal);
        canal = canal(id_inicio:id_final);

        idx = find(abs(canal) >= triggerlevel, 1 )

        id_inicio = id_final;
        
        if isempty(idx) || GetSecs - grabacion.inicio_t >= tiempos.duracion
            seguir_grabando = false;
        end
    end

    recObj.pause;
    
    canal = recObj.getaudiodata;
    grabacion.canal = canal(id_start:end);
    grabacion.tiempo = (1:length(grabacion.canal))./recObj.SampleRate;
    grabacion.hablo_t = (grabacion.id_hablo/recObj.SampleRate);    
    
    
    
    figure
    plot(grabacion.canal)
    hold on
    stem(grabacion.id_hablo, triggerlevel, 'r');
    
    sound(grabacion.canal(grabacion.id_hablo:end), recObj.SampleRate);

    
    figure
    plot(grabacion.tiempo, grabacion.canal)
    hold on
    stem(grabacion.hablo_t, triggerlevel, 'r');
    recObj.delete


y = 15;
figure
plot(log.datos{1}.trials{y}.grabacion.tiempo, log.datos{1}.trials{y}.grabacion.canal)
hold on
stem (log.datos{1}.trials{y}.grabacion.hablo_t, 0.5, 'r')

sound(log.datos{1}.trials{y}.grabacion.canal(log.datos{1}.trials{y}.grabacion.id_hablo:end), 22050);
