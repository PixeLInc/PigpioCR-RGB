require "socket"
require "./binding"
require "json"

class Pigpio::IPC
  
  getter socket
  getter rgb
  
  def initialize(@rgb : Pigpio::RGB, port : Int32 = 4456)
    @socket = TCPServer.new(port)
  end
  
  # For the most part, we'll just be listening in instead of sending data besides maybe some echos
  def handle_client(client)
    loop do
      message = client.gets
      if message.nil?
        puts "#{client.remote_address.address} disconnected."
        break
      end

      puts "Message receieved: #{message.inspect}"
      # now, let's parse up that json
      json = JSON.parse(message)

      # we want the client to send us the intensity of each value (R, G, B)
      intensity = json["colors"]? # Should be an Array(Int32)
      if intensity.nil?
        # echo back right away telling them they suck
        client << "#{{error: "Missing 'colors' key."}.to_json}\n"
        next
      end
      
      # TODO: More error checking / validation
      @rgb.set_color(intensity[0].as_i.to_u, intensity[1].as_i.to_u, intensity[2].as_i.to_u)
    end
  end
  
  # This is a blocking operation
  def run
    puts "Waiting for clients..."
    while client = @socket.accept?
      puts "Client accepted from #{client.remote_address.address}"
      spawn handle_client(client)
    end
  end
  
end
