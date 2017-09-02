#!/usr/bin/env python2
# -*- coding: utf-8 -*-
#  Versions of ultimatum Game ------------------
# -------          Version R 1.0
#-------          Pablo Billeke
#-------          2017



#from numpy import *  #many different maths functions
#from numpy.random import *  #maths randomisation functions
import os  #handy system and path functions
from psychopy import core, data, event, visual, gui
#import psychopy.log  #import like this so it doesn't interfere with numpy.log
import math
from scipy.stats import norm
from random import shuffle, randint, random


def DiccionarioDeJugadores(avatares):
    jugadores = {}
    contador_jugadores = 2;
    for x in avatares:	
        if x not in jugadores:
            jugadores[x] = str(contador_jugadores)
            contador_jugadores += 1
    return jugadores

def PreguntarSiEntendio(win):
    win.mouseVisible = False
    visual.TextStim(win, color='white', height=(0.3 * 0.3), pos=[0, 0],wrapWidth=1.5,
                                       text=(u'¿Desea rehacer la practica?')).draw()
    visual.TextStim(win, pos=[0, -0.65], height=(0.3 * 0.3), wrapWidth=1.8,
                                       text="Presione la flecha arriba para repetirla\n O la flecha abajo para continuar").draw()

    win.flip()
    key = event.waitKeys(keyList=['up','down', 'escape'])
    if key[0] == "up":
        return (True, False)
    elif key[0] == "down":
        return (False, False)
    elif key[0] == "escape":
        win.close()
        return (False, True)


def GameUG_R(expInfo, win, ntrial=30, ngame=1, proposers_ID=[1,1,1,1], tipos=[1,1,2,2], FS=True, NS_a=False, av=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            OF1=[30,20,50,20],OF2=[10,10,10,10],S=[1,2,3,4]):
    TotalY =0
    #print(OF1)
    win.mouseVisible = False
    if not os.path.isdir('dataUG'):
        os.makedirs('dataUG')  #if this fails (e.g. permissions) we will get error
    fileRname = 'dataUG/UG_Respuestas_cics_%s_%s_%s_%s' % (expInfo['Participante'], expInfo['Tipo'],expInfo['TipoUG'], expInfo['date'])
    text_file = open(fileRname, "w")

    avatares = ['A_130_130_0.png', 'A_0_255_0.png', 'A_0_255_255.png', 'A_0_255_0.png', 'A_130_130_0.png',
                'A_0_255_0.png',
                'A_130_130_0.png', 'A_0_255_0.png', 'A_0_255_255.png', 'A_0_255_0.png', 'A_130_130_0.png',
                'A_0_255_0.png',
                'A_130_130_0.png', 'A_0_255_0.png', 'A_0_255_255.png', 'A_0_255_0.png', 'A_130_130_0.png',
                'A_0_255_0.png',
                'A_0_255_0.png', 'A_0_255_0.png', 'A_0_255_0.png']
    jugadores = DiccionarioDeJugadores(avatares)
    shuffle(avatares)
    MARCA= visual.Rect(win, fillColor=(1, 1, 1), pos=[-0.9, 0.9], width=0.2, height=0.2, )
    MARCA2= visual.Rect(win, fillColor=(1, 1, 1), pos=[0.9, 0.9], width=0.2, height=0.2, )

# Header
    text_file.write('Ronda\t')
    text_file.write('Oferta1\t')
    text_file.write('Oferta1\t')
    text_file.write('Proponente\t')
    text_file.write('tipo_juego\t')
    text_file.write('Respuesta\t')
    text_file.write('D_rt\n')
    # Instrucciones y connecion con los jugadores
    ht = 0.3
    sep = 0.06
    colorPC = (-0.5, -0.5, 1)
    trialClock = core.Clock()
    trialClock.reset()
    njuego = -1
    for nproposer_ID in proposers_ID:
        njuego = njuego + 1
        tipo = tipos[S[njuego]]
        proposer_ID = proposers_ID[S[njuego]]
        #if tipo == 2:
        #    Tcolor = colorPC
        #else:
        Tcolor = (-1, 1, -1)
        

        if (expInfo['Tipo'] == 'Real'):
            message1 = visual.TextStim(win, color='white', height=(0.3 * ht), pos=[0, 0.7],
                                       text=(u'Juego Real: JUEGO 1'))
            message2 = visual.TextStim(win, color='white', height=(0.2 * ht), pos=[0, 0],wrapWidth=1.5,
                                       text=(u'﻿En seguida empezará el juego real.\n'+
                                       u'Recuerde que el objetivo tanto para usted como el otro jugador debe ser ganar la máxima cantidad de FICHAS posible. Mientras más fichas acumule en relación con los otros jugadores tendrá mayor probabilidad de ganar.'))
            message3 = visual.TextStim(win, pos=[0, -0.7], height=(0.3 * ht), wrapWidth=2,
                                       text="Presiona cualquier tecla  para comenzar")
            if(njuego==0):
                visual.TextStim(win, color='white', height=(0.3 * ht), pos=[0, 0.7],
                                       text=(U'INICIO DEL JUEGO 1')).draw()
                win.flip()
                core.wait(2)
                                       
                message1.draw()
                message2.draw()
                message3.draw()
                #MARCA.draw()
                win.flip()
                key = event.waitKeys()
                if key[0] == "escape":
                    win.close()
                    return (av, True)
        elif (expInfo['Tipo'] == 'Prueba'):
                        
            message1 = visual.TextStim(win, color='white', height=(0.3 * ht), pos=[0, 0.65],
                                       text=(u'Juego de entrenamiento: JUEGO 1'))
            message2 = visual.TextStim(win, color='white', height=(0.2 * ht), pos=[0, 0],wrapWidth=1.5,
                                       text=(u'﻿Usted es el jugador ROJO (izquierda). El otro jugador es el VERDE (derecha).\n\n'+
                                        u'El otro jugador en red, deberá distribuir 100 fichas entre usted y él. Él tendrá dos opciones acerca de cómo distribuir las fichas y seleccionará una. La opción que él elija será la que queda en color resaltado. En algunas ocasiones podrá saber cuáles fueron las dos alternativas que tuvo y en otros casos no. Siempre deberá tomar su decisión de aceptar o rechazar la oferta con la información que tiene disponible.\n\n'+
                                        u'En el caso de Aceptar la oferta (A) las fichas se reparten efectivamente; en caso de Rechazarla (R) esas fichas se pierden y ninguno de los dos recibirá fichas en esa jugada.\n'+
                                        u'Deberá usar las flechas para responder: ABAJO para Aceptar (A) y ARRIBA para Rechazar (R)\n\n'+
                                        u'Las tres primeras jugadas son de entrenamiento, luego comenzará el juego real en línea.'))
            message3 = visual.TextStim(win, pos=[0, -0.65], height=(0.3 * ht), wrapWidth=1.8,
                                       text="Presiona cualquier tecla para comenzar")            
            if(njuego==0):

                visual.TextStim(win, color='white', height=(0.2 * ht), pos=[0, 0],
                                       text=(u'﻿JUEGO 1')).draw()
                win.flip()
                core.wait(2)
                
                message1.draw()
                message2.draw()
                message3.draw()
                #MARCA.draw()
                win.flip()
                key = event.waitKeys()
                print key[0]
                if key[0] == "escape":
                    win.close()
                    #core.quit()
                    return (av, True)
        #  Juego real
        if expInfo['Tipo'] == 'Real':
            t1 = trialClock.getTime()
            t = trialClock.getTime()
            if njuego == 0:  # Mostrar video solo en el primer juego
                visual.TextStim(win, text=u'Estableciendo Conexión....', pos=(0, 0.75), height=(0.4 * ht)).draw()
                win.flip()
                while t < (2 + t1): t = trialClock.getTime()
               # mov = visual.MovieStim(win, 'all.m4v', flipVert=False)
                while t < (10 + 2 + t1):
                    t = trialClock.getTime()
                #    mov.draw()
                    visual.ImageStim(win, image=('st/A_255_0_0.png'), size=(0.1, 0.2), pos=(0, -0.8)).draw()
                    i = 4.2
                    xx = [-2 * i, -1 * i, 0, 1 * i, 2 * i]
                    i = 5.2
                    yy = [-1.3 * i, -0.4 * i, 0.4 * i, 1.3 * i]
                    nr = 0
                    for x in (0, 1, 2, 3, 4):
                        for y in (0, 1, 2, 3):
                            nr += 1
                            if random() >0.999: av[nr]=1
                            if av[nr]==1: visual.ImageStim(win, image=('st/' + avatares[nr]), size=(1 * 0.7, 1.31 * 0.7),
                                             pos=(xx[x] - 1.8, yy[y] - 1.4), units='deg').draw()
                    #if event.getKeys(["escape"]):core.quit()
                    visual.TextStim(win, text='Jugadores Conectados On-line ....', pos=(0, 0.75), height=(0.4 * ht)).draw()
                    win.flip()

            message1.draw()
            if(njuego==0):
                message2.draw()
                #MARCA2.draw()
            message3.draw()
            win.flip()
            pase1 = 0
            pase2 = 0
            t1 = trialClock.getTime()
            t_otro = randint(1,2)
            
            while (pase1 == 0) or (pase2 == 0):
                t = trialClock.getTime()
                if  pase1 == 0:
                    if (t - t1) > (t_otro):
                            Jverde = visual.Rect(win, fillColor=(-1, 1, -1), pos=[0.7, -0.7], width=0.3, height=0.2, )
                            JverdeT = visual.TextStim(win, color='black', pos=[0.7, -0.7], text='Jugador '+jugadores[avatares[njuego]])
                            Jverde.draw()
                            JverdeT.draw()
                            AvatarV = visual.ImageStim(win, image=('st/' + avatares[njuego]), size=(0.1, 0.2),
                                                   pos=(0.7, -0.45))
                            AvatarV.draw()
                            message1.draw()
                            if(njuego==0):message2.draw()
                            message3.draw()
                            pase1 = 1
                            if pase2 == 1:
                                Jrojo.draw()
                                JrojoT.draw()
                                AvatarR.draw()
                            win.flip()
                if event.getKeys():
                    Jrojo = visual.Rect(win, fillColor=(1, -1, -1), pos=[-0.7, -0.7], width=0.3, height=0.2, )
                    JrojoT = visual.TextStim(win, color='black', pos=[-0.7, -0.7], text='Jugador 1')
                    Jrojo.draw()
                    JrojoT.draw()
                    AvatarR = visual.ImageStim(win, image=('st/A_255_0_0.png'), size=(0.1, 0.2),
                                           pos=(-0.7, -0.45))  #A_190_210_100.png
                    AvatarR.draw()
                    message1.draw()
                    if(njuego==0):message2.draw()
                    message3.draw()
                    pase2 = 1
                    if pase1 == 1:
                        Jverde.draw()
                        JverdeT.draw()
                        AvatarV.draw()
                    win.flip()
        
        core.wait(0.7)
        t1 = trialClock.getTime()
        t = trialClock.getTime()
        #print mov.duration
        # Pantalla negra por 2 segundos
        if expInfo['Tipo'] == 'Real':AvatarV.draw()
        if expInfo['Tipo'] == 'Real':AvatarR.draw()
        win.flip()
        while t < (t1 + 2): t = trialClock.getTime()
        if expInfo['Tipo'] == 'Prueba':
                message1.setText(('Juego de prueba'))
        else:
                message1.setText(('Juego ' + str(njuego+1)))
        message1.draw()
        if expInfo['Tipo'] == 'Real':AvatarV.draw()
        if expInfo['Tipo'] == 'Real':AvatarR.draw()
        
        
        #MARCA2.draw()
        win.flip()
        t1 = trialClock.getTime()
        t = trialClock.getTime()
        while t < (t1 + 2):
                t = trialClock.getTime()

        theseKeys = event.getKeys(keyList=['escape'])
        if len(theseKeys) > 0 and theseKeys[0] == "escape":
            win.close()
            return (av, True)
        
        if not (expInfo['Tipo'] == 'Prueba'): message1.setText((''))

        class KeyResponse:
                def __init__(self):
                    self.keys = []  #the key(s) pressed
                    self.corr = 0  #was the resp correct this trial? (0=no, 1=yes)
                    self.rt = None  #response time
                    self.clock = None  #we'll use this to measure the rt


        trialClock = core.Clock()
        CC = [0.9, 0.9, 0.9]

        SUP = visual.TextStim(win=win, ori=0,
                                  text='',
                                  pos=[0, 0.4], height=ht / 2,
                                  color='white', colorSpace='rgb')
        YO = visual.TextStim(win=win, ori=0,
                                 text='100',
                                 pos=[-0.125, 0.2], height=ht / 2,
                                 color='white', colorSpace='rgb')
        YOr = visual.Rect(win, width=0.25, height=0.25, pos=[-0.125, 0.2], fillColor=(1, -1, -.1), fillColorSpace='rgb',
                                closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        YOr2 = visual.Rect(win, width=0.22, height=0.22, pos=[-0.125, 0.2], fillColor=(-1, -1, -1), fillColorSpace='rgb',
                               closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        BL = visual.Rect(win, width=0.25*2, height=0.25, pos=[0, 0.2], fillColor=(0, 0, 0), fillColorSpace='rgb',
                                closeShape=True, interpolate=True, lineColor=(0, 0, 0))
        YOa = visual.TextStim(win=win, ori=0,
                                 text='100',
                                 pos=[-0.125, -0.2], height=ht / 2,
                                 color='white', colorSpace='rgb')
        YOra = visual.Rect(win, width=0.25, height=0.25, pos=[-0.125, -0.2], fillColor=(1, -1, -.1), fillColorSpace='rgb',
                                closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        BLa = visual.Rect(win, width=0.25*2, height=0.25, pos=[0, -0.2], fillColor=(0, 0, 0), fillColorSpace='rgb',
                                closeShape=True, interpolate=True, lineColor=(0, 0, 0))
        YOr2a = visual.Rect(win, width=0.22, height=0.22, pos=[-0.125, -0.2], fillColor=(-1, -1, -1), fillColorSpace='rgb',
                               closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
                               
        TUr = visual.Rect(win, width=0.25, height=0.25, pos=[0.125, 0.2], fillColor=Tcolor, fillColorSpace='rgb',
                              closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        TUr2 = visual.Rect(win, width=0.22, height=0.22, pos=[0.125, 0.2], fillColor=(-1, -1, -1), fillColorSpace='rgb',
                               closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        TU = visual.TextStim(win=win, ori=0,
                                 text='0',
                                 pos=[0.125, 0.2], height=ht / 2,
                                 color='white', colorSpace='rgb')
        TUra = visual.Rect(win, width=0.25, height=0.25, pos=[0.125, -0.2], fillColor=Tcolor, fillColorSpace='rgb',
                              closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        TUr2a = visual.Rect(win, width=0.22, height=0.22, pos=[0.125, -0.2], fillColor=(-1, -1, -1), fillColorSpace='rgb',
                               closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        TUa = visual.TextStim(win=win, ori=0,
                                 text='0',
                                 pos=[0.125, -0.2], height=ht / 2,
                                 color='white', colorSpace='rgb')
        nt = -1
        respuesta = ''
        GP_RA = -99
        
        
        while nt < (ntrial - 1):
                nt = nt + 1
                Mi_D = OF1[S[njuego]]
                Tu_D = 100-Mi_D
                Mi_Da = OF2[S[njuego]]
                Tu_Da = 100-Mi_Da
                TU.setText(Tu_D)
                YO.setText(Mi_D)                
                TUa.setText(Tu_Da)
                YOa.setText(Mi_Da)
                TUr.setFillColor(Tcolor)
                TUr.draw()
                TUra.setFillColor(Tcolor)
                TUra.draw()
                YOr.setFillColor([1, -1, -1])
                YOr.draw()
                YOra.setFillColor([1, -1, -1])
                YOra.draw()
                
                YOr2.draw()
                TUr2.draw()
                message1.draw()
                YO.draw()
                TU.draw()
                YOr2a.draw()
                TUr2a.draw()
                YOa.draw()
                TUa.draw()
                
                continueTrial = True
                trialClock.reset()
                resp = KeyResponse()  #create an object of type KeyResponse

                R = 0
                if expInfo['Tipo'] == 'Real':AvatarV.draw()
                if tipo==2: 
                    BL.draw()
                    BLa.draw()
                win.flip()
                core.wait(0.7+random()*2.0)
                if proposer_ID==1:
                            TUra.setFillColor([0.1, 0.1, 0.1])
                            YOra.setFillColor([-0.1, -0.1, -0.1])
                elif proposer_ID==2:
                            TUr.setFillColor([0.1, 0.1, 0.1])
                            YOr.setFillColor([-0.1, -0.1, -0.1])
                TUr.draw()
                TUra.draw()
                YOr.draw()
                YOra.draw()
                YOr2.draw()
                TUr2.draw()
                YO.draw()
                TU.draw()
                YOr2a.draw()
                TUr2a.draw()
                YOa.draw()
                TUa.draw()
                event.clearEvents()
                RR_=-1
                if expInfo['Tipo'] == 'Real':AvatarR.draw()
                if proposer_ID==1:
                                if tipo==2: BLa.draw()
                if proposer_ID==2:
                                if tipo==2: BL.draw()
                win.flip()
                t_1 = trialClock.getTime()
                #event.waitKeys()
                if resp.clock == None:  #if we don't have one we've just started
                        resp.clock = core.Clock()  #create one (now t=0)
                theseKeys = event.getKeys(keyList=['up','down','escape','num_8','num_2'])
                
                while len(theseKeys) == 0: theseKeys = event.getKeys(keyList=['up','down','escape','num_8','num_2'])
                t_d = trialClock.getTime()
                if len(theseKeys) > 0:  #at least one key was pressed
                            resp.keys = theseKeys[0]  #just the first key pressed
                            event.clearEvents()
                if resp.keys == "up" or resp.keys == "8":
                            RR_=0
                            SUP.setText('R')
                            #MARCA2.draw()
                            #SUP.setColor('green')
                            SUP.draw()
                            TUr.setFillColor([0.1, 0.1, 0.1])
                            TUra.setFillColor([0.1, 0.1, 0.1])
                            TUr.draw()
                            TUra.draw()
                            TUr2.draw()
                            TUr2a.draw()
                            TU.draw()
                            TUa.draw()
                            message1.draw()
                            YOr.setFillColor([-0.1, -0.1, -0.1])
                            YOra.setFillColor([-0.1, -0.1, -0.1])
                            YOr.draw()
                            YOra.draw()
                            YOr2.draw()
                            YOr2a.draw()
                            YO.draw()
                            YOa.draw()
                            if proposer_ID==1:
                                if tipo==2: BLa.draw()
                            if proposer_ID==2:
                                if tipo==2: BL.draw()
                            win.flip()
                elif resp.keys == "down" or resp.keys == "2":
                            RR_=1
                            SUP.setText('A')
                            #MARCA2.draw()
                            #SUP.setColor('green')
                            SUP.draw()
                            TUr.draw()
                            TUra.draw()
                            TUr2.draw()
                            TU.draw()
                            TUr2a.draw()
                            TUa.draw()
                            message1.draw()
                            YOr.draw()
                            YOr2.draw()
                            YO.draw()
                            YOra.draw()
                            YOr2a.draw()
                            YOa.draw()
                            if proposer_ID==1:
                                TotalY = TotalY + Mi_D
                                if tipo==2: BLa.draw()
                            if proposer_ID==2:
                                TotalY = TotalY + Mi_Da
                                if tipo==2: BL.draw()
                            win.flip()
                elif resp.keys == "escape":
                    win.close()
                    return (av, True)
                core.wait(1+random()*1.0)
                text_file.write((str(njuego + 1) + '\t'))
                text_file.write((str(Mi_D) + '\t'))
                text_file.write(str(Mi_Da) + '\t')
                text_file.write(str(proposer_ID) + '\t')
                text_file.write((str(tipo) + '\t'))
                text_file.write((str(RR_) + '\t'))
                text_file.write((str(int((t_d - t_1) * 1000)) + '\n'))
    if (expInfo['Tipo'] == 'Real'):
        text_file.write((str(TotalY) + '\t'))
        message1 = visual.TextStim(win, color='white', height=(0.3 * ht), pos=[0, 0.65],
            text=('Fichas Ganadas en este bloque de Juego'))
        message2 = visual.TextStim(win, color='white', height=(0.2 * ht), pos=[0, 0],
                                       text=(u'TU    =  ' +  str(TotalY) + u'\n'+
                                             u'J_01  =   200\n'+
                                             u'J_02  =   120\n'+
                                             u'J_03  =   50\n'+
                                             u'J_04  =   450\n'+
                                             u'J_05  =   470\n'+
                                             u'J_06  =   480\n'+
                                             u'J_07  =   290\n'+
                                             u'J_08  =   370\n'
                                       ))
        message3 = visual.TextStim(win, pos=[0, -0.65], height=(0.3 * ht), wrapWidth=2,
                                       text="Presiona cualquier tecla para continuar")
        message1.draw()
        message2.draw()
        message3.draw()
        #MARCA2.draw()
        win.flip()
        event.waitKeys()
    return (av, False)
    
# --------------------------------------------------------
# --------------------------------------------------------
# --------------------------------------------------------
# --------------------------------------------------------
def GameDic(expInfo, win, ntrial=30, ngame=1, receptors_ID=[1], tipos=[1], FS=True, NS_a=False, av=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]):
    # --------------------------------------------------------
    # --------------------------------------------------------
    #avataers de los receptore
    win.mouseVisible = False
    avatares = ['A_130_130_0.png', 'A_0_255_0.png', 'A_0_255_0.png', 'A_0_255_0.png', 'A_130_130_0.png',
                'A_0_255_0.png',
                'A_130_130_0.png', 'A_0_255_0.png', 'A_0_255_0.png', 'A_0_255_0.png', 'A_130_130_0.png',
                'A_0_255_0.png',
                'A_0_130_130.png', 'A_0_255_0.png', 'A_0_255_0.png', 'A_0_255_0.png', 'A_130_130_0.png',
                'A_0_255_0.png',
                'A_0_255_0.png', 'A_0_255_0.png', 'A_0_255_0.png']
    jugadores = DiccionarioDeJugadores(avatares)
    shuffle(avatares)

    if not os.path.isdir('dataDG'):
        os.makedirs('dataDG')  #if this fails (e.g. permissions) we will get error


    fileRname = 'dataDG/UG_Respuestas_cics_%s_%s_%s_%s' % (expInfo['Participante'], expInfo['Tipo'], expInfo['TipoUG'] ,expInfo['date'])
    text_file = open(fileRname, "w")    
    
    # Header
    text_file.write('Ronda\t')
    text_file.write('Oferta\t')
    text_file.write('Respuestas\t')
    text_file.write('Logit\t')
    text_file.write('R_ID\t')
    text_file.write('tipo\t')
    text_file.write('D_rt\t')
    text_file.write('R_rt\n')
    # Instrucciones y connecion con los jugadores
    ht = 0.3
    sep = 0.06
    colorPC = (-0.5, -0.5, 1)
    trialClock = core.Clock()
    trialClock.reset()
    njuego = 0
    TotalY = 0
    TotalT=0
    
    MARCA= visual.Rect(win, fillColor=(1, 1, 1), pos=[-0.9, 0.9], width=0.2, height=0.2, )
    MARCA2= visual.Rect(win, fillColor=(1, 1, 1), pos=[0.9, 0.9], width=0.2, height=0.2, )
    visual.TextStim(win, color='white', height=(0.2 * ht), pos=[0, 0],
                                       text=(u'﻿JUEGO 2')).draw()
    win.flip()
    core.wait(2)
    
    
    for receptor_ID in receptors_ID:
        tipo = tipos[njuego]
        if tipo == 2:
            Tcolor = colorPC
        else:
            Tcolor = (-1, 1, -1)
        njuego = njuego + 1
        
        if (expInfo['Tipo'] == 'Prueba'):

            message1 = visual.TextStim(win, color='white', height=(0.3 * ht), pos=[0, 0.65],
                                       text=('Juego de entrenamiento: JUEGO 2'))
            message2 = visual.TextStim(win, color='white', height=(0.2 * ht), pos=[0, 0],wrapWidth=1.5,
                                       text=(u'﻿Usted es el jugador ROJO (izquierda). El otro jugador es el VERDE (derecha).\n\n'+
                                        u'En esta ocasión usted es quien realiza la oferta de las FICHAS. En la pantalla aparecerán dos cuadros de colores, uno ROJO que corresponde a la cantidad inicial de fichas que deberá repartir con el otro jugador (Cuadro VERDE). El otro jugador no podrá rechazar la oferta y recibirá lo que le des.\n\n'+
                                        u'En cada jugada deberá realizar la oferta usando las flechas para responder.\n'+ 
                                        u'Use la tecla IZQUIERDA y DERECHA para cambiar la cantidad de FICHAS.\n'+
                                        u'Use la tecla ABAJO para Aceptar y Repartir las FICHAS.\n\n'+
                                        u'La primera jugada es de entrenamiento, luego vendrá el juego real en línea.'))


            message3 = visual.TextStim(win, pos=[0, -0.65], height=(0.3 * ht), wrapWidth=2,
                                       text=u'Presiona cualquier tecla  para comenzar')
            if(njuego==1):
                message1.draw()
                message2.draw()
                message3.draw()
                ##MARCA.draw()
                win.flip()
                event.waitKeys()


        elif (expInfo['Tipo'] == 'Real'):
            #if tipo == 1:

            message1 = visual.TextStim(win, color='white', height=(0.3 * ht), pos=[0, 0.65], text=('Juego con otra Persona: JUEGO 2'))
            message2 = visual.TextStim(win, color='white', height=(0.2 * ht), pos=[0, 0], wrapWidth=1.5,
                                           text=(u'Juego con otra Persona\n En seguida empezará el juego real.'))
            message3 = visual.TextStim(win, pos=[0, -0.65], height=(0.3 * ht), wrapWidth=2,
                                           text="Presiona  cualquier tecla  para comenzar")
            message4 = visual.TextStim(win, pos=[0, -0.65], height=(0.3 * ht), wrapWidth=2,
                                           text="Presiona  cualquier tecla  para conectarte")
            #else:
            #    message1 = visual.TextStim(win, color='white', height=(0.3 * ht), pos=[0, 0.5],
            #                               text='Juego con el Computador ')
            #    message2 = visual.TextStim(win, color='white', height=(0.2 * ht), pos=[0, 0],
            #                               text=('Debes realizar una oferta\nde como repartir el dinero\nentre tu (Jugador ROJO) \ny otra persona (Jugador VERDE). \n'
            #                                     +'El otro jugador va recibir lo que le des. Debes decicir como si el dienro juera real. Cada 10 representan 10.000 Pesos Colombianos'))
            #    message3 = visual.TextStim(win, pos=[0, -0.5], height=(0.3 * ht), wrapWidth=2,
            #                               text="Conectando jugadores .... \n presiona cualquier tecla para conectarte")


            #message1.draw()
            #message2.draw()
            #message3.draw()
            #win.flip()

            t1 = trialClock.getTime()
            t = trialClock.getTime()
            if njuego == 1:  # Mostrar video solo en el primer juego
                
                visual.TextStim(win, color='white', height=(0.3 * ht), pos=[0, 0.7],
                                       text=(U'INICIO JUEGO 2 REAL')).draw()
                win.flip()
                core.wait(1.2)
                
                
                
                visual.TextStim(win, text='Jugadores Conectados On-line ....', pos=(0, 0.75), height=(0.4 * ht)).draw()
                win.flip()
                while t < (2 + t1): t = trialClock.getTime()
               # mov = visual.MovieStim(win, 'all.m4v', flipVert=False)
                while t < (4 + 2 + t1):
                    t = trialClock.getTime()
                #    mov.draw()
                    visual.ImageStim(win, image=('st/A_255_0_0.png'), size=(0.1, 0.2), pos=(0, -0.8)).draw()
                    i = 4.2
                    xx = [-2 * i, -1 * i, 0, 1 * i, 2 * i]
                    i = 5.2
                    yy = [-1.3 * i, -0.4 * i, 0.4 * i, 1.3 * i]
                    nr = 0
                    for x in (0, 1, 2, 3, 4):
                        for y in (0, 1, 2, 3):
                            nr += 1
                            if random() >0.99: av[nr]=1
                            if av[nr]==1: visual.ImageStim(win, image=('st/' + avatares[nr]), size=(1 * 0.7, 1.31 * 0.7),
                                             pos=(xx[x] - 1.8, yy[y] - 1.4), units='deg').draw()
                    #if event.getKeys(["escape"]):core.quit()
                    visual.TextStim(win, text='Jugadores Conectados On-line ....', pos=(0, 0.75), height=(0.4 * ht)).draw()
                    win.flip()

            if(njuego==1):
                message2.draw()
                ##MARCA.draw()
                message1.draw()
                message4.draw()
                win.flip()
                event.waitKeys()
            else:
                #message2.draw()
                ##MARCA.draw()
                message1.draw()
                message4.draw()
                win.flip()
                #core.wait(0.5)
                #event.waitKeys()

            pase1 = 0
            pase2 = 0
            t1 = trialClock.getTime()
            t_otro = randint(1, 2)
            while (pase1 == 0) or (pase2 == 0):
                t = trialClock.getTime()
                if tipo == 1 and pase1 == 0:
                    if (t - t1) > (t_otro):
                        if tipo == 1:
                            Jverde = visual.Rect(win, fillColor=(-1, 1, -1), pos=[0.7, -0.7], width=0.3, height=0.2, )
                            JverdeT = visual.TextStim(win, color='black', pos=[0.7, -0.7], text='Jugador '+jugadores[avatares[njuego]])
                            Jverde.draw()
                            JverdeT.draw()
                            AvatarV = visual.ImageStim(win, image=('st/' + avatares[njuego]), size=(0.1, 0.2),
                                                   pos=(0.7, -0.45))
                            AvatarV.draw()
                            message1.draw()
                            #if(njuego==1):message2.draw()
                            message4.draw()
                            pase1 = 1
                            if pase2 == 1:
                                Jrojo.draw()
                                JrojoT.draw()
                                AvatarR.draw()
                            win.flip()
                if tipo == 2 and pase1 == 0:
                    Jverde = visual.Rect(win, fillColor=colorPC, pos=[0.7, -0.7], width=0.35, height=0.2, )
                    JverdeT = visual.TextStim(win, color='black', pos=[0.7, -0.7], text='Computador')
                    Jverde.draw()
                    JverdeT.draw()
                    AvatarV = visual.ImageStim(win, image=('st/' + 'atari.png'), size=(0.1, 0.2), pos=(0.7, -0.45))
                    AvatarV.draw()
                    message1.draw()
                    #if(njuego==1):message2.draw()
                    message3.draw()
                    pase1 = 1
                    if pase2 == 1:
                        Jrojo.draw()
                        JrojoT.draw()
                        AvatarR.draw()
                    win.flip()
                if event.getKeys():
                    Jrojo = visual.Rect(win, fillColor=(1, -1, -1), pos=[-0.7, -0.7], width=0.3, height=0.2, )
                    JrojoT = visual.TextStim(win, color='black', pos=[-0.7, -0.7], text='Jugador 1')
                    Jrojo.draw()
                    JrojoT.draw()
                    AvatarR = visual.ImageStim(win, image=('st/A_255_0_0.png'), size=(0.1, 0.2),
                                           pos=(-0.7, -0.45))  #A_190_210_100.png
                    AvatarR.draw()
                    message1.draw()
                    #if(njuego==1):message2.draw()
                    message3.draw()
                    pase2 = 1
                    if pase1 == 1:
                        Jverde.draw()
                        JverdeT.draw()
                        AvatarV.draw()
                    win.flip()

        core.wait(0.5)
        t1 = trialClock.getTime()
        t = trialClock.getTime()
        #print mov.duration
        # Pantalla negra por 2 segundos
        win.flip()
        while t < (t1 + 2): t = trialClock.getTime()
        if expInfo['Tipo'] == 'Prueba':
                message1.setText(('Juego de prueba'))
        else:
                message1.setText(('Juego ' + str(njuego)))
        message1.draw()
        ##MARCA2.draw()
        win.flip()
        t1 = trialClock.getTime()
        t = trialClock.getTime()
        while t < (t1 + 2):
                t = trialClock.getTime()
        if event.getKeys(["escape"]): core.quit()
        if not (expInfo['Tipo'] == 'Prueba'): message1.setText((''))

        class KeyResponse:
                def __init__(self):
                    self.keys = []  #the key(s) pressed
                    self.corr = 0  #was the resp correct this trial? (0=no, 1=yes)
                    self.rt = None  #response time
                    self.clock = None  #we'll use this to measure the rt


        trialClock = core.Clock()
        CC = [0.9, 0.9, 0.9]

        SUP = visual.TextStim(win=win, ori=0,
                                  text='',
                                  pos=[0, 0.2], height=ht / 2,
                                  color='white', colorSpace='rgb')
        YO = visual.TextStim(win=win, ori=0,
                                 text='100',
                                 pos=[-0.125, 0], height=ht / 2,
                                 color='white', colorSpace='rgb')
        YOr = visual.Rect(win, width=0.25, height=0.25, pos=[-0.125, 0], fillColor=(1, -1, -.1), fillColorSpace='rgb',
                                closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        YOr2 = visual.Rect(win, width=0.22, height=0.22, pos=[-0.125, 0], fillColor=(-1, -1, -1), fillColorSpace='rgb',
                               closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        # YOr2=visual.Rect(win, width=0.45, height=0.45, pos=[-0.2, 0],fillColor=(0,0,0), ColorSpace='rgb')
        TUr = visual.Rect(win, width=0.25, height=0.25, pos=[0.125, 0], fillColor=Tcolor, fillColorSpace='rgb',
                              closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        TUr2 = visual.Rect(win, width=0.22, height=0.22, pos=[0.125, 0], fillColor=(-1, -1, -1), fillColorSpace='rgb',
                               closeShape=True, interpolate=True, lineColor=(-1, -1, -1))
        TU = visual.TextStim(win=win, ori=0,
                                 text='0',
                                 pos=[0.125, 0], height=ht / 2,
                                 color='white', colorSpace='rgb')

        nt = -1
        respuesta = ''

        GP_RA = -99
        while nt < (ntrial - 1):

                nt = nt + 1
                Mi_D = 100
                Tu_D = 0
                TU.setText(Tu_D)
                YO.setText(Mi_D)
                TUr.setFillColor(Tcolor)
                YOr.setFillColor([1, -1, -1])
                YOr.draw()
                YOr2.draw()
                message1.draw()
                YO.draw()
                TUr.draw()
                TUr2.draw()
                TU.draw()
                continueTrial = True
                trialClock.reset()
                resp = KeyResponse()  #create an object of type KeyResponse
                R = 0
                win.flip()
                if NS_a: ns.send_event('op__', timestamp=egi.ms_localtime(), label="Options")
                t1 = trialClock.getTime()
                rd_r = random()*2
                while continueTrial:
                    t = trialClock.getTime()

                    if R == 0:
                        if resp.clock == None:  #if we don't have one we've just started
                            resp.clock = core.Clock()  #create one (now t=0)
                        theseKeys = event.getKeys(keyList=['left', 'down', 'right','num_6','num_4','num_2'])
                        if len(theseKeys) > 0:  #at least one key was pressed
                            resp.keys = theseKeys[0]  #just the first key pressed
                            event.clearEvents()
                            if resp.keys == "right" or resp.keys == "num_6":
                                if NS_a: ns.send_event('o_i_', timestamp=egi.ms_localtime(), label="Of_+")
                                if Tu_D < 100:
                                    Tu_D = Tu_D + 10
                                    TU.setText(Tu_D)
                                    TUr.draw()
                                    TUr2.draw()
                                    message1.draw()
                                    TU.draw()
                                    Mi_D = Mi_D - 10
                                    YO.setText(Mi_D)
                                    YOr.draw()
                                    YOr2.draw()
                                    YO.draw()
                                    win.flip()
                            if resp.keys == "left" or resp.keys =="num_4":
                                if NS_a: ns.send_event('o_d_', timestamp=egi.ms_localtime(), label="Of_-")
                                #print Tu_D
                                if Tu_D > 0:
                                    Tu_D = Tu_D - 10
                                    TU.setText(Tu_D)
                                    TUr.draw()
                                    TUr2.draw()
                                    message1.draw()
                                    TU.draw()
                                    Mi_D = Mi_D + 10
                                    YO.setText(Mi_D)
                                    YOr.draw()
                                    YOr2.draw()
                                    YO.draw()
                                    win.flip()
                            if resp.keys == "down" or resp.keys == "num_2":
                                if NS_a: ns.send_event('d_m_', timestamp=egi.ms_localtime(), label="Decision")
                                t_d = trialClock.getTime()
                                R = 1
                                SUP.setText('...')
                                ##MARCA2.draw()
                                SUP.draw()
                                TUr.draw()
                                TUr2.draw()
                                message1.draw()
                                TU.draw()
                                YOr.draw()
                                YOr2.draw()
                                YO.draw()
                                win.flip()
                                if GP_RA == -99:
                                    GP_D1 = -99
                                else:
                                    GP_D1 = GP_O - Mi_D
                                GP_O = Mi_D
                                tombola = random()
                                GP_logit = 100 #get_logit(100 - GP_O, GP_RA, GP_D1, receptor_ID)
                                curr_R = 1 #(log(tombola) - log(1 - tombola)) < GP_logit
                                GP_RA = curr_R
                                #print GP_logit
                                #print log(tombola) - log(1 - tombola)
                                #cond_cue.setText(cond)
                                #cond_cue.draw()
                    if event.getKeys(["escape"]):
                        win.close()
                        return  av, True
                    #win.flip()
                    if R == 1 and t > (t_d +1 ):
                        #continueTrial=False
                        R = 2
                        if curr_R == 1:
                            TotalT += Tu_D
                            TotalY += Mi_D
                            SUP.setText('Repartiendo')
                            #SUP.setColor('green')
                            SUP.draw()
                            TUr.draw()
                            TUr2.draw()
                            message1.draw()
                            TU.draw()
                            YOr.draw()
                            YOr2.draw()
                            YO.draw()
                            win.flip()
                            if NS_a: ns.send_event('f_p_', timestamp=egi.ms_localtime(), label="Acept")
                            t_r = trialClock.getTime()
                        elif curr_R == 0:
                            SUP.setText('R')
                            #SUP.setColor('green')
                            SUP.draw()
                            TUr.setFillColor([0.1, 0.1, 0.1])
                            TUr.draw()
                            TUr2.draw()
                            TU.draw()
                            message1.draw()
                            YOr.setFillColor([-0.1, -0.1, -0.1])
                            YOr.draw()
                            YOr2.draw()
                            YO.draw()
                            win.flip()
                            if NS_a: ns.send_event('f_n_', timestamp=egi.ms_localtime(), label="Reject")
                            t_r = trialClock.getTime()
                    if R == 2 and t > (t_r + 1 ):
                        continueTrial = False
                win.flip()
                event.clearEvents()
                text_file.write((str(njuego) + '\t'))
                text_file.write((str(GP_O) + '\t'))
                text_file.write(str(curr_R) + '\t')
                text_file.write(str(GP_logit) + '\t')
                text_file.write((str(receptor_ID) + '\t'))
                text_file.write((str(tipo) + '\t'))
                text_file.write((str(int((t_d - t1) * 1000)) + '\t'))
                text_file.write((str(int((t_r - t_d) * 1000)) + '\n'))
        #visual.TextStim(win, pos=(-0.5, 0.5),
        #                         text=u'En este juego\n ganaste:',
        #                         height=ht / 2,
        #                         color='white', colorSpace='rgb').draw()
        #visual.TextStim(win, pos=(-0.5, 0),
        #                         text=str(TotalY),
        #                          height=ht ,
        #                         color='white', colorSpace='rgb').draw()
        #visual.TextStim(win, pos=(0.5, 0.5),
        #                         text=u'En este juego\n el otro ganó:',
        #                         height=ht / 2,
        #                         color='white', colorSpace='rgb').draw()
        #visual.TextStim(win, pos=(0.5, 0),
        #                         text=str(TotalT),
        #                         height=ht ,
        #                         color='white', colorSpace='rgb').draw()
        t1 = trialClock.getTime()
        t = trialClock.getTime()
        #win.flip()
        #while t < (t1 + 4): t = trialClock.getTime()
    if (expInfo['Tipo'] == 'Real'):
            text_file.write((str(TotalY) + '\t'))
            message1 = visual.TextStim(win, color='white', height=(0.3 * ht), pos=[0, 0.65],
                text=('Fichas Ganadas en este bloque Juego'))
            message2 = visual.TextStim(win, color='white', height=(0.2 * ht), pos=[0, 0],
                                       text=(u'TU    =  ' +  str(TotalY) + '\n' +
                                             u'J_01  =   300\n'+
                                             u'J_02  =   100\n'+
                                             u'J_03  =   50\n'+
                                             u'J_04  =   20\n'+
                                             u'J_05  =   270\n'+
                                             u'J_06  =   300\n'+
                                             u'J_07  =   90\n'+
                                             u'J_08  =   70\n'
                                       ))
            message3 = visual.TextStim(win, pos=[0, -0.65], height=(0.3 * ht), wrapWidth=2,
                                       text="Presiona cualquier tecla para continuar")
            message1.draw()
            message2.draw()
            message3.draw()
            text_file.write((str(TotalY) + '\t'))
            #MARCA2.draw()
            win.flip()
            event.waitKeys()
    text_file.close()
    if (expInfo['Tipo'] == 'Real'):
        visual.TextStim(win, color='white', height=(0.2 * ht), pos=[0, 0],
                                       text=(u'﻿El juego ha terminado. Gracias por tu participación')).draw()
        win.flip()
        core.wait(3)    
    return av, False
# --------------------------------------------------------
# --------------------------------------------------------
# --------------------------------------------------------

