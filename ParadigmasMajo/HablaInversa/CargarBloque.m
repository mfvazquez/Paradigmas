function [instrucciones, estimulos, practica, mensaje_bloque] = CargarBloque(carpeta)


    %% INSTRUCCIONES
    instrucciones = CargarTextosDeCarpeta(fullfile(carpeta, 'instrucciones'));

    %% ESTIMULOS
    archivos = dir(fullfile(carpeta,'estimulos','*.txt'));
    if isempty(archivos)
        practica = CargarAudiosDeCarpeta(fullfile(carpeta, 'practica'));
        estimulos = CargarAudiosDeCarpeta(fullfile(carpeta, 'estimulos'));
    else
        practica = CargarArchivo(fullfile(carpeta,'practica', archivos(1).name));
        estimulos = CargarArchivo(fullfile(carpeta,'estimulos', archivos(1).name));        
    end
    
    %% MENSAJE BLOQUE
    mensaje_bloque = fileread(fullfile(carpeta, 'mensaje_bloque.txt'));

end