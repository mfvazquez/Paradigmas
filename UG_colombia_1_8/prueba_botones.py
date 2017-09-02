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

win = visual.Window(size=[GetSystemMetrics(0), GetSystemMetrics(1)], fullscr=True, screen=0, allowGUI=True, monitor=u'testMonitor', color=[-1, -1, -1], colorSpace=u'rgb')

event.clearEvents()
theseKeys = event.waitKeys()


win.mouseVisible = False
key = event.waitKeys()
visual.TextStim(win, pos=[0, -0.65], height=(0.3 * 0.3), wrapWidth=1.8,text=str(key)).draw()
win.flip()
	
core.wait(2)
event.waitKeys()	
	
win.close()