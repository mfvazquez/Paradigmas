################################################################
# EGI Experimental Control Protocol module for Python
#
# This module allows controlling an EGI data acquisition
# system. It can be used to write experiments in Python. The
# implementation covers sending ECI commands though TCP/IP
# using a high level interface.
#
# eci_command.py -- Utility classes for building ECI command
#                   strings.
#
# Copyright 2008, Esteban Hurtado, eahurtad@ing.puc.cl
#
# Writing this piece of software required information taken
# from the GES Hardware Technical manual (S-MAN-200-COMR-001),
# copyrighted by Electrical Geodesics, Inc (2006)
################################################################

from array import array

class Command:
    """EGI Experimental Control Interface command object (abstract).
    Member variable 'machine' determines the type of experimental control
    machine (master). Possible values are 'NTEL' (Intel), 'UNIX', or 'MAC-'.
    It is important to correctly set this 4 character value, since integer
    endianess is handled by the DAC machine according to this information.
    """

    machine = 'NTEL'

    def __init__(self):
        "Constructor."
        self.data = None

    def long2raw(self, value):
        "Converts signed long integer (32 bit) to a string containing 4 bytes of raw data"
        return array('l', [value]).tostring()

    def doub2raw(self, value):
        "Converts double precision float (64 bit) to a string containing 8 bytes of raw data"
        return array('d', [value]).tostring()

    def int2byte(self, value):
        "Converts a signded integer to a raw byte."
        if value > 127 or value < -128:
            raise RuntimeError, "Integer out of range when converting to 8 bit."
        return array('B', [value]).tostring()

    def int2short(self, value):
        "Converts a signded short integer (16 bit) to a 2 byte string containing raw data."
        if value > (2**15 - 1) or value < -(2**15):
            raise RuntimeError, "Integer out of range when converting to 16 bit."
        return array('h', [value]).tostring()

    def checkanswer(self, ans):
        "Checks whether an answer string correspond to the expected."
        code = ans[0]
        if code == 'Z':     # 'Z' means OK.
            return
        elif code == 'F':   # 'Fss' means error, ss is the short int error code.
            raise RuntimeError, \
                "Data acquisition machine answered that it received " + \
                "an undefined or misformed command."
        else:
            raise RuntimeError, \
                "Data acquisition machine answered with an unknown code."

    def getdata(self):
        """Returns EGI formatted binary data for the command."""
        return self.data

class Initiate(Command):
    "Initiate command (Qcccc)."

    def __init__(self):
        Command.__init__(self)
        if self.machine not in ["NTEL", "UNIX", "MAC-"]:
            raise RuntimeError, \
                "Machine type '%s' not recognized. " + \
                "Please set Command.machine to a" + \
                "valid descriptor ('NTEL', 'UNIX', or 'MAC-')."
        self.data = "Q" + self.machine
        self.protocolversion = None
        
    def checkanswer(self, ans):
        "Checks whether an answer string correspond to the expected."
        print ans
        code = ans[0]
        if code == 'I':   # 'Ib' means init OK with protocol version b.
            return
        elif code == 'F': # 'Fss' means error, ss is the short int error code.
            raise RuntimeError, \
                "Data acquisition machine answered that it received " + \
                "an undefined or misformed command. Error number"
        else:
            raise RuntimeError, \
                "Data acquisition machine answered with an unknown code."


class Exit(Command):
    "Exit experiment command (X)"
    def __init__(self):
        Command.__init__(self)
        self.data = "X"

class BeginRecording(Command):
    "Begin recording command (B)"
    def __init__(self):
        Command.__init__(self)
        self.data = "B"

class EndRecording(Command):
    "End recording command (E)"
    def __init__(self):
        Command.__init__(self)
        self.data = "E"

class Attention(Command):
    "Attention command (A)"
    def __init__(self):
        Command.__init__(self)
        self.data = "A"

class Synchronize(Command):
    """Time synchronization command (Tllll).
    Should be sent as soon as it is buld for time accuracy to be kept.
    """
    def __init__(self, time):
        """Constructs a "Synchronize" command.
        time -- time in msec. as close as possible to when command will be sent
        """
        Command.__init__(self)
        self.data = "T" + self.long2raw(time)

class Event(Command):
    "Transmit event command (D)"
    def __init__(self, starttime, eventduration=0, \
                 typeevent="EVNT", label="ECI event", description="N/A"):
        """Constructs a "Transmit event" command object.
        You can later add EGI formatted metadata to the object using the
        addfield() method.
        
        starttime     -- event start time
        eventduration -- event duration
        typeevent     -- four character string specifying event type
        label         -- more descriptive label (max. 255 chars)
        description   -- event description (max. 255 chars)
        """
        Command.__init__(self)
        self.starttime = starttime
        self.eventduration = eventduration
        self.typeevent = typeevent
        self.label = label
        self.description = description
        self.fields = []

    def addfield(self, key, value):
        """Adds a key value pair to the event.
        key   -- metadata key
        value -- metadata value
        """
        if len(key) != 4:
            raise RuntimeError, \
            "Event field key must be exactly 4 characters long."
        datatype = None
        rawdata = None
        if type(value) == bool:
            datatype = 'bool'
            if value:
                rawdata = "\1"
            else:
                rawdata = "\0"
        elif type(value) == int:
            datatype = 'long'
            rawdata = self.long2raw(value)
        elif type(value) == float: # Note: python float is double precision.
            datatype = 'doub'
            rawdata = self.doub2raw(value)
        elif type(value) == str:
            if len(value) == 4 and value == value.upper():
                datatype = 'type'
            else:
                datatype = 'TEXT'
            rawdata = value
        else:
            datatype = 'TEXT'
            rawdata = str(value)
        self.fields.append( (key, datatype, rawdata) )

    def buildfield(self, field):
        # For internal use. Generates binary data for a field.
        key, datatype, rawdata = field
        return key + datatype + self.int2short(len(rawdata)) + rawdata

    def buildallfields(self):
        # For internal use. Generates binary data for all fields.
        data = self.int2byte( len(self.fields) )
        for field in self.fields:
            data += self.buildfield(field)
        return data

    def getdata(self):
        """Returns EGI formatted binary data for the transmit event command."""
        fields = self.buildallfields()
        datablock = self.long2raw(self.starttime) + \
                    self.long2raw(self.eventduration) + \
                    self.typeevent + \
                    self.int2byte( len(self.label) ) + \
                    self.label + \
                    self.int2byte( len(self.description) ) + \
                    self.description
        return 'D' + self.int2short( len(datablock) + len(fields) ) + datablock + fields


