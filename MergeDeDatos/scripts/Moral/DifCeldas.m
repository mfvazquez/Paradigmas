function diferencia = DifCeldas(minuendo, sustraendo)

    for i = 1:length(minuendo)
        
        minuendo_valor = minuendo{i};
        sustraendo_valor = sustraendo{i};
        if isempty(minuendo_valor) || isempty(sustraendo_valor)
            return
        end
        diferencia(i) = minuendo_valor - sustraendo_valor;
        
    end

end