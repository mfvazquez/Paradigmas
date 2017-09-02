for x = 1:6
    [~, keyCode, ~] = KbPressWait;
    boton = find(keyCode==1);
    display(x)
    display(boton)

end