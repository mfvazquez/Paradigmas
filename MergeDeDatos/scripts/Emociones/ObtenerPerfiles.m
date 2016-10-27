function perfiles = ObtenerPerfiles(version)

    masculinoA = [	1	1	0	0	0	0	0	1	1	1	0	0	0	1	0	0	1	1	1	1];
    masculinoB = [	0	0	1	1	1	1	1	0	0	0	1	1	1	0	1	1	0	0	0	0];
    femeninoA = [	1	1	0	0	0	0	0	1	1	1	0	0	0	1	0	0	1	1	1	1];
    femeninoB = [	0	0	1	1	1	1	1	0	0	0	1	1	1	0	1	1	0	0	0	0];

    perfiles = [];
    if strcmp(version, 'masculinoA')
        perfiles = masculinoA;
    elseif strcmp(version, 'masculinoB')
        perfiles = masculinoB;
    elseif strcmp(version, 'femeninoA')
        perfiles = femeninoA;
    elseif strcmp(version, 'femeninoB')
        perfiles = femeninoB;
    end
    
end