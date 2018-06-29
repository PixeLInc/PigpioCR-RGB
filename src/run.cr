require "./ipc"

rgb = Pigpio::RGB.new("localhost", 8888, 23_u32, 24_u32, 25_u32)
server = Pigpio::IPC.new(rgb, port: 4456)
server.run
