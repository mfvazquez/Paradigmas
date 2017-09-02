% 108;B;A-B;NS
% 361;A;A-B;NS
% 503;A;A-B;NS
% 740;B;A-B;NS
% 452;A;A-B;NS
clc
clear

addpath('lib');

datos = CargarCSV('datos_crudos.csv',';');
N_ciclos = 4;
N_bloques = 6;
N_trials = 4;
ciclos_col = 6:11;
tipo_bloque_col = 2;
numero_col = 1;
respuesta_col = 4;
orden_col = 5;

for x = 1:N_bloques
    sub_bloque = datos((x-1)*N_trials+1:x*N_trials,:)
    for y = ciclos_col
%        
%         [B, I] = sort(sub_bloque(:,y));
%         ordenado = sub_bloque(I,:);
        
        orden = sub_bloque(:,y);
        respuestas = cell(length(orden),1);
        for z = 1:length(orden)
            for w = 1:length(sub_bloque(:,1))
                if strcmp(orden{z}, sub_bloque{w,1})
                    respuestas{z} = sub_bloque{w,4};
                end
            end
        end

        ciclo = [orden respuestas sub_bloque(:,5) sub_bloque(:,2)]
        [fil, col] = size(ciclo);
        nombre_archivo = [num2str(y-5) '.dat'];
        archivo = fullfile('data','bloques',sub_bloque{1,2},'ciclos', nombre_archivo);
        fid = fopen(archivo, 'w');
        
        for i = 1:fil
            for j = 1:col
                if j == col
                    fprintf(fid, '%s',ciclo{i,j});
                else
                    fprintf(fid, '%s;',ciclo{i,j});    
                end
            end
            fprintf(fid, '\n');
        end
        fclose(fid);
        
    end
end