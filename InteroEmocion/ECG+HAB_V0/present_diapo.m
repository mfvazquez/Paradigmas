function present_diapo(diapo)

global hd;

textureIndex=Screen('MakeTexture', hd.window, diapo);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

end

