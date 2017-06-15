%% SECUENCIA

addpath('lib');

secuencia_elegida = 'R1-R2-R3-R4-L5-L6-L7-L8';
secuencia = strsplit(secuencia_elegida,'-');
log.secuencia = secuencia;

bloques = cell(length(secuencia),1);
instrucciones = cell(length(bloques),1);
for x = 1:length(bloques)
    [instrucciones{x}, bloque_actual.estimulos] = CargarBloque(fullfile('data',secuencia{x}));
    
    datos_bloque.audio = false;
    datos_bloque.texto = false;
    datos_bloque.duracion_texto = 0;
    datos_bloque.duracion_blanco = 0;
    datos_bloque.duracion_grabacion = 0;
    datos_bloque.duracion_silencio = 0;
    
    if strcmp(secuencia{x},'R1')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 3;
        datos_bloque.duracion_silencio = 0.2;
        
    elseif strcmp(secuencia{x},'R2')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 5;
        datos_bloque.duracion_silencio = 0.2;
        
    elseif strcmp(secuencia{x},'R3')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 7;
        datos_bloque.duracion_silencio = 0.3;
        
    elseif strcmp(secuencia{x},'R4')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 11;
        datos_bloque.duracion_silencio = 0.35;
        
    elseif strcmp(secuencia{x},'L5')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 0.4;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 5;
        datos_bloque.duracion_silencio = 0.2;
        
    elseif strcmp(secuencia{x},'L6')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 0.4;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 7;
        datos_bloque.duracion_silencio = 0.2;
        
    elseif strcmp(secuencia{x},'L7')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 2;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 10;
        datos_bloque.duracion_silencio = 0.3;
        
    elseif strcmp(secuencia{x},'L8')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 2;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 15;
        datos_bloque.duracion_silencio = 0.35;
        
    end
    
    bloque_actual.datos = datos_bloque;
    bloques{x} = bloque_actual;
    
end


InitializePsychSound

if PsychPortAudio('GetOpenDeviceCount') == 1
    PsychPortAudio('Close',0);
end

%Mac
if ismac
    audiodevices = PsychPortAudio('GetDevices');
    outdevice = strcmp('Built-in Output',{audiodevices.DeviceName});
    hd.outdevice = 1;
elseif ispc
    audiodevices = PsychPortAudio('GetDevices',3);
    if ~isempty(audiodevices)
        %DMX audio
        hd.outdevice = audiodevices(1).DeviceIndex;
    else
        %Windows default audio
        audiodevices = PsychPortAudio('GetDevices',2);
        hd.outdevice = BuscarDeviceOutput(audiodevices);

    end
else
    error('Unsupported OS platform!');
end

InitializePsychSound(1);

audio = bloques{1}.estimulos{1};

hd.master = PsychPortAudio('Open', hd.outdevice, 3+8, 1, 44100, 2);
PsychPortAudio('Start', hd.master, 0, 0, 1);
hd.play = PsychPortAudio('OpenSlave', hd.master, 1, 2, []);
hd.rec = PsychPortAudio('OpenSlave', hd.master, 2, 2, []);



PsychPortAudio('Volume', hd.play , 2);

PsychPortAudio('FillBuffer', hd.play, [audio.canal'; audio.canal']);    % Fill the audio playback buffer with the audio data 'wavedata':

inicio = PsychPortAudio('Start', hd.play, [], [], 1, [], []);
status = PsychPortAudio('GetStatus',hd.play);  % Me fijo si esta reproduciendo
while status.Active
    display asd
    status = PsychPortAudio('GetStatus',hd.play);
end
fin_audio = GetSecs;
PsychPortAudio('DeleteBsuffer');
PsychPortAudio('Stop', hd.play);


triggerlevel = 0.1;
freq = 44100;


PsychPortAudio('GetAudioData', hd.rec, 10);


PsychPortAudio('Start', hd.rec);
inicio_rec = GetSecs;
display habla
tstart = GetSecs;
WaitSecs(3);
[audiodata offset overflow tCaptureStart]= PsychPortAudio('GetAudioData', hd.rec);

PsychPortAudio('Stop', hd.rec);
PsychPortAudio('Stop', hd.master);
PsychPortAudio('Close', hd.rec);
PsychPortAudio('Close', hd.play);
PsychPortAudio('Close', hd.master);

sound(audiodata, freq)
length(audiodata)/freq

