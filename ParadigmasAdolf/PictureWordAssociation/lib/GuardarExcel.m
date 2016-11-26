function GuardarExcel(celda_log, archivo_nombre)


    warning('off','xlwrite:AddSheet');
    for i = 1:length(celda_log)
        
        pagina = ['Bloque ' int2str(i)];
        xlwrite([archivo_nombre '.xls'], celda_log{i}, pagina, 'A1');
        
    end


end