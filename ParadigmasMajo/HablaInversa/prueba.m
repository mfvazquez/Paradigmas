addpath('lib')

audio = wavread(fullfile('data','1_RPD','P1_REP_DIRECTA_0male.wav'))

clear
recObj = audiorecorder(44100, 16, 1);
recObj.record;
WaitSecs(0.2);
tiempos.duracion = 5;
tiempos.silencio = 0.3;
[exit, grabacion] = PresentarGrabacion([], '', tiempos, recObj, [])

tiempo = 1:length(grabacion.canal);
tiempo = tiempo./44100;

figure
plot(tiempo, grabacion.canal)
hold on
stem(grabacion.hablo_t-grabacion.inicio_t, 0.1, 'r');

momento = grabacion.hablo_t - grabacion.inicio_t