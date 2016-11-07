function GuardarExcel(log, carpeta)

    loadPOI;
    warning('off','xlwrite:AddSheet');
    
    archivo = [log.nombre '_Insatisfaccion.xls'];
    archivo = fullfile(carpeta, archivo);
    DividirEnHojas(log.insatisfaccion.todo, archivo, 'todo');
    DividirEnHojas(log.insatisfaccion.bajo, archivo, 'bajo');
    DividirEnHojas(log.insatisfaccion.alto, archivo, 'alto');
    
    archivo = [log.nombre '_Satisfaccion.xls'];
    archivo = fullfile(carpeta, archivo);
    DividirEnHojas(log.satisfaccion.todo, archivo, 'todo');
    DividirEnHojas(log.satisfaccion.bajo, archivo, 'bajo');
    DividirEnHojas(log.satisfaccion.alto, archivo, 'alto');


end