clear all

permutaciones = perms(['A' 'B' 'C' 'D']);
[fil, col] = size(permutaciones);

for i = 1:fil
    bloque.emociones = permutaciones(i,:);
    bloque.intero = {'motor' 'intero' 'motor' 'intero'};
    bloque.contador = 0;
    bloque.emociones_duraciones = [0.2 0.2 0.2 0.2];    
    secuencias(i*2-1) = bloque;
    
    bloque.intero = {'intero' 'motor' 'intero' 'motor'};
    secuencias(i*2) = bloque;
end

save('secuencias.mat', 'secuencias');



% % % % para ordenar:
% % % secuencias(5).contador = 5;
% % % secuencias(10).contador = 1;
% % % secuencias(15).contador = 8;
% % % [~,IX] = sort([secuencias.contador]);
% % % secuencias_ordenadas = secuencias(IX);
