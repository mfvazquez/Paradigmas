"""
	 # This is a get_ticks() function simple example
	 # This script should return 10 as a result
"""
# Standard library imports
import time
# Related third party imports
import pygame
#Pygame start function

pygame.init()
a = pygame.time.get_ticks()
pygame.time.wait(20)
b = pygame.time.get_ticks()
print a-b

a = pygame.time.get_ticks()
pygame.time.delay(20)
b = pygame.time.get_ticks()
print a-b
