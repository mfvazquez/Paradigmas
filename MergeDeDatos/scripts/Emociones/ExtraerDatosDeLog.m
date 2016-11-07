function datos = ExtraerDatosDeLog(log, perfiles, seleccionado, referencia, estimulos)

    datos.total = CeldasVacias();
    datos.merecimiento = CeldasVacias();
    datos.neutral  = CeldasVacias();
    datos.legal = CeldasVacias();
    datos.moral = CeldasVacias();

    for i = 1:length(log.estimulo_inicio)
        
        if ~isempty(perfiles) && perfiles(i) ~= seleccionado
            continue
        end
        
        datos.total = AgregarDatos(log, referencia, i, datos.total);
        
        
        
        if strcmp(estimulos{i}, 'merecimiento')
            datos.merecimiento = AgregarDatos(log, referencia, i, datos.merecimiento);
        elseif strcmp(estimulos{i}, 'neutral')
            datos.neutral = AgregarDatos(log, referencia, i, datos.neutral);
        elseif strcmp(estimulos{i}, 'legal')
            datos.legal = AgregarDatos(log, referencia, i, datos.legal);            
        elseif strcmp(estimulos{i}, 'moral')
            datos.moral = AgregarDatos(log, referencia, i, datos.moral);            
        end
        
    end
    
end