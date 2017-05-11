clear all

permutaciones = perms(['A' 'B' 'C' 'D']);
[fil, col] = size(permutaciones);

for i = 1:fil
    bloque.emociones = permutaciones(i,:);
    bloque.intero = {'motor' 'intero' 'motor' 'intero'};
    bloque.contador = 0;
    bloque.emociones_duraciones = [0.1 1 0.1 1];    
    secuencias(i*4-3) = bloque;
    
    bloque.intero = {'intero' 'motor' 'intero' 'motor'};
    secuencias(i*4-2) = bloque;
    
    bloque.emociones_duraciones = [1 0.1 1 0.1];    
    secuencias(i*4-1) = bloque;
    
    bloque.intero = {'motor' 'intero' 'motor' 'intero'};
    secuencias(i*4) = bloque;
end

save('secuencias.mat', 'secuencias');



% % % % para ordenar:
% % % secuencias(5).contador = 5;
% % % secuencias(10).contador = 1;
% % % secuencias(15).contador = 8;
% % % [~,IX] = sort([secuencias.contador]);
% % % secuencias_ordenadas = secuencias(IX);
