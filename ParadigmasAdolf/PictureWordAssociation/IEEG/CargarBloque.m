function bloque_actual = CargarBloque(data_dir)

    bloque_actual.estimulos = CargarEstimulos(fullfile(data_dir, 'estimulos.csv'));
    bloque_actual.instrucciones = CargarTextosDeCarpeta(fullfile(data_dir, 'instrucciones'));
    bloque_actual.practica_texturas = CargarTexturasDeCarpeta(fullfile(data_dir, 'practica'));
    bloque_actual.bloque_texturas = CargarTexturasDeCarpeta(fullfile(data_dir, 'bloque'));
    
end