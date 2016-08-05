function MostrarMensaje(texto, size, window)
    TextoCentrado(texto, size);
    Screen('Flip', window);
    KbPressWait;
end