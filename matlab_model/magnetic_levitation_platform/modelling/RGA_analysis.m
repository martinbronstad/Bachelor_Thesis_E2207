%{
Linearizes the magnetic levitation system and calculates the condition
number and Relative Gain Array (RGA)
%}

clear; close all;
%% Adding functions folder to path
addpath('../maglevFunctions');
%%
approximationType = 1;
load('params.mat');

%% Initializing the system
if approximationType == 0
    params.levitatingmagnet.ri = 0.02;
    params.levitatingmagnet.ro = 0.02;
end

eq = 0.047151515151515;             % Equilibrium z_eq

x0 = zeros(12,1); x0(3) = eq;
sys = maglevSystem(x0, params, approximationType);

figure(1);
clf; grid on; hold on; daspect([1,1,1]); view([47,15])
draw(sys, 'fancy')

%% Linearization of system
uLp = zeros(params.solenoids.N,1);
xLp = zeros(12,1); xLp(3) = eq;

delta = 1e-4;
A = zeros(12,12);
for i = 1:12
    A(:,i) = (sys.f(xLp+(i==1:12)'*delta,uLp)-sys.f(xLp-(i==1:12)'*delta,uLp))/(2*delta);
end


B = zeros(12,params.solenoids.N);
for i = 1:4
    B(:,i) = (sys.f(xLp,uLp+(i==1:4)'*delta)-sys.f(xLp,uLp-(i==1:4)'*delta))/(2*delta);
end


C = zeros(3*length(params.sensor.x),12);
for i = 1:12
    C(:,i) = (sys.h(xLp+(i==1:12)'*delta, uLp)-sys.h(xLp-(i==1:12)'*delta, uLp))/(2*delta);
end


D = zeros(9, 4);

%% State space to transfer function

Hc = [0 1 0 -1;1 0 -1 0;1 1 1 1]./510;  % Output matrix

ssModel = ss(A,B,C,D);  % State space model

tfModel = tf(ssModel);  % Creating a transfer matrix
G = [tfModel(1,:); tfModel(5,:); tfModel(9,:)];

H = Hc*G.';             % Open loop transfer matrix, H = Y/U

H0 = dcgain(H);         % Static gain array

%% Condition number and RGA
gamma = cond(H0);       % Condition number
LAMBDA = H0.*inv(H0);   % RGA