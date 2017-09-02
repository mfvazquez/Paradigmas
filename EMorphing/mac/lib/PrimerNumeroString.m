function numero = PrimerNumeroString(texto)

    subs_numero = isstrprop(texto, 'digit');
    n = 1;
    while subs_numero(n)
        n = n+1;
    end
    numero_str = texto(1:n-1);
    numero = str2double(numero_str);

end