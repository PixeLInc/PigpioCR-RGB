require "socket"
require "io/hexdump"

module Pigpio
  class RGB
    PI_OUTPUT = 1
    PWM_RANGE = 500
    PWM_FREQUENCY = 800

    getter client : Pigpio::Client

    def initialize(host : String, port : Int32, @red_pin : UInt32, @green_pin : UInt32, @blue_pin : UInt32)
      socket = TCPSocket.new(host, port)
     ## io = IO::Hexdump.new(socket, output: STDOUT, read: true, write: true)

      @client = Pigpio::Client.new(host, port)
    end

    # 0-100
    def set_color(red : UInt32, green : UInt32, blue : UInt32)
      client.command(Client::Command::PWM, @red_pin, ((100 - red)*255/100))
      client.command(Client::Command::PWM, @green_pin, ((100 - green)*255/100))
      client.command(Client::Command::PWM, @blue_pin, ((100- blue)*255/100))
    end

    def color
      red = client.command(Client::Command::GET_PWM, @red_pin, 0)
      green = client.command(Client::Command::GET_PWM, @blue_pin, 0)
      blue = client.command(Client::Command::GET_PWM, @green_pin, 0)

      {red: red, green: green, blue: blue}
    end

    def cycle(rate = 20.milliseconds)
      (0..255).each do |i|
        yield({i, 255 - i})
        sleep rate
      end
    end

    def rainbow
      red = 0
      green = 0
      blue = 255

      cycle do |up, down|
        red = up
        green = down

        self.set_color(red.to_u, green.to_u, blue.to_u)
      end

      cycle do |up, down|
        green = up
        blue = down

        self.set_color(red.to_u, green.to_u, blue.to_u)
      end

      cycle do |up, down|
        blue = up
        red = down

        self.set_color(red.to_u, green.to_u, blue.to_u)
      end
    end

    def terminate
      set_color(0_u32, 0_u32, 0_u32)

      client.command(Client::Command::TERMINATE, 0, 0)
      client.close
    end
  end

  class Client
    def self.new(address : String = "localhost", port : Int32 = 8888)
      new(TCPSocket.new(address, port))
    end

    getter socket : IO
    delegate close, to: socket

    enum Command
      TERMINATE = 21
      HANDLE = 99
      PWM = 5
      GET_PWM = 22
    end

    def initialize(@socket : IO)
    end

    def command(cmd : Command, gpio : UInt32, intensity : Int32)
      socket.write_bytes(cmd.value)
      socket.write_bytes(gpio)
      socket.write_bytes(intensity)
      socket.write_bytes(0)

      socket.skip(12)
      socket.read_bytes(Int32)
    end
  end
end
