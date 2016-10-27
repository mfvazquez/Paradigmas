function vector = EstimulosVersion(version)

    LS1 = [ 1	0	0	1	0	1	0	0	1	1	1	1	0	0	1	0	1	1	1	0	0	1	0	0 ];
    LS2 = [ 0	1	1	0	1	0	1	1	0	0	0	0	1	1	0	1	0	0	0	1	1	0	1	1 ];
    LG1	= [ 1	0	0	1	0	1	0	0	1	1	1	1	0	0	1	0	1	1	1	0	0	1	0	0 ];
    LG2	= [ 0	1	1	0	1	0	1	1	0	0	0	0	1	1	0	1	0	0	0	1	1	0	1	1 ];
    
    vector = [];
    if strcmp(version, 'Lenguaje Grafico 1')
        vector = LG1;
    elseif strcmp(version, 'Lenguaje Grafico 2')
        vector = LG2;
    elseif strcmp(version, 'Lenguaje Simple 1')
        vector = LS1;
    elseif strcmp(version, 'Lenguaje Simple 2')
        vector = LS2;
    end

end