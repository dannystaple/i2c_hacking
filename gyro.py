"""http://www.parallax.com/portals/0/downloads/docs/prod/sens/27911-GyroscopeL3G4200DDatasheet.pdf"""
import serial

I2C_SGL=0x53
I2C_MUL=0x54
I2C_AD1=0x55
I2C_AD2=0x56
I2C_USB=0x5A


def str_to_hex(number):
  r"""get writable hex codes - \x nn from an int number"""
  return (hex(number)[2:]).zfill(2).decode('hex')


def to_hex(listNum):
  """Hex from list of numbers... Convert to hex string.."""
  return  "".join([str_to_hex(n) for n in listNum])


def encode_hex_str(data):
  return [elem.encode('hex') for elem in data]


class USBI2CBus(object):
  """An USB i2c bus device and its operations - """
  def __init__(self, port_detail):
    """Initialise the device"""
    self.ser = serial.Serial(port_detail, 19200, bytesize=8, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_TWO)
    self.ser.setTimeout(500)

  def __del__(self):
    self.ser.close()

  def _encode_send(self, commands):
    command = to_hex(commands)
    print "Sending " + command.encode('hex') + "\n"
    self.ser.write(command)
    
  def write_reg(self, dev_addr, regAddr, value):
    """Write a register."""
    self._encode_send([I2C_AD1, dev_addr, regAddr, len(value)] + value)

  def read_reg(self, dev_addr, reg_addr, size):
    """
    devAddr -> device address
    regaddr -> int register
    ser -> serial object"""
    self._encode_send([I2C_AD1, dev_addr | 0x1, reg_addr, size])
    return self.ser.read(size)

  def read_reg2(self, dev_addr, reg_addr_h, reg_addr_l, size):
    """
    devAddr -> device address
    regaddr -> int register
    ser -> serial object"""
    self._encode_send([I2C_AD2, dev_addr | 0x1, reg_addr_h, reg_addr_l, size])
    return self.ser.read(size)
  
  @property
  def revision(self):
    """Read the board revision"""
    self._encode_send([I2C_USB, 1, 0, 0])
    return self.ser.read(1)
    

GRYO_SLAVE0_ADDR = 0xD4
GRYO_SLAVE1_ADDR = 0xD6


class I2CGyro(object):
  def __init__(self, bus, addr):
    self.addr = addr
    self.bus = bus
  
  @property
  def who_am_i(self):
    return self.bus.read_reg(self.addr, 0x0F, 1)

  @property
  def temperature(self):
    return self.bus.read_reg(self.addr, 0x26, 1)


def main():
  port_detail = "COM10"
  print "Doing setup"
  bus = USBI2CBus(port_detail)
  print "Bus device revision ", encode_hex_str(bus.revision)
  print "Bus set up"
  gyro = I2CGyro(bus, GRYO_SLAVE0_ADDR)
  print "Gyro device created"
  #Read who ami
  print encode_hex_str(gyro.who_am_i)
  print "Temp?"
  print encode_hex_str(gyro.temperature)


if __name__ == "__main__":
    main()

