from math import pi, cos, sin
import math


curve_points = []
dt = (2*pi)/420
t = -pi/2

for i in range(420):
	cx = cos(t)/(1 + (sin(t))**2)
	cy = sin(t)*cos(t)/(1 + (sin(t))**2)

	curve_points.append(f'( re => to_ads_sfixed({cx: 3.5f}), im => to_ads_sfixed({cy: 3.5f}) )')

	t += dt

data = ",\n\t\t\t".join(curve_points)

with open('seed_table.vhdi') as file_in:
	for line in file_in:
		print(line.format(data=data), end='')