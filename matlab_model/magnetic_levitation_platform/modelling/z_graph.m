%{
Produces the z-graph for n=size(R) systems with different permanent magnet
radiuses
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

R = [0.075, 0.080, 0.085, 0.090];   % Magnet radiuses to test
sys = cell(length(R),1);

for i = 1:length(R)
    params.magnets.R = R(i);
    sys(i) = {maglevSystem(x0, params, approximationType)};
end

%% Z-graph

zr = linspace(0,0.1,100);
Fz = zeros(size(zr));
labels = cell(length(R),1);

figure(1)
hold on;

for j = 1:length(R)
    for k = 1:length(zr)
        temp = sys{j}.f([0,0,zr(k),zeros(1,9)]',zeros(params.solenoids.N,1));
        Fz(k) = temp(9);
    end
    
    plot(zr,Fz, 'LineWidth', 2)
    labels{j} = strcat('R = ', num2str(R(j)));
end

plot(zr,zeros(size(zr)),'black--', 'linewidth', 2)
ylabel('$F_z$','interpreter','latex','fontsize',20)
xlabel('$z$','interpreter','latex','fontsize',20)
title('Z-plot','interpreter','latex','fontsize',15)
grid; hold off; legend(labels);