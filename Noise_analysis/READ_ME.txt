This code parses the sensor data given in the other text documents located here.

The formatting for the data is:
Line 1: Sensordata from the first reading
Line 2: Microseconds from the start of the code at the point of the first sensor reading
Line 3: Sensordata from the second reading
Line 4: Sensordata from the start of the code at the point of the second sensor reading.
and so forth.....

Sensor_data_10bit_4A_inside: ADC resolution set to 10 bits, ADC Averaging set to 4
Sensor_data_12bit_4A_inside: ADC resolution set to 12 bits, ADC Averaging set to 4.


In Old_noise_data there is old data from previous tests where the microcontroller was connected to the system through cables from the outside.



The microsecond recording is not that important, but shows that the sample rate was stable and could be used to determine the Hz of the noise

To get a better look at the signal you should open the code in an IDE to change some variables.