s = serial('COM3','BaudRate',38400);
fopen(s);
A = fscanf(s, '%c', 1);
B = fscanf(s, '%c', 1);
C = fscanf(s, '%c', 1);
D = fscanf(s, '%c', 1);
fclose(s);

A
uint8(B)
C
uint8(D)