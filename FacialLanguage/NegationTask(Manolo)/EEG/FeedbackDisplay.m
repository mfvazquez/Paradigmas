function stat = FeedbackDisplay(accuracy, tiempo, stat)

    global hd
    global TEXT_SIZE_INST
    
    if accuracy == 0 % Sin respuesta
        texto = 'No se detectó respuesta.';
        color = [255 255 255]; % blanco
    elseif accuracy == 1 % Respuesta Correcta
        stat.correctas = stat.correctas + 1;
        stat.total = stat.total + 1;
        promedio = (stat.correctas / stat.total) * 100;
        texto = sprintf('¡Muy Bien!\nTiempo de respuesta: %.3f segundos\nPromedio de respuestas correctas: %.1f %%', tiempo, promedio);
        color = [0 0 255]; % azul
    else % Respuesta incorrecta
        stat.total = stat.total + 1;
        promedio = (stat.correctas / stat.total) * 100;
        texto = sprintf('INCORRECTO\nTiempo de respuesta: %.3f segundos\nPromedio de respuestas correctas: %.1f %%', tiempo, promedio);
        color = [255 0 0]; % rojo
    end
    TextoCentrado(texto, TEXT_SIZE_INST, color);
    Screen('Flip', hd.window);    
    WaitSecs(1.5);

end