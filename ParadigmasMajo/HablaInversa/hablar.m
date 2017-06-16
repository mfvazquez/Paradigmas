freq = 44100;
triggerlevel = 0.1;
tiempos.duracion_grabacion = 5;
tiempos.duracion_silencio = 0.2;

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

hd.rec = PsychPortAudio('Open', hd.outdevice, 2, 1, 44100, 1);
PsychPortAudio('GetAudioData', hd.rec, 10);


PsychPortAudio('Start', hd.rec);
tstart = GetSecs;


continuar = true;
seguir = true;
audio = zeros(1, freq*tiempos.duracion_grabacion);
id_start = 1;
while continuar
    
    WaitSecs(0.01);
    
    
    [audiodata, ~, ~, tCaptureStart]= PsychPortAudio('GetAudioData', hd.rec);
    audio(id_start:length(audiodata) + id_start - 1) = audiodata;
    id_start = length(audiodata) + id_start;
    
    if GetSecs - tstart >= tiempos.duracion_grabacion
        continuar = false;
        seguir = false;
    end
    
    idx = find(abs(audiodata) >= triggerlevel, 1, 'first' );
    if ~isempty(idx)
        continuar = false;
    end
end


while seguir
    if GetSecs - tstart + tiempos.duracion_silencio >= tiempos.duracion_grabacion
        WaitSecs(tiempos.duracion_grabacion - (GetSecs - tstart));
    else
        WaitSecs(tiempos.duracion_silencio);
    end
    
    [audiodata, ~, ~, tCaptureStart]= PsychPortAudio('GetAudioData', hd.rec);
    audio(id_start:length(audiodata) + id_start - 1) = audiodata;
    id_start = length(audiodata) + id_start;
    
    if GetSecs - tstart >= tiempos.duracion_grabacion
        seguir = false;
    end
    
    idx = find(abs(audiodata) >= triggerlevel, 1, 'first' );
    if isempty(idx)
        seguir = false;
    end
    
end

grabacion.audio = audio(1:id_start-1);
grabacion.id_hablo = find(abs(audio) >= triggerlevel, 1, 'first');
grabacion.inicio_t = tstart;
grabacion.hablo_t = grabacion.id_hablo/freq;

PsychPortAudio('Stop', hd.rec);
PsychPortAudio('Close', hd.rec);

sound(grabacion.audio(id_hablo:end), freq)
length(grabacion.audio)/freq

figure
plot(grabacion.audio);
hold on
stem(id_hablo, triggerlevel, 'r');



sound(log.datos{1}.trials{4}.grabacion.audio,44100)
