
clear all

audiodevices = PsychPortAudio('GetDevices',3);
hd.outdevice = audiodevices(1).DeviceIndex;


triggerlevel = 0.1;
freq = 44100;
audio = [];

InitializePsychSound(1);
pahandle = PsychPortAudio('Open', hd.outdevice, 2, [], freq, 1);

PsychPortAudio('GetAudioData', pahandle, 10);
% WaitSecs(1)

PsychPortAudio('Start', pahandle);
display habla
tstart = GetSecs;

WaitSecs(5);
[audiodata offset overflow tCaptureStart]= PsychPortAudio('GetAudioData', pahandle);

    
% while GetSecs - tstart < 5
%     [audiodata offset overflow tCaptureStart]= PsychPortAudio('GetAudioData', pahandle);
%     length(audiodata)
%     audio = [audio audiodata];
% end



PsychPortAudio('Stop', pahandle);
PsychPortAudio('Close', pahandle);

length(audiodata)/freq


hd.pahandle = PsychPortAudio('Open', hd.outdevice, 1, 1, 44100, 2);
PsychPortAudio('Volume', hd.pahandle , 20);

PsychPortAudio('FillBuffer', hd.pahandle, [audiodata; audiodata]);

PsychPortAudio('Start', hd.pahandle);
tstart = GetSecs;
status = PsychPortAudio('GetStatus',hd.pahandle);

while status.Active
    display asd
    status = PsychPortAudio('GetStatus',hd.pahandle);
end
tend = GetSecs;
PsychPortAudio('DeleteBuffer');

