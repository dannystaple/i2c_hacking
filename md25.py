import serial

I2C_SGL=0x53
I2C_MUL=0x54
I2C_AD1=0x55
I2C_AD2=0x56
I2C_USB=0x5A

MD25_SPEED1 = 0
MD25_SPEED2 = 1
MD25_TURN = 1
MD25_ENC1A = 2
MD25_ENC1B = 3
MD25_ENC1C = 4
MD25_ENC1D = 5
MD25_ENC2A = 6
MD25_ENC2B = 7
MD25_ENC2C = 8
MD25_ENC2D = 9
MD25_BATTV = 10
MD25_M1_CRNT = 11
MD25_M2_CRNT = 12
MD25_SW_REV = 13
MD25_ACC = 14
MD25_MODE = 15
MD25_COMMAND = 16

#get writable hex codes - \xnn from an int number
def strToHex(number):
	return (hex(number)[2:]).zfill(2).decode('hex');

#Hex from list of numbers... Convert to hex string..
def toHex(listNum):
	return  "".join([strToHex(n) for n in listNum])
	
class md25:
	#devaddr -> int address of Md25 device on i2c bus.
	#portdetail -> Serial port of usb2i2c
	def __init__(self, portDetail, devAddr=0x80):
		self.ser = serial.Serial(portDetail, 19200, bytesize=8, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_TWO)
		self.devAddr = devAddr
		self.ser.setTimeout(500)

	def __del__(self):
		self.ser.close()
		
	#@param value - List of values
	def writeReg(self, regAddr, value):
		command = toHex([I2C_AD1, self.devAddr, regAddr, len(value)] +  value)
		print "Sending " + command.encode('hex') + "\n"
		self.ser.write(command)

	#regaddr -> int register
	#ser -> serial object
	def readReg(self, regAddr, size):
		command = toHex([I2C_SGL, self.devAddr, regAddr])
		print "Sending " + command.encode('hex') + "\n"
		self.ser.write(command)
		if(self.ser.read(1) != strToHex(1)):
			raise Exception("Device send failed\n")
		command = toHex([I2C_SGL, self.devAddr | 0x1])
		print "Sending " + command.encode('hex') + "\n"
		self.ser.write(command)
		return self.ser.read(size)

	
	#signed -> true if the values are signed
	#turn -> true if second register is a turn value
	def setMode(self, signed=0, turn=1):
		mode =0
		if turn:
			mode = 2
		if signed:
			mode += 1
		self.writeReg(MD25_MODE, [mode])
	
	#Speed - 
	def setTMSpeed(self, speed):
		self.writeReg(MD25_SPEED1, [speed])
	
	def setTurn(self, turn):
		self.writeReg(MD25_TURN, [turn])
	
	def getVersion(self):
		return self.readReg(MD25_SW_REV, 1)
		
	def getBatteryV(self):
		return self.readReg(MD25_BATTV, 1)

	
