This code parses the sensor data given in the other text documents located here.

The formatting for the data is:
Line 1: Sensordata from the first reading
Line 2: Microseconds from the start of the code at the point of the first sensor reading
Line 3: Sensordata from the second reading
Line 4: Sensordata from the start of the code at the point of the second sensor reading.
and so forth.....

Additional parameters: 10 bit resolution on the ADC.
For test A and C, ADC averaging was put on 4.

The documents labeled A are readings taken while there was no external magnetic force applied to the system.
The documents labeled B are readings taken at the same setup as "A", but the averaging from the ADC is turned off.
The documents labeled C are readings taken while the magnet was approximatly 43 mm up from the sensors of the system. NB! This placement might be quite inaccurate.
The documents labeled D are readings taken at the same setup as "C", but with the averaging from the ADC turned off.
See the pictures for referance.


The microsecond recording is not that important, but shows that the sample rate was stable at 64-65 microseconds per sample for A and C. And at around 19-20 for B.

To get a better look at the signal you should open the code in an IDE to change some variables.