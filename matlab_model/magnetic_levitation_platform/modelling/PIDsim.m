%{
Simulates the system controlled by a PID controller equivalent to the one
implemented on the Teensy microcontroller.
Requires PIDfun.m to function
%}
clear; close all;
%% Adding functions folder to path
addpath('../maglevFunctions');
%%
approximationType = 0;
load('params.mat');

%% Initializing the system
if approximationType == 0
    params.levitatingmagnet.ri = 0.02;
    params.levitatingmagnet.ro = 0.02;
end

x0 = zeros(12,1); x0(3) = 0.047;
sys = maglevSystem(x0, params, approximationType);

figure(1);
clf; grid on; hold on; daspect([1,1,1]); view([47,15])
draw(sys, 'fancy')
%% Declaring PID parameters
PIDparams.KPx = 1; 
PIDparams.KIx = 0; 
PIDparams.KDx = 0;

PIDparams.KPy = 1; 
PIDparams.KIy = 0; 
PIDparams.KDy = 0;

PIDparams.KPz = 1; 
PIDparams.KIz = 0; 
PIDparams.KDz = 0;

r = sys.h(x0, zeros(4,1)); % Getting reference sensor reading
PIDparams.rx = 0; PIDparams.ry = 0; PIDparams.rz = r(9);

%% Simulating the system
x0(3) = 1.0*x0(3);
tspan = linspace(0,3,500);
[t,x] = ode45(@(t,x) odefunc(t,x,sys, PIDparams),tspan,x0);

%% Plotting the results
figure(2)
hold on;
plot(t,x(:,1))
plot(t,x(:,2))
plot(t,x(:,3))
legend('x','y','z');
hold off;
grid;
ylim([0 0.1])
xlim([0 2])

figure(3)
hold on;
plot(t,x(:,4))
plot(t,x(:,5))
plot(t,x(:,6))
legend('psi','theta','phi');
hold off;
grid;
ylim([-0.5 0.5])
xlim([0 2])
%%
function dxdt = odefunc(t, x, sys, PIDparams)
    persistent y
    if t == 0
        u = 0.00*ones(4,1);
    else
        u = PIDfun(y,PIDparams);
    end
    y = round(sys.h(x,u),4);
    temp = sys.f(x,u);
    dxdt = temp;  
end
