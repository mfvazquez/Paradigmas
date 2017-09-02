function texto_sin_numeros = QuitarNumeros(texto)

    subs = isstrprop(texto, 'alpha');
    texto_sin_numeros = texto(subs);

end