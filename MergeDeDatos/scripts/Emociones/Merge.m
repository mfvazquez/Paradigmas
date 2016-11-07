clear all

addpath('lib');
addpath(fullfile('lib','xlwrite','xlwrite'));
addpath(fullfile('lib','strings'));

controles_dir = fullfile('logs','Controles');
controles_arch = ArchivosDeCarpeta(controles_dir);


pacientes_dir = fullfile('logs','Pacientes');
pacientes_arch = ArchivosDeCarpeta(pacientes_dir);


controles = cell(length(controles_arch),1);
for i = 1:length(controles_arch)
    controles{i} = ExtraerDatosDeArchivo(controles_arch{i}, controles_dir);
end


pacientes = cell(length(pacientes_arch),1);
for i = 1:length(pacientes_arch)
    pacientes{i} = ExtraerDatosDeArchivo(pacientes_arch{i}, pacientes_dir);
end


for x = 1:length(controles)
    GuardarExcel(controles{x}, fullfile('excel','controles'));
end

for x = 1:length(pacientes)
    GuardarExcel(pacientes{x}, fullfile('excel','pacientes'));
end

logs.controles = controles;
logs.pacientes = pacientes;



save('logs.mat', 'logs');