import matplotlib.pyplot as plt
Sensor_readings = []
Time_readings = []



with open ('Sensor_data_10bit_4A_inside.txt') as file: #Open the datafiles, and splits them into the sensorvalues, and the microsecond the sensor was read
    file_content = file.read()
    Split = file_content.split('\n')
    for i in range(201, 401): # You change the range to determine how much data you want to parse, Max = len(Split)
        if (i % 2) == 0:
            Sensor_readings.append(Split[i])
        else:
            Time_readings.append(Split[i])

#Maps the values from String to floats.
Sensor_readings = map(float, Sensor_readings)
Time_readings = map(float, Time_readings)
Sensor = list(Sensor_readings)
Time = list(Time_readings)

plt.figure(dpi=200)
plt.plot(range(0, len(Sensor)), Sensor)

plt.show()

#print(Sensor)
#print(Datapoints)
#print(len(Datapoints))

Microcheck = [] # This calculates the steplength in microseconds, was used in debugging to check if the step length is stable.
for i in range(len(Time)-1):
    Microcheck.append(Time[1+i] - Time[i])
MICROS = sum(Microcheck)/len(Microcheck)
#print(Time)
print(Microcheck)
print(MICROS)

Datapoints = ([i for i,x in enumerate(Sensor) if x>=512]) # Checks at which datapoints the values the specific value or higher is found, and how many
#print(Datapoints)

Differances = [] # This show the step length between the values found in Datapoints, and gives an average.
for i in range(len(Datapoints)-1):
    Differances.append(Datapoints[1+i] - Datapoints[i])
Averages = sum(Differances)/len(Differances)

print(Differances)
print(Averages)

Realdata = []
for i in range (0, len(Differances)): #This is used to check the step differances beteeen different tops.
    if Differances[i] >= 5:
        Realdata.append(Differances[i])

print(Realdata)
print(sum(Realdata)/len(Realdata))

