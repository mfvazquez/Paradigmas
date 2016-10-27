function EnviarMarca(marca)

    global pportobj pportaddr MARCA_DURACION

    io32(pportobj,pportaddr, marca);
    WaitSecs(MARCAS.DURACION);
    io32(pportobj,pportaddr,0);

end