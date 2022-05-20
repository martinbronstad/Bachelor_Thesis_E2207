import matplotlib.pyplot as plt

Raw_readings = []
LP_readings = []
Kalman_readings = []


with open ('Filterdata_norm_LP_KALMAN_10bit_4A_inside.txt') as file:
    file_content = file.read()
    Split = file_content.split('\n')
    for i in range(151000, 211000): # You change the range to determine how much data you want to parse, Max = len(Split)
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



plt.figure(dpi=400)
plt.step(range(0, len(Raw)), Raw, color="blue", label="rawdata", where="post")
plt.step(range(0, len(Kalman)), Kalman, color="yellow", label="Kalman", where="post")
plt.step(range(0, len(LP)), LP, color="red", label="LP", where="post")
plt.legend()
#plt.savefig("Filter_speed.svg", format="svg")
plt.show()



