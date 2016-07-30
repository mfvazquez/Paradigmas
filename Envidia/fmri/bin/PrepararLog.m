function log = PrepararLog(bloque)

    largo = length(bloque.situaciones);

    log.personaje = cell(1, largo);
    log.estimulo_inicio = cell(1, largo);
    log.estimulo_fin = cell(1, largo);
 
    log.opciones_inicio = cell(1, largo);
    log.opciones_fin = cell(1, largo);    
    log.respuesta = cell(1, largo);       
    log.opciones_PrimerMovimiento = cell(1, largo);
    
end