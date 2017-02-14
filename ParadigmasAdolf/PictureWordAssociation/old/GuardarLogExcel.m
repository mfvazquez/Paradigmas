function GuardarLogExcel(log, nombre)

    loadPOI;
    celda_log = cell(length(log), 1);
    for j = 1:length(log)
        celda_log{j} = Log2Cell(log{j});
    end
    GuardarExcel(celda_log, nombre);

end