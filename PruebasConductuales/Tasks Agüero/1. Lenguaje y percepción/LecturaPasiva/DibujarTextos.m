function DibujarTextos(textos, rectangulos)

    global hd

    for i = 1:length(textos)
       
        DrawFormattedText(hd.window, textos{i}, 'justifytomax', 'center', hd.white, [], [], [], 1.5, [], rectangulos{i});
        
    end

end