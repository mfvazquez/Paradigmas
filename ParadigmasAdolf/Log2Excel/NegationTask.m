clear

addpath('lib');
addpath(fullfile('lib','xlwrite','xlwrite'));
addpath(fullfile('lib','strings'));

loadPOI;

carpeta = fullfile('log_negation'); % CARPETA EN DODNE ESTAN GUARDADOS LOS ARCHIVOS .mat

archivos = dir(carpeta);
archivos(1) = [];
archivos(1) = [];

warning('off','xlwrite:AddSheet');

for x = 1:length(archivos)

    archivo_actual = fullfile(carpeta, archivos(x).name);
    load(archivo_actual)
    
    for i = 1:length(log)

        pagina = ['Bloque ' int2str(i)];
        bloque = log{i};
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('fijacion'), pagina, 'A1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('fijacion_tiempo'), pagina, 'B1');
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S1'), pagina, 'C1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S1_tiempo'), pagina, 'D1');
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S2'), pagina, 'E1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S2_tiempo'), pagina, 'F1');
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S3.1'), pagina, 'G1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S3.1_tiempo'), pagina, 'H1');
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S3.2_circulo'), pagina, 'I1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S3.2_tiempo'), pagina, 'J1');
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S3.3'), pagina, 'K1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S3.3_tiempo'), pagina, 'L1');
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S4'), pagina, 'M1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S4_tiempo'), pagina, 'N1');
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S5'), pagina, 'O1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S5_tiempo'), pagina, 'P1');
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S6'), pagina, 'Q1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S6_tiempo'), pagina, 'R1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('S6_tiempo_pregunta'), pagina, 'S1');
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('pregunta_tiempo'), pagina, 'T1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('pregunta_accuracy'), pagina, 'U1');
        
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('respuesta_amarillo_absoluto'), pagina, 'V1');
        xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr('respuesta_amarillo_relativo'), pagina, 'W1');
        
        for j = 1:length(bloque)
            trial = bloque{j};
                        
            xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr(trial.secuencia{1}), pagina, ['A' num2str(j+1)]);
            xlwrite( [archivo_actual(1:end-4) '.xls'], trial.estimulo{1}, pagina, ['B' num2str(j+1)]);
            
            xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr(trial.secuencia{2}), pagina, ['C' num2str(j+1)]);
            xlwrite( [archivo_actual(1:end-4) '.xls'], trial.estimulo{2}, pagina, ['D' num2str(j+1)]);
            
            xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr(trial.secuencia{3}), pagina, ['E' num2str(j+1)]);
            xlwrite( [archivo_actual(1:end-4) '.xls'], trial.estimulo{3}, pagina, ['F' num2str(j+1)]);
            
            xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr(trial.secuencia{4}), pagina, ['G' num2str(j+1)]);
            xlwrite( [archivo_actual(1:end-4) '.xls'], trial.estimulo{4}(1), pagina, ['H' num2str(j+1)]);
            
            xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr(trial.secuencia{4}), pagina, ['I' num2str(j+1)]);
            xlwrite( [archivo_actual(1:end-4) '.xls'], trial.estimulo{4}(2), pagina, ['J' num2str(j+1)]);
            
            xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr(trial.secuencia{4}), pagina, ['K' num2str(j+1)]);
            xlwrite( [archivo_actual(1:end-4) '.xls'], trial.estimulo{4}(3), pagina, ['L' num2str(j+1)]);
            
            xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr(trial.secuencia{5}), pagina, ['M' num2str(j+1)]);
            xlwrite( [archivo_actual(1:end-4) '.xls'], trial.estimulo{5}, pagina, ['N' num2str(j+1)]);
            
            xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr(trial.secuencia{6}), pagina, ['O' num2str(j+1)]);
            xlwrite( [archivo_actual(1:end-4) '.xls'], trial.estimulo{6}, pagina, ['P' num2str(j+1)]);
            
            xlwrite( [archivo_actual(1:end-4) '.xls'], cellstr(trial.secuencia{7}), pagina, ['Q' num2str(j+1)]);
            xlwrite( [archivo_actual(1:end-4) '.xls'], trial.estimulo{7}(1), pagina, ['R' num2str(j+1)]);
            xlwrite( [archivo_actual(1:end-4) '.xls'], trial.estimulo{7}(2), pagina, ['S' num2str(j+1)]);
            
            if ~isempty(trial.respuesta.tiempo)
                xlwrite( [archivo_actual(1:end-4) '.xls'], num2cell(trial.respuesta.tiempo), pagina, ['T' num2str(j+1)]);            
                xlwrite( [archivo_actual(1:end-4) '.xls'], num2cell(trial.respuesta.accuracy), pagina, ['U' num2str(j+1)]);
            end
            
            if ~isempty(trial.respuesta.tiempo)
                xlwrite( [archivo_actual(1:end-4) '.xls'], num2cell(trial.amarillo.absoluto), pagina, ['V' num2str(j+1)]);
                xlwrite( [archivo_actual(1:end-4) '.xls'], num2cell(trial.amarillo.relativo), pagina, ['W' num2str(j+1)]);
            end
            
            
        end



    end
end