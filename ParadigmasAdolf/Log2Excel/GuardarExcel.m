function GuardarExcel(celda_log, archivo_nombre, carpeta_destino)


    warning('off','xlwrite:AddSheet');
    for i = 1:length(celda_log)
        
        pagina = ['Bloque ' int2str(i)];
        xlwrite(fullfile(carpeta_destino, [archivo_nombre '.xls']), celda_log{i}, pagina, 'A1');
        
    end


end