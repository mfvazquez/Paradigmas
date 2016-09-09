#ECI = True                # Try to connect using ECI if true.
TASK_REPETITIONS = 8      # Number of games with other people.

FULLSCREEN = True         # Whether to use whole screen instead of a window.
TOP_OFFER = 100           # Total amount for each trial.
PRACTICE = True           # Whether to practice before "real" games.

##eci_address = "10.0.0.42"
##eci_port = 55513


import pygame
import random
import sys
import os
import os.path
import platform
import time
from math import exp
#import parallel
##import eci

SUBJECT_ID = raw_input("Id. del sujeto :")

if platform.system() == 'Windows':
    os.environ['SDL_VIDEODRIVER'] = 'windib';


bs0 = [2.644235,5.959251,-6.767448,8.250176,-12.704856,-3.950557,-1.166608,2.580471,-5.448573,0.0]
bs1 = [-0.06882809,-0.11400377,0.1610063,-0.1610063,0.20544349,0.07840332,0.01850498,-0.02127307,0.08198,0.0]

beta0 = 20.236195; 
beta1 = -0.3494;
beta2 = 0.077633;
beta3 = 1.311;
beta4 = -0.06851;

# Game state
############

class GameState:
    def __init__(self, opponent):
        self.opponent = opponent
        self.round = 1
        self.total1 = 0
        self.total2 = 0
        self.lastAnswer = 0
        self.lastOffer = 0
        self.offer = 0
        self.answer = None
        self.logit = None
        self.log_temporal = []
        self.log_trials = []

	
    def newOffer(self, offer):
        self.lastOffer = self.offer
        self.offer = offer

    def simAnswer(self):
        self.lastAnswer = self.answer
        b0 = bs0[self.opponent % len(bs0)]
        b1 = bs1[self.opponent % len(bs1)]
        logitA = (b0 + beta0) + (b1 + beta1) * self.offer
        if self.round > 1:
            diffOffer = self.lastOffer - self.offer
            logitA += beta2 * diffOffer + beta3 * self.lastAnswer + beta4 * self.lastAnswer * diffOffer
        prob = exp(logitA) / (1.0 + exp(logitA))
        self.logit = logitA
        prob = max(min(prob, 0.89), 0.1)
        if random.random() < prob:
            self.answer = True
            self.total1 += self.offer
            self.total2 += TOP_OFFER - self.offer
        else:
            self.answer = False
        self.round += 1

    def log(self):
        self.log_trials.append(self.log_temporal)
        self.log_temporal = []

    def guardar_log(self):
        filename = FILENAME_PREFIX + "_" + str(SUBJECT_ID) + "_log.txt"
        outfile = None
        
        if os.path.exists(filename):
            outfile = open(filename, "a")
        else:
            outfile = open(filename, "w")
            outfile.write(",".join(["screenOffer", "tiempo de respuesta", "respuesta", "historial saldo", "tiempo espera", "resultado", "tiempo resultado", "monto usuario", "monto oponente"]) + "\n")

        for x in range(len(self.log_trials)):
            outfile.write(str(self.log_trials[x]) + "\n")

        outfile.flush()
        outfile.close()
		
    def guardar_en_log_temporal(self, dato):
        self.log_temporal.append(dato)		
	
    def writeResults(self):
        filename = FILENAME_PREFIX + "_" + str(SUBJECT_ID) + "_results.txt"
        outfile = open(filename, "a")
        outfile.write("JUGADOR\t%d\n" % self.total1)
        outfile.write("OPONENTE\t%d\n" % self.total2)
        outfile.flush()
        outfile.close()


# Init Pygame
#############

pygame.init()

if FULLSCREEN:
    screen = pygame.display.set_mode((0,0), pygame.FULLSCREEN)
else:
    screen = pygame.display.set_mode((1366, 768))

W, H = screen.get_size()
termFont = pygame.font.SysFont("Arial", H / 20, False, False)
numFont = pygame.font.SysFont("Courier New", H / 20, True, False)
pygame.mouse.set_visible(False)


# UTILS
#######

def loadAnim(base,frames):
    anim = []
    for frame in frames:
        anim.append(pygame.image.load(base % frame))
    return anim

def makeFilename():
    return time.strftime("%Y-%b-%d_%H.%M.%S")

def quadrant(n):
    i = n / 2
    j = n % 2
    return pygame.Rect((1+j)*W/4.0, (1+i)*H/4.0, W/4.0, H/4.0)

def half(n):
    return pygame.Rect(W/4.0, (1+n)*H/4.0, W/2, H/4.0)

def vhalf(n):
    return pygame.Rect(n*W/2.0, 0, W/2.0, H)

def centerInFrame(objRect, frameRect=screen.get_rect()):
    centered = pygame.Rect(objRect)
    centered.left = frameRect.left + (frameRect.w - objRect.w) / 2.0
    centered.top = frameRect.top + (frameRect.h - objRect.h) / 2.0
    return centered

def rightInFrame(objRect, frameRect=screen.get_rect()):
    right = centerInFrame(objRect, frameRect)
    right.left = frameRect.left + (frameRect.w - objRect.w) - H / 96
    return right

def leftInFrame(objRect, frameRect=screen.get_rect()):
    left = centerInFrame(objRect, frameRect)
    left.left = frameRect.left + H/96
    return left

def pause():
    screenBackup = screen.copy()
    showImage("pause.png")
    pygame.event.get()
    while True:
        events = pygame.event.get(pygame.KEYUP)
        for event in events:
            if event.key == pygame.K_p:
                screen.blit(screenBackup, (0,0))
                pygame.display.update()
                return

def getKey():
    pygame.event.get()
    pygame.event.get(pygame.KEYUP)
    while True:
        events = pygame.event.get(pygame.KEYUP)
        for event in events:
            if event.key in [pygame.K_1, pygame.K_KP1]:
                return 1
            elif event.key in [pygame.K_2, pygame.K_KP2]:
                return 2
            elif event.key in [pygame.K_3, pygame.K_KP3]:
                return 3
            elif event.key in [pygame.K_4, pygame.K_KP4]:
                return 4
            elif event.key == pygame.K_ESCAPE:
                return -1
            elif event.key == pygame.K_p:
                pause()

def waitKey():
    getKey()

def deleteScreen():
    screen.fill(BLACK)

def finalize():
##    eci.stop()
    pygame.quit()
    sys.exit(0)

def sendMark(num):
    name = "E%03d" % num
##fa    parallel.out(0xC020,num)
##    eci.sendevent(evttype=name, metadata = {'code':num})


# Drawing elements
##################

BLACK = (0,0,0)
RED = (255,0,0)
BLUE = (128,128,255)
WHITE = (255,255,255)
GREEN = (0,255,0)
PLAYER_COLOR = { 1:RED, 2:BLUE }
S = H / 32
ACCEPT = pygame.Surface((S, S))
REJECT = pygame.Surface((S, S))
ANIM = loadAnim(os.path.join("anim","frame_%04d.png"), range(1,11))

RECTANGULO_BLINK = (0,0,300,75)
TIME_BLINK = 50

def drawAnim():
    frameNum = (pygame.time.get_ticks() / 120) % len(ANIM)
    sfce = ANIM[frameNum]
    screen.blit(sfce, centerInFrame(sfce.get_rect(), half(0)))

def makeImages():
    pygame.draw.line(REJECT, WHITE, (0,0), (S,S), 3)
    pygame.draw.line(REJECT, WHITE, (S,0), (0,S), 3)
    pygame.draw.line(ACCEPT, WHITE, (S/4,S/2), (S/2,S), 3)
    pygame.draw.line(ACCEPT, WHITE, (S,0), (S/2,S), 3)

def drawPlayer(num):
    player = termFont.render(" Jugador %d " % num, True, BLACK, PLAYER_COLOR[num])    
    screen.blit(player, centerInFrame(player.get_rect(), quadrant(1+num)))

def drawYouAre():
    pres = termFont.render("<- usted es", True, WHITE)
    screen.blit(pres, centerInFrame(pres.get_rect(), quadrant(3)))

def drawTitle(text):
    text = termFont.render(text, True, WHITE)
    screen.blit(text, centerInFrame(text.get_rect(), half(0)))

def drawTitle2(text):
    text = termFont.render(text, True, WHITE)
    screen.blit(text, centerInFrame(text.get_rect(), screen.get_rect()))

def drawOffer(offer, bw=False):
    offer = ["% 4d " % n for n in [offer, TOP_OFFER - offer]]
    sfce  = [numFont.render(t,True,WHITE) for t in offer]
    rects = [fn(s.get_rect(), quadrant(q)) for fn, s, q in
             zip([rightInFrame,leftInFrame], sfce, [2,3])]
    border = H / 96
    for s, r, player in zip(sfce, rects, [1,2]):
        screen.blit(s, r)
        if bw:
            color = (164 - 48 * player, ) * 3
        else:
            color = PLAYER_COLOR[player]
        pygame.draw.rect(screen, color, r.inflate(border, border), border/2)

def drawSign(accept):
    signRect = centerInFrame(ACCEPT.get_rect(), screen.get_rect())
    sign = ACCEPT if accept else REJECT
    screen.blit(sign, signRect)

def drawFix():
    s = H / 64.0
    pygame.draw.line(screen, WHITE, (W/2-s, H/2), (W/2+s, H/2), 3)
    pygame.draw.line(screen, WHITE, (W/2, H/2-s), (W/2, H/2+s), 3)

def drawTotals(total1, total2):
    total = ["% 5d " % n for n in [total1, total2]]
    sfce  = [termFont.render(t,True,WHITE) for t in total]
    rects = [centerInFrame(s.get_rect(), quadrant(q)) for s, q in
             zip(sfce, [2,3])]
    border = H / 64
    for s, r, player in zip(sfce, rects, [1,2]):
        screen.blit(s, r)
        color = PLAYER_COLOR[player]
        pygame.draw.rect(screen, color, r.inflate(border, border), border/2)

def drawPlayerTitle(num):
    player = termFont.render(" Jugador %d " % num, True, WHITE)
    screen.blit(player, centerInFrame(player.get_rect(), vhalf(num-1)))

# Screens
#########


def showImage(fn):
    deleteScreen()
    img = pygame.transform.smoothscale(pygame.image.load(fn), (H*4 / 3, H))
    screen.blit( img, ( (W - (H*4/3))/2, 0 ) )
    pygame.display.update()

def screenImage(fn, keys):
    showImage(fn)
    while not getKey() in keys:
        pass

def screenPresent():
    deleteScreen()
    drawTitle("Ahora va a comenzar un juego nuevo")
    drawPlayer(1)
    drawYouAre()
    pygame.display.update()
    pygame.time.delay(2000)

def screenConnecting(test=False):
    deleteScreen()
    drawTitle2("Conectando ...")
    pygame.display.update()
    pygame.time.delay(1000)
    drawPlayer(1)
    pygame.display.update()
    delay = 2000 if test else random.randint(2000,6000)
    startConnectingTime = pygame.time.get_ticks()
    while (pygame.time.get_ticks() - startConnectingTime) < delay:
        ndots = (pygame.time.get_ticks() / 500) % 4
        deleteScreen()
        drawAnim()
        drawTitle2("Conectando %s%s" % ("." * ndots, " " * (4-ndots)))
        drawPlayer(1)
        pygame.display.update()
        pygame.time.delay(20)
    deleteScreen()
    drawTitle2("Conectado")
    drawPlayer(1)
    drawPlayer(2)
    pygame.display.update()
    pygame.time.delay(2000)

def screenStartRound(text):
    deleteScreen()
    drawTitle(text)
    pygame.display.update()
   # eci.synchronize()
    pygame.time.delay(3000)

def screenOffer(gameState, test):
    offer = TOP_OFFER
    deleteScreen()
    drawOffer(offer)
    if not test:
        tiempo_respuesta = blink()
        gameState.guardar_en_log_temporal(tiempo_respuesta)

    pygame.display.update()
    lastOffer = TOP_OFFER
    tiempo_respuesta = []
    opcion_respuesta = []
    historial_saldo = [offer]
    while True:
        key = getKey()
        if key == 1 and offer < TOP_OFFER:
            offer += 10
            sendMark(1)
            opcion_respuesta.append('incremento')
            historial_saldo.append(offer)
        elif key == 2 and offer > 0:
            offer -= 10
            sendMark(2)
            opcion_respuesta.append('decremento')
            historial_saldo.append(offer)
        elif key == 3:
            sendMark(3)
            break
        elif key == -1:
            finalize()
 
        if offer != lastOffer:
            lastOffer = offer
            deleteScreen()
            drawOffer(offer)
            log_respuesta = blink()
            tiempo_respuesta.append(log_respuesta)
            pygame.display.update()

    if not test:
        gameState.guardar_en_log_temporal(tiempo_respuesta)
        gameState.guardar_en_log_temporal(opcion_respuesta)
        gameState.guardar_en_log_temporal(historial_saldo)

    gameState.newOffer(offer)

def screenWaitAnswer(gameState, test):
    deleteScreen()
    drawTitle2("?")
    drawOffer(gameState.offer)
    code = 22 if test_mode else 20

    if not test:
        tiempo_respuesta = blink()
        gameState.guardar_en_log_temporal(tiempo_respuesta)

    pygame.display.update()
    sendMark(code)
    pygame.time.delay(random.randint(1000- TIME_BLINK,4000- TIME_BLINK))

def screenShowAnswer(gameState, test):
    deleteScreen()
    drawSign(gameState.answer)
    drawOffer(gameState.offer, not gameState.answer)
    codes = [52,53] if test_mode else [50, 51]

    if not test:
        tiempo_respuesta = blink()
        gameState.guardar_en_log_temporal(tiempo_respuesta)

    pygame.display.update()
    sendMark(codes[gameState.answer])
    pygame.time.delay(1000 - TIME_BLINK)

def screenFix():
    deleteScreen()
    drawTitle("Mira fijamente la cruz, evitando parpadear")
    drawFix()
    pygame.display.update()
    pygame.time.delay(2000)
    deleteScreen()
    drawFix()
    pygame.display.update()
    sendMark(11)
    pygame.time.delay(10000)
    sendMark(12)

def screenTotal(gameState, test):
    deleteScreen()
    drawPlayerTitle(1)
    drawPlayerTitle(2)
    drawTotals(gameState.total1, gameState.total2)

    if not test:
        tiempo_respuesta = blink()
        gameState.guardar_en_log_temporal(tiempo_respuesta)
        gameState.log()

    pygame.display.update()
    pygame.time.delay(3000-TIME_BLINK)

def blink():
    pygame.draw.rect(screen, WHITE, RECTANGULO_BLINK)
    pygame.display.update()
    tiempo = pygame.time.get_ticks()
    pygame.time.delay(TIME_BLINK)
    pygame.draw.rect(screen, BLACK, RECTANGULO_BLINK)
    return tiempo

def playMovie():
    screen.fill(BLACK)
    pygame.display.update()
    movie = pygame.movie.Movie('web_streaming.mpg')
    MH = H * 0.8
    MW = W * 0.8
    y = (H - MH) / 2.0
    x = (W - MW) / 2.0
    movie.set_display(screen, pygame.Rect(x,y,MW,MH))
    movie.play()
    while movie.get_busy():
        pygame.time.delay(100)


# Procedure
###########

def proc(gameState, numTrials, title, test=False):
    screenStartRound(title)
    if not test:
        screenFix()
    screenConnecting(test)
    for i in range(numTrials):
        screenOffer(gameState, test)
        screenWaitAnswer(gameState, test)
        gameState.simAnswer()
        if not test:
            gameState.guardar_en_log_temporal(gameState.answer)

        screenShowAnswer(gameState, test)

        if not test:
            gameState.guardar_en_log_temporal(gameState.total1)
            gameState.guardar_en_log_temporal(gameState.total2)
            gameState.log()

    screenTotal(gameState)    


try:

    # start procedure
    RUN_FILENAME_PREFIX = makeFilename()
    FILENAME_PREFIX = RUN_FILENAME_PREFIX + "_test"
    makeImages()
    screenImage("intro1.png", [1,2,3,4,-1])
    screenImage("intro2.png", [1,2,3,4,-1])
    screenImage("intro3.png", [1,2,3,4,-1])
    screenPresent()
    test_mode = True

    # ECI init
    #EciDevice = eci.ECI_Device if ECI else eci.DummyEciDevice
    #eci = EciDevice(eci_address, eci_port, pygame.time.get_ticks)
    #try:
    #    eci.connect()
    #except:
    #    print ("Could not connect to ECI device. Check address at top of script.")

    #eci.initiate()
    #eci.record()

    # Practice
    if PRACTICE:
        for i in range(2):
            testGameState = GameState(1)
            sendMark(30)
            proc(testGameState, 2, "Juego de prueba", True)
        screenStartRound("Ahora comienzan los juegos reales")

        # Actual game
        opponents = range(10)
        random.shuffle(opponents)
        test_mode = False
        playMovie()
        FILENAME_PREFIX = RUN_FILENAME_PREFIX
        for i in range(TASK_REPETITIONS):
            gameState = GameState(opponents[i])
            proc(gameState, 20, "Juego con otra persona")
            gameState.writeResults()
            if i == (TASK_REPETITIONS/2 - 1):
                pause()
            gameState.guardar_log()

    screenImage("end.png", [-1])

except:
    e = sys.exc_info()[0]
    print e
    sys.exit(0)

