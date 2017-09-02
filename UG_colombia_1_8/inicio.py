#!/usr/bin/env python2
# -*- coding: utf-8 -*-
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui
#import psychopy.log #import like this so it doesn't interfere with numpy.log
import math
#from scipy.stats import norm
from random import shuffle, randint, random
from UG_receptor import *
from win32api import GetSystemMetrics

#-----  Settings ---  see also ALL_games.py (button settings)
# For repeteated games 
t_e_p = 2  # for the test trials 
t_e_r = 15 # for the real trails 

FS=True


#store info about the experiment

expName ='UG'#
expInfo={'Participante':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#

# MENSAJE INICIAL

win = visual.Window(size=[GetSystemMetrics(0), GetSystemMetrics(1)], fullscr=FS, screen=0, allowGUI=True, monitor=u'testMonitor', color=[-1, -1, -1], colorSpace=u'rgb')
win.mouseVisible = False
visual.TextStim(win, color='white', height=(0.06), pos=[0, 0],wrapWidth=1.5,
                       text=(u'A continuación realizará dos juegos de decisiones. En estos juegos se competirá con otros jugadores en red. Usted deberá intentar acumular la máxima cantidad de fichas posible.\n\n\n'+ 
                        u'En cada juego puede decidir libremente y sus datos serán anónimos. Es decir, ningún jugador sabrá sobre sus decisiones ni resultados.')).draw()
visual.TextStim(win, pos=[0, -0.65], height=(0.09), wrapWidth=1,
                       text="Presiona cualquier tecla para comenzar").draw()
win.flip()
key = event.waitKeys()
if key[0] == "escape":
    win.close()
    exit()

## UG PRUEBA

expInfo['Tipo']='Prueba'
expInfo['nJ']=1
#ID = [1,2,1,2,1,2,1]
#random.shuffle(ID)
expInfo['TipoUG']='Ulimatum'

OF1 = [50,40,20]
OF2 = [20,20,70]
ID  = [1,2,1]
T   = [1,1,2]
S =[0,1,2]


hacer_prueba = True
while hacer_prueba:
	(_, salir) = GameUG_R(expInfo, win, ntrial=1, proposers_ID=ID,tipos=T,FS=FS,OF1=OF1,OF2=OF2,S=S)
	if salir:
		exit()
	(hacer_prueba, salir) = PreguntarSiEntendio(win)
	if salir:
		exit()


## UG  REAL

expInfo['Tipo']='Real'
expInfo['nJ']=1
#ID = [1,2,1,2,1,2,1]
#random.shuffle(ID)
expInfo['TipoUG']='Ulimatum'

OF1 = [30,20,40,     30,50,40,30,50,10,30,10,20,   50,10]
OF2 = [30,20,40,     50,40,20,10,20,20,10,10,50,   50,10]
ID  = [2,  1, 2,      1, 2, 1, 2, 2, 2, 1, 2, 2,     1, 2]
T   = [2,  2, 2,      1, 1, 1, 1, 1, 1, 1, 1, 1,     2,2]
S   = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
shuffle(S)


(av, salir)=GameUG_R(expInfo, win, ntrial=1, proposers_ID=ID,tipos=T,FS=FS,OF1=OF1,OF2=OF2,S=S)
if salir:
	exit()	


## DICTADOR PRUEBA


expInfo['Tipo']='Prueba'
expInfo['nJ']=1
expInfo['TipoUG']='Dictador'

OF1 = [50,40,20]
OF2 = [20,20,70]
ID  = [1,2,1]
T   = [1,1,2]
S = [0,1,2]


hacer_prueba = True
while hacer_prueba:
	(_, salir) = GameDic(expInfo, win, ntrial=1, ngame=5, receptors_ID=[1], tipos=[1], FS=FS)
	if salir:
		exit()
	(hacer_prueba, salir) = PreguntarSiEntendio(win)
	if salir:
		exit()

## DICTADOR REAL    

expInfo['Tipo']='Real'
expInfo['nJ']=1
#ID = [1,2,1,2,1,2,1]
#random.shuffle(ID)
expInfo['TipoUG']='Dictador'

OF1 = [30,20,40,     30,50,40,30,50,10,30,10,20,   50,10]
OF2 = [30,20,40,     50,40,20,10,20,20,10,10,50,   50,10]
ID  = [2,  1, 2,      1, 2, 1, 2, 2, 2, 1, 2, 2,     1, 2]
T   = [2,  2, 2,      1, 1, 1, 1, 1, 1, 1, 1, 1,     2,2]
S   = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
shuffle(S)

#GameDic(expInfo, win, ntrial=1, ngame=3, receptors_ID=[1,1,1], tipos=[1,1,1], FS=FS,av=av)
GameDic(expInfo, win, ntrial=1, ngame=3, receptors_ID=[1,1,1], tipos=[1,1,1], FS=FS)
win.close()