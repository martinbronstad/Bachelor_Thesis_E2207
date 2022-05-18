import matplotlib.pyplot as plt

Raw_readings = []
LP_readings = []
Kalman_readings = []


with open ('Filterdata_norm_LP_KALMAN_10bit_4A_inside.txt') as file: #Open the datafiles, and splits them into the sensorvalues, and the microsecond the sensor was read
    file_content = file.read()
    Split = file_content.split('\n')
    for i in range(2500, 4000): # You change the range to determine how much data you want to parse, Max = len(Split)
        New_Split = Split[i].split(" ")
        Raw_readings.append(New_Split[0])
        LP_readings.append(New_Split[1])
        Kalman_readings.append(New_Split[2])
#print(Raw_readings)
#print(LP_readings)
#print(Kalman_readings)


#Maps the values from String to floats.
Raw_readings = map(float, Raw_readings)
LP_readings = map(float, LP_readings)
Kalman_readings = map(float, Kalman_readings)

Raw = list(Raw_readings)
LP = list(LP_readings)
Kalman = list(Kalman_readings)


plt.plot(range(0, len(Raw)), Raw, color="blue")
plt.plot(range(0, len(LP)), LP, color="red")
plt.plot(range(0, len(Kalman)), Kalman, color="yellow")
plt.figure(dpi=1000)
plt.show()



