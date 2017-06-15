% BasicSoundInputDemo('caca.wav', 1, 5)
% 
% 
% SimpleVoiceTriggerDemo(0.001)
% 
% 
% PsychPortAudioTimingTest
% AudioFeedbackLatencyTest

clear
triggerlevel = 0.1;
freq = 44100;

recObj = audiorecorder(freq, 16, 1);


recObj.record;
WaitSecs(0.5);
tstart = GetSecs;
idstart = length(recObj.getaudiodata);
WaitSecs(5);
recObj.pause;

idx = min(find(abs(recObj.getaudiodata) >= triggerlevel)); %#ok<MXFND>

tiempo = 1:length(recObj.getaudiodata);
tiempo = tiempo./recObj.SampleRate;

figure(1)
plot(tiempo, recObj.getaudiodata)
hold on
stem((idx)/recObj.SampleRate, triggerlevel, 'r');
hold on
stem(idstart/recObj.SampleRate, triggerlevel, 'r');


% play(recObj);

canal = recObj.getaudiodata;
sound(canal(idx:end), freq);

% Any response?
if isempty(idx)
    fprintf('No response at all within 5 seconds?!?\n\n');
else
    % Compute absolute event time:
    tOnset = tCaptureStart + ((offset + idx - 1) / freq);