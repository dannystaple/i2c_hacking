#Led control
require 'rubygems'
require 'serialport'

def sp
  SerialPort.new "/dev/tty.usbserial-A80078qR",19200
end

class LedControl
	def red
		"Z\020\v\000"
	end

 	def green
		"Z\020\a\000"
	end
	
	def lednone
		"Z\020\003\000"
	end
	
	def set_serial(sp)
		@sp = sp
	end
	
	def alternate tick, count
		count.times do
		  @sp.write red
		  sleep tick
		  @sp.write green
		  sleep tick
	  end
  end
  
  def pwm_inner color, tick1, tick2, count
    count.times do
      @sp.write color
      sleep tick1
      @sp.write lednone
      sleep tick2
    end
  end
  
  def pwm color, base, ratio, count
    high = base * ratio
    low = base * (1 - ratio)
    pwm_inner color, high, low, count
  end
end
