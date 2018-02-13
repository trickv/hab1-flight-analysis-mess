#!/usr/bin/env python

import simplekml
import pynmea2 # FIXME, I don't have pynmea2 here at 34,000 ft so can't run/test this script

input_file = open("gps-log", "r")

coords=[]

while True:
    packet = pynmea2.parse(input_file.readline())
    entry = (row['lon'], row['lat'], row['alt']) # FIXME: add timestamp? that's the whole point.
    coords.append(entry)

kml = simplekml.Kml()
line = kml.newlinestring(name="path", description="must go faster", coords=coords)
kml.save("out.kml")
