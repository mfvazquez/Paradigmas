function GuardarExcel(datos, carpeta)

    loadPOI;
    warning('off','xlwrite:AddSheet');
    
    nombre_archivo = [datos.nombre '_' datos.version '.xls'];
    
    archivo = fullfile(carpeta, nombre_archivo);
    
    GuardarEnHoja(datos.totales, archivo, 'totales');
    GuardarEnHoja(datos.accidental, archivo, 'accidental');
    GuardarEnHoja(datos.intencional, archivo, 'intencional');
    

end