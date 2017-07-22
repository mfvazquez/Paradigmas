clear all

secuencias = perms(['A' 'B' 'C' 'D']);

contador = containers.Map();

for x = 1:size(secuencias,1)
    contador(secuencias(x,:)) = 0;
end

save('secuencias.mat', 'secuencias', 'contador');



% % % % para ordenar:
% % % secuencias(5).contador = 5;
% % % secuencias(10).contador = 1;
% % % secuencias(15).contador = 8;
% % % [~,IX] = sort([secuencias.contador]);
% % % secuencias_ordenadas = secuencias(IX);
