#I2c memory control
require 'rubygems'
require 'serialport'

def sp
  SerialPort.new "/dev/tty.usbserial-A80078qR",19200
end

def pic01mem
  "dan-01 Development Board\nRS-232 test\nPress ENTER\000"
end

class UsbI2c
  def initialize(port)
    @ser = port
    @ser.read_timeout=1000
  end
  
  def i2c_adi_read dev_addr, start_addr, count
    command = [0x55,dev_addr | 1, start_addr ,count]
    command = command.pack 'C'*command.length
    puts command.unpack 'h2*'
    @ser.write command
    @ser.read
  end
  
  def i2c_adi_write dev_addr, start_addr, bytes
    command = [0x55, dev_addr, start_addr, bytes.length]
    bincommand = command.pack 'C'*command.length
    bincommand += bytes
    @ser.write bincommand
  end
  
  def i2c_sgl_read dev_addr
    command = [0x53,dev_addr | 1]
    bincommand = command.pack 'C'*command.length
    @ser.write bincommand
    @ser.read
  end
end

class At24C02
  def initialize(i2c)
    @i2c = i2c
  end
  
  def size
    256
  end
  
  def dev_addr
    0xA0
  end
  
  def readbytes(start_addr, count)
    @i2c.i2c_adi_read dev_addr, start_addr, count
  end
  
  def writebytes(start_addr, bytes)
    @i2c.i2c_adi_write dev_addr, start_addr, bytes
  end
  
  #You'll get pretty odd behaviour if you've never sent an address to the device.
  def read_next_byte
    @i2c.i2c_sgl_read dev_addr
  end
end
