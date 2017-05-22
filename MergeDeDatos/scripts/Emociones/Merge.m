clear all

addpath('lib');
addpath(fullfile('lib','xlwrite','xlwrite'));
addpath(fullfile('lib','strings'));

pacientes_dir = fullfile('logs');
pacientes_arch = ArchivosDeCarpeta(pacientes_dir);


pacientes = cell(length(pacientes_arch),1);
for i = 1:length(pacientes_arch)
    pacientes{i} = ExtraerDatosDeArchivo(pacientes_arch{i}, pacientes_dir);
end


for x = 1:length(pacientes)
    GuardarExcel(pacientes{x}, fullfile('excel'));
end

logs.pacientes = pacientes;

save('logs.mat', 'logs');