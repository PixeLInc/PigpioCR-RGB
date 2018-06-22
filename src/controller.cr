require "./binding"

pig = Pigpio::RGB.new("localhost", 8888, 23_u32, 24_u32, 25_u32)

pig.set_color(50_u32, 0_u32, 50_u32)
pig.terminate
