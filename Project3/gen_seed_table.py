from math import pi
import math


curve_points = []
dt = 2*math.pi/420

for i in range(420):
	cx = 1.5*math.sin(3*(i * dt-pi) + pi/2)
	cy = 1.5*math.sin(2*(i*dt-pi))

	curve_points.append(f'( re => to_ads_sfixed({cx: 3.5f}), im => to_ads_sfixed({cy: 3.5f}) )')

data = ",\n\t\t\t".join(curve_points)

with open('seed_table.vhdi') as file_in:
	for line in file_in:
		print(line.format(data=data), end='')