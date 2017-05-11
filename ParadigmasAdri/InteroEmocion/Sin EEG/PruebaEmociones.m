clc;
sca;
close all;
clearvars;

addpath('lib');

global TAMANIO_TEXTO
global EEG


EEG = false;

TAMANIO_TEXTO = 0.05;


KbName('UnifyKeyNames');
teclas.ExitKey = KbName('ESCAPE');
teclas.botones_salteado = [KbName('P') KbName('Q')];
teclas.UpKey = KbName('UpArrow');
teclas.DownKey = KbName('DownArrow');
teclas.EnterKey = KbName('return');

emociones = {'Enojo' 'Felicidad' 'Tristeza' 'Sorpresa' 'Neutral' 'Asco'};
subindices = randperm(length(emociones));
emociones = emociones(subindices);

hd = init_psych;

[log, exit, saltear] = ElegirOpcionVertical(hd, emociones, teclas, 3);

Salir(hd);