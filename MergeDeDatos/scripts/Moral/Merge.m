clear all

ACCIDENTAL = 0;
INTENCIONAL = 1;

LS1 = [ 1	0	0	1	0	1	0	0	1	1	1	1	0	0	1	0	1	1	1	0	0	1	0	0 ];
LS2 = [ 0	1	1	0	1	0	1	1	0	0	0	0	1	1	0	1	0	0	0	1	1	0	1	1 ];
LG1	= [ 1	0	0	1	0	1	0	0	1	1	1	1	0	0	1	0	1	1	1	0	0	1	0	0 ];
LG2	= [ 0	1	1	0	1	0	1	1	0	0	0	0	1	1	0	1	0	0	0	1	1	0	1	1 ];


controles_dir = fullfile('logs','Controles');
controles_arch = ArchivosDeCarpeta(controles_dir);
controles = OrganizarDatos(controles_arch);
moral.controles = ObtenerDatosTotales(controles, controles_dir);

pacientes_dir = fullfile('logs','Pacientes');
pacientes_arch = ArchivosDeCarpeta(pacientes_dir);
pacientes = OrganizarDatos(pacientes_arch);
moral.pacientes = ObtenerDatosTotales(pacientes, pacientes_dir);

save('moral.mat', 'moral');