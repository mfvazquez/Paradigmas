function exit = PresentarInstrucciones(hd, textos, tamanio, teclas)

    for x = 1:length(textos)

        TextoCentrado(textos{x}, tamanio, hd);
        Screen('Flip', hd.window);
        exit = EsperarBoton(teclas.continuar, teclas.salir);
         if exit
            break
        end
    
    end

end