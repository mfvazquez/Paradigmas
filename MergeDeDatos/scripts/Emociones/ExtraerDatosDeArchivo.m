function datos = ExtraerDatosDeArchivo(archivo_log, dir_log)

    ALTO = 1;
    BAJO = 0;    
    
    estimulos_insatisfaccion = {'merecimiento' 'merecimiento' 'neutral' 'legal' 'moral' 'neutral' 'legal' 'neutral' 'moral' 'merecimiento' 'moral' 'merecimiento' 'legal' 'moral' 'neutral' 'merecimiento' 'legal' 'neutral' 'moral' 'legal'};
    estimulos_satisfaccion = {'legal' 'neutral' 'merecimiento' 'legal' 'moral' 'neutral' 'merecimiento' 'moral' 'moral' 'legal' 'neutral' 'merecimiento' 'merecimiento' 'neutral' 'moral' 'moral' 'legal' 'merecimiento' 'legal' 'neutral'};
    
    version = ObtenerVersion(archivo_log);
    datos.nombre = archivo_log(1:end-4);

    perfiles = ObtenerPerfiles(version);
    
    log = load(fullfile(dir_log, archivo_log));
    log_insatisfaccion = log.log_envidia;
    log_satisfaccion = log.log_schan;
    
    insatisfaccion.alto = ExtraerDatosDeLog(log_insatisfaccion, perfiles, ALTO, log_insatisfaccion.estimulo_inicio{1}, estimulos_insatisfaccion);
    insatisfaccion.bajo = ExtraerDatosDeLog(log_insatisfaccion, perfiles, BAJO, log_insatisfaccion.estimulo_inicio{1}, estimulos_insatisfaccion);
    insatisfaccion.todo = ExtraerDatosDeLog(log_insatisfaccion, [], [], log_insatisfaccion.estimulo_inicio{1}, estimulos_insatisfaccion);
    
    satisfaccion.alto = ExtraerDatosDeLog(log_satisfaccion, perfiles, ALTO, log_insatisfaccion.estimulo_inicio{1}, estimulos_satisfaccion);
    satisfaccion.bajo = ExtraerDatosDeLog(log_satisfaccion, perfiles, BAJO, log_insatisfaccion.estimulo_inicio{1}, estimulos_satisfaccion);
    satisfaccion.todo = ExtraerDatosDeLog(log_satisfaccion, [], [], log_insatisfaccion.estimulo_inicio{1}, estimulos_satisfaccion);
    
    datos.satisfaccion = satisfaccion;
    datos.insatisfaccion = insatisfaccion;

end