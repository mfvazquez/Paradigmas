clear all

permutaciones = perms(['A' 'B']);
[fil, col] = size(permutaciones);

for i = 1:fil
    bloque.emociones = permutaciones(i,:);
    bloque.intero = {'motor' 'intero'};
    bloque.contador = 0;
    secuencias(i*2-1) = bloque;
    bloque.intero = {'intero' 'motor'};
    secuencias(i*2) = bloque;
end

save('secuencias.mat', 'secuencias');



% % % % para ordenar:
% % % secuencias(5).contador = 5;
% % % secuencias(10).contador = 1;
% % % secuencias(15).contador = 8;
% % % [~,IX] = sort([secuencias.contador]);
% % % secuencias_ordenadas = secuencias(IX);
