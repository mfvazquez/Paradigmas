clear all;
addpath('lib');

archivos = ArchivosDeCarpeta(fullfile('data','emociones', 'imagenes'));

negativas = { 'Ang' 'Dis' 'Fea' 'Sad' };

continuar = true;



while continuar

    subindices = randperm(length(archivos));
    archivos = archivos(subindices);
    
    continuar = false;
    
    for x = 1:length(archivos)-2
        
        aux = archivos(x:x+2);
        generos = [aux{1}(1) aux{2}(1) aux{3}(1)];
        if generos(1) == generos(2) && generos(2) == generos(3)
            continuar = true;
            break
        end
    end

    for x = 1:length(archivos)-3
    
        aux = archivos(x:x+3);
        emociones = {aux{1}(5:7) aux{2}(5:7) aux{3}(5:7) aux{4}(5:7)};
        contador = 0;
        for y = 1:length(negativas)
            for z = 1:length(emociones)
                if strcmp(negativas{y}, emociones{z})
                    contador = contador + 1;
                end
            end
        end
        
        if contador > 3
            continuar = true;
            break;
        end
        
    end

end

archivos'

archivosA = archivos;
continuar = true;

while continuar

    subindices = randperm(length(archivos));
    archivos = archivos(subindices);
    
    continuar = false;
    
    for x = 1:length(archivos)-2
        
        aux = archivos(x:x+2);
        generos = [aux{1}(1) aux{2}(1) aux{3}(1)];
        if generos(1) == generos(2) && generos(2) == generos(3)
            continuar = true;
            break
        end
    end

    for x = 1:length(archivos)-3
    
        aux = archivos(x:x+3);
        emociones = {aux{1}(5:7) aux{2}(5:7) aux{3}(5:7) aux{4}(5:7)};
        contador = 0;
        for y = 1:length(negativas)
            for z = 1:length(emociones)
                if strcmp(negativas{y}, emociones{z})
                    contador = contador + 1;
                end
            end
        end
        
        if contador > 3
            continuar = true;
            break;
        end
        
    end

end