function TextoAlineadoRect(texto, rect, hd, color, textSize)

    if nargin < 5
        textSize = rect(4) - rect(2);   
    end
    
    Screen('TextSize', hd.window, textSize);
    
    if nargin > 3
        DrawFormattedText(hd.window, texto, [],[], color, [], [], [], 1.5, [], rect);
    else
        DrawFormattedText(hd.window, texto, [],[], hd.white, [], [], [], 1.5, [], rect);
    end
    
end