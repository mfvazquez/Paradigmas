edit testpc
c = 1;
seguir = evalin('base','seguir');
while seguir
    A(c) = GetSecs;
    WaitSecs(0.1);
    c = c+1;
    seguir = evalin('base','seguir');
end