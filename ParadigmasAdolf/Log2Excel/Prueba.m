clear

addpath('lib');
addpath(fullfile('lib','xlwrite','xlwrite'));
addpath(fullfile('lib','strings'));

loadPOI;

carpeta = fullfile('log'); % CARPETA EN DODNE ESTAN GUARDADOS LOS ARCHIVOS .mat

% La primer carpeta es el origen donde estan los .mat, y la 2da es la carpeta en la que queres guardarlos
celda_log = Log2Excel(carpeta, carpeta); 
