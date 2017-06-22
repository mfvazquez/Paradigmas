function EnviarMarca(marca)

    global pportobj pportaddr MARCA_DURACION EEG
    if EEG
        io32(pportobj,pportaddr, marca);
        WaitSecs(MARCA_DURACION);
        io32(pportobj,pportaddr,0);
    end

end