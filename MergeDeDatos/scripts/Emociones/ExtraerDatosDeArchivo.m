function datos = ExtraerDatosDeArchivo(archivo_log, dir_log)

    ALTO = 1;
    BAJO = 0;    
    
    estimulos_insatisfaccion = {'merecimiento' 'merecimiento' 'neutral' 'legal' 'moral' 'neutral' 'legal' 'neutral' 'moral' 'merecimiento' 'moral' 'merecimiento' 'legal' 'moral' 'neutral' 'merecimiento' 'legal' 'neutral' 'moral' 'legal'};
    estimulos_satisfaccion = {'legal' 'neutral' 'merecimiento' 'legal' 'moral' 'neutral' 'merecimiento' 'moral' 'moral' 'legal' 'neutral' 'merecimiento' 'merecimiento' 'neutral' 'moral' 'moral' 'legal' 'merecimiento' 'legal' 'neutral'};
    
    version = ObtenerVersion(archivo_log);

    perfiles = ObtenerPerfiles(version);
    
    log = load(fullfile(dir_log, archivo_log));
    log_insatisfaccion = log.log_envidia;
    log_satisfaccion = log.log_schan;
    
    insatisfaccion.alto = ExtraerDatosDeLog(log_insatisfaccion, estimulos_insatisfaccion, perfiles, ALTO);
    insatisfaccion.bajo = ExtraerDatosDeLog(log_insatisfaccion, estimulos_insatisfaccion, perfiles, BAJO);
    insatisfaccion.todo = ExtraerDatosDeLog(log_insatisfaccion, estimulos_insatisfaccion, [], []);
    
    satisfaccion.alto = ExtraerDatosDeLog(log_satisfaccion, estimulos_satisfaccion, perfiles, ALTO);
    satisfaccion.bajo = ExtraerDatosDeLog(log_satisfaccion, estimulos_satisfaccion, perfiles, BAJO);
    satisfaccion.todo = ExtraerDatosDeLog(log_satisfaccion, estimulos_satisfaccion, [], []);
    
    datos.satisfaccion = satisfaccion;
    datos.insatisfaccion = insatisfaccion;

end