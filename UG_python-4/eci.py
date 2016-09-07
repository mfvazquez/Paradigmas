################################################################
# EGI Experimental Control Protocol module for Python
#
# This module allows controlling an EGI data acquisition
# system. It can be used to write experiments in Python. The
# implementation covers sending ECI commands though TCP/IP
# using a high level interface.
#
# eci.py -- Proxy to the slave data acquisition machine.
#
# Copyright 2008, Esteban Hurtado, eahurtad@ing.puc.cl
#
# Writing this piece of software required information taken
# from the GES Hardware Technical manual (S-MAN-200-COMR-001),
# copyrighted by Electrical Geodesics, Inc (2006)
################################################################

import socket
import eci_command as command
from array import array

class ECI_Device:
    """Abstraction of a data acquisition slave device subject to EGI
    Experimental Control Protocol.
    """

    def __init__(self, dac_address, dac_port, gettime):
        """Constructor.
        dac_address -- network address of the DAC machine
        dac_port    -- socket port where the DAC machine is listening
        gettime     -- function that returns current time in msecs
        """
        self.__address = dac_address
        self.__port = dac_port
        self.__socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.connected = False
        self.__time = gettime
        self.protocol_version = None

    def connect(self):
        """Opens TCP/IP connection to DAC."""
        self.__socket.settimeout(10.0)
        self.__socket.connect( (self.__address, self.__port) )
        self.connected = True

    def disconnect(self):
        """Closes TCP/IP connection to DAC."""
        self.__socket.close()
        self.connected = False

    def send(self, command):
        """Sends a command to the data-acquisition machine.
        command -- an ECI_Command object
        """
        # Send command string.
        data = command.getdata()
        datalen = len(data)
        sentbytes = 0
        while sentbytes < datalen:
            sent = self.__socket.send( data[sentbytes:] )
            if sent == 0:
                raise RuntimeError, "ECI device connection lost."
            sentbytes += sent
        # Receive answer.
        ans = self.__socket.recv(1)
        #print ans,
        if ans == 'I':
            ver = self.__socket.recv(1)
            a = array('B')
            a.fromstring(ver)
            self.protocol_version = a[0]
            #print self.protocol_version
        elif ans == 'Z':
            pass
            #print 'Ok'
        elif ans == 'F':
            err = self.__socket.recv(2)
            a = array('H')
            a.fromstring(err)
            print "ECI DAC says error", a[0]

    def initiate(self):
        """Initiates communication with DAC machine."""
        if not self.connected:
            self.connect()
        self.send( command.Initiate() )

    def finalize(self):
        """Ends comunication with DAC machine."""
        self.send( command.Exit() )
        #self.disconnect()

    def synchronize(self):
        """Synchronizes experimental control and DAC machines clocks."""
        self.send( command.Attention() )
        self.send( command.Synchronize(self.__time()) )

    def record(self):
        """Starts data acquisition."""
        self.synchronize()
        self.send( command.BeginRecording() )

    def stop(self):
        """Stops the recording."""
        self.send( command.EndRecording() )
        
    def sendevent(self, time=None, duration=0, evttype="EVNT", label="ECI event", \
                  description="N/A", metadata = {}):
        """Builds a "transmit event" command object and sends it to the DAC
        machine. Time unit is msec. Time must previously be synchronized by
        sending an "Attention" and then a "Synchronize" command. All these is
        handled automatically by the synchronize() method.
        
        time        -- event start time
        duration    -- event duration
        evttype     -- four character string specifying event type
        label       -- more descriptive label (max. 255 chars)
        description -- event description (max. 255 chars)
        metadata    -- dictionary with four character keys and metadata values
        """
        if time == None:
            time = self.__time()
        cmd = command.Event( time, duration, evttype, label, description)
        for k, v in metadata.iteritems():
            cmd.addfield(k, v)
        self.send( cmd )

    def sock(self):
        return self.__socket


class DummyEciDevice:
    def __init__(self, dac_address, dac_port, gettime): pass
    def connect(self): pass
    def disconnect(self): pass
    def send(self, command): pass
    def initiate(self): pass
    def finalize(self): pass
    def synchronize(self): pass
    def record(self): pass
    def stop(self): pass
    def sendevent(self, time=None, duration=0, evttype="EVNT", label="ECI event", description="N/A", metadata = {}):
        print "EVENT type = %s" % evttype

    def sock(self): return None
