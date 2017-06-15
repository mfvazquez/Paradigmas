InitializePsychSound

if PsychPortAudio('GetOpenDeviceCount') == 1
    PsychPortAudio('Close',0);
end

%Mac
if ismac
    audiodevices = PsychPortAudio('GetDevices');
    outdevice = strcmp('Built-in Output',{audiodevices.DeviceName});
    hd.audiodevice = 1;
elseif ispc
    audiodevices = PsychPortAudio('GetDevices',3);
    if ~isempty(audiodevices)
        %DMX audio
        hd.audiodevice = audiodevices(1).DeviceIndex;
    else
        Windows default audio
        audiodevices = PsychPortAudio('GetDevices',2);
        hd.audiodevice = BuscarDeviceOutput(audiodevices);

    end
else
    error('Unsupported OS platform!');
end

InitializePsychSound(1);


triggerlevel = 0.1;
freq = 44100;


pahandle = PsychPortAudio('Open', hd.audiodevice, 2, 1, freq, 2);




PsychPortAudio('GetAudioData', pahandle, 10);
% WaitSecs(1)

PsychPortAudio('Start', pahandle);
display habla
tstart = GetSecs;
WaitSecs(3);
[audiodata offset overflow tCaptureStart]= PsychPortAudio('GetAudioData', pahandle);

PsychPortAudio('Stop', pahandle);
PsychPortAudio('Close', pahandle);

sound(audiodata, freq)
length(audiodata)/freq