%{
Loads logged values from stabilt.txt and calculates the actual current in
the solenoids. A transfer function of the solenoid is created and it is taken a
step response of said transfer function
%}

clear; close all;
%% Adding functions folder to path
addpath('../maglevFunctions');

%% Set parameters
approximationType = 0;
load('params.mat');
load('stabilt.txt');

steps = 64515; % Number of steps from 0-4s for the stabilt.txt data

%% Load values from stabilt.txt to variables
u_x = zeros(1,steps);
u_y = zeros(1,steps);
u_z = zeros(1,steps);

for i = 1:steps 
    u_x(i) = stabilt(i,4);
    u_y(i) = stabilt(i,5);
    u_z(i) = stabilt(i,6);
end

%% Declare variables for old output algorithm

u_1 = 0; 
u_2 = 0; 
u_3 = 0;
u_4 = 0;
ux = 0;
uy = 0;
uz = 0;
u1 = zeros(1,steps);
u2 = zeros(1,steps);
u3 = zeros(1,steps);
u4 = zeros(1,steps);

%% Run a for loop for the output algorithm and store values
for i = 1:steps

    ux = u_x(i);
    uy = u_y(i);
    uz = abs(u_z(i));

    if ux >= 0
        u_1 = (ux - uz);
        u_3 = (ux + uz);

        if u_1 < 0
            u_1 = 255 + u_1;
        end
        if u_3 < 0
            u_3 = 255 + u_3;
        end

        u_3 = -u_3;
    else if ux < 0
            ux = abs(ux);
            u_1 = (ux + uz);
            u_3 = (ux - uz);

            if u_1 < 0
                u_1 = 255 + u_1
            end
            if u_3 < 0
                u_3 = 255 + u_3;
            end
            u_1 = -u_1;
    end
    end

    if uy >= 0
        u_2 = (uy - uz);
        u_4 = (uy + uz);

        if u_2 < 0
            u_2 = 255 + u_2;
        end
        if u_4 < 0
            u_4 = 255 + u_4;
        end
        u_4 = -u_4;
    else if uy < 0
            uy = abs(uy);
            u_2 = (uy + uz);
            u_4 = (uy - uz);

            if u_2 < 0
                u_2 = 255 + u_2;
            end
            if u_4 < 0
                u_4 = 255 + u_4;
            end
            u_2 = -u_2;
    end
    end
    
    u1(i) = u_1/512;
    u2(i) = u_2/512;
    u3(i) = u_3/512;
    u4(i) = u_4/512;
end
%% Defining the transfer function for the solenoid current

num = [0 10.3];
den = [0.604 14];
sys = tf(num,den)

%% Run a step function to verify the solenoid transfer function
figure(1)
hold on;
step(sys)
title('Step response solenoid')

%% Run the output on a solenoid with lsim, with a time delay of 4ms and plot

tspan = linspace(0,4,steps); %(3.344,3.844,8064) - 0.5 sec

figure(2);
clf;

subplot(2,2,1); 
grid on; hold on;
lsim(sys,u1,tspan)
title('Solenoid X_A')
xlim([3.5 4.0])

subplot(2,2,2);
grid on; hold on;
lsim(sys,u2,tspan)
title('Solenoid Y_A')
xlim([3.5 4.0])

subplot(2,2,3);
grid on; hold on;
lsim(sys,u3,tspan)
title('Solenoid X_B')
xlim([3.5 4.0])

subplot(2,2,4);
grid on; hold on;
lsim(sys,u4,tspan)
title('Solenoid Y_B')
xlim([3.5 4.0])