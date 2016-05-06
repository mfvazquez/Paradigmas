function CentrarVista(duracion)

    global hd;

    textoCentrado('+');
    Screen('Flip', hd.window);
    WaitSecs(duracion);

end