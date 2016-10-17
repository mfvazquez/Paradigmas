keySet = {    'N1'	    'N2'	    'N3'	    'N4'	    'N5'	    'N6'	    'N7'	    'N8'	    'N9'	    'N10'	'A1'	'A2'	'A3'	'A4'	'A5'	'A6'	'A7'	'A8'	'A9'	'A10'	'T1'	'T2'	'T3'	'T4'	'T5'	'T6'	'T7'	'T8'	'T9'	'T10'	'E1'	'E2'	'E3'	'E4'	'E5'	'E6'	'E7'	'E8'	'E9'	'E10'};
valueSet = {'MC01_NEU'	'MC02_NEU'	'MC03_NEU'	'MC04_NEU'	'MC05_NEU'	'MC06_NEU'	'MC07_NEU'	'MC08_NEU'	'MC09_NEU'	'MC10_NEU'	'MC01_HAP'	'MC02_HAP'	'MC03_HAP'	'MC04_HAP'	'MC05_HAP'	'MC06_HAP'	'MC07_HAP'	'MC08_HAP'	'MC09_HAP'	'MC10_HAP'	'MC01_SAD'	'MC02_SAD'	'MC03_SAD'	'MC04_SAD'	'MC05_SAD'	'MC06_SAD'	'MC07_SAD'	'MC08_SAD'	'MC09_SAD'	'MC10_SAD'	'MC01_ANG'	'MC02_ANG'	'MC03_ANG'	'MC04_ANG'	'MC05_ANG'	'MC06_ANG'	'MC07_ANG'	'MC08_ANG'	'MC09_ANG'	'MC10_ANG'};
map = containers.Map(keySet,valueSet);

%% CHEQUEA SI LOS ARCHIVOS EXISTEN
for x = 1:length(valueSet)
   
    nombre = [valueSet{x} '.JPG'];
    archivo = fullfile('data','imagenes',nombre);
    if exist(archivo, 'file') ~= 2
        fprintf('%s NO EXISTE\n', archivo);
    end
    
end

%% CARGO BLOQUES

bloques = dir(fullfile('data','bloques'));
bloques(1) = [];
bloques(1) = [];

% CHEQUEA SI LOS ARCHIVOS EXISTEN
for x = 1:length(bloques)
    
    str = fileread(fullfile('data','bloques',bloques(x).name));
    CStr = textscan(str, '%s', 'delimiter', '\n');
    CStr = CStr{1};
    
    for y = 1:length(CStr)

        archivo = [map(CStr{y}) '.JPG'];
        archivo = fullfile('data','imagenes',archivo);
        if exist(archivo, 'file') ~= 2
            fprintf('%s NO EXISTE\n', archivo);
        end
        
    end
    
end
