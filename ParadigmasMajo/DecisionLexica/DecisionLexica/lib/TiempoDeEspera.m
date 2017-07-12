function tiempo = TiempoDeEspera(tiempos)

    if length(tiempos) == 1;
        tiempo = tiempos;
    else
        tiempo = tiempos(1) + (tiempos(2) - tiempos(1)) * rand;
    end

end