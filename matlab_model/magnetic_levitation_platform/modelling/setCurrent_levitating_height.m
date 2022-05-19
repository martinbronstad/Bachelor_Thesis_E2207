clear all; close all;
%% Adding functions folder to path
addpath('../maglevFunctions');

%% General parameters
approximationType = 0; % 0 = fast, 1 = accurate
approximationModel = 0; % 0 = neodymium, 1 = ring magnet
levitating_magnet = 0; % 0 = neodymium, 1 = levitating magnet

levitating_height_ring = 0.06;
levitating_height_neo = 0.09; %neo vs neo = 9cm, neo vs lev = 6,5cm

min_value = zeros(2,1);
max_value = zeros(2,1);
k = 1;

% Solenoid parameters - small
params.solenoids.ri = 0;    % Inner radius 0.005
params.solenoids.ro = 0;    % Outer radius 0.015
params.solenoids.h  = 0.03;     % Height 0.03
params.solenoids.nr = 20;       % Number of rings in radius (NOTE: #windings = nr*nh) = 500
params.solenoids.nh = 20;       % Number of rings in height
params.solenoids.nl = 100;      % Number of discrtization points in rings

params.solenoids.N  = 1;        % Number of solenoids in system
params.solenoids.R  = 0;     % Radius to place solenoids on (spaced out equally on radius)
params.solenoids.z_offset = 0.00;

% Neodymium magnet parameters
levitating_height = levitating_height_neo;
setcurrent = linspace(0,100,1000); %0:1000:3000; %0:100:2000
corresponding_current_lev = zeros(2,length(setcurrent));
corresponding_current_lev(1,:) = setcurrent(1,:);
params.magnets.ri   = 0.0025;
params.magnets.ro   = 0.016;    
params.magnets.h    = 0.015;    % Height: stack of 3 neodymium
params.magnets.nr   = 20;   
params.magnets.nh   = 25;    
params.magnets.nl   = 100;

params.magnets.N    = 1;     
params.magnets.R    = 0;
params.magnets.I    = 43.2163;       % Equivalent current for the magnet, simulated: 1404
params.magnets.offset = 0;      % Offset angle of the permanent magnets on the perm magnet ring


% Floating magnet parameters
if levitating_magnet
    params.levitatingmagnet.ri = 0.0;
    params.levitatingmagnet.ro = 0.03;    
    params.levitatingmagnet.h  = 0.005;     
    params.levitatingmagnet.nr = 20;   
    params.levitatingmagnet.nh = 25;    
    params.levitatingmagnet.nl = params.solenoids.nl;

    params.levitatingmagnet.I  = -288.8;  % Original reference: -3500, simulated: -288
    params.levitatingmagnet.m  = 0.117;   % Mass of levitating magnet
else
    params.levitatingmagnet.ri = 0.0025;
    params.levitatingmagnet.ro = 0.016;    
    params.levitatingmagnet.h  = 0.015;     
    params.levitatingmagnet.nr = 20;   
    params.levitatingmagnet.nh = 25;    
    params.levitatingmagnet.nl = params.solenoids.nl;

    params.levitatingmagnet.I  = -1404;  %Reference: -3500, simulated: -1404
    params.levitatingmagnet.m  = 0.072;   % Mass of levitating magnet
end

% Sensor parameters
params.sensor.x = [0]; % x position of sensors (length determines the number of sensors) - GREEN DOT in the plots
params.sensor.y = [0];
params.sensor.z = [0];

%% Plot selected maglev system

x0 = zeros(12,1); x0(3) = levitating_height;
sys = maglevSystem(x0, params, approximationType);

figure(1);
clf; grid on; hold on; daspect([1,1,1]); view([47,15])
draw(sys, 'fancy')

%% Finding the zero point for z graphs with different set currents

for j = 1:length(setcurrent)
    params.levitatingmagnet.I  = -setcurrent(j); % To simulate current in levitating magnet
    params.magnets.I = setcurrent(j);
    x0 = zeros(12,1); x0(3) = levitating_height;
    sys = maglevSystem(x0, params, approximationType);
    
    zr = linspace(0.01,0.1,1000);
    Fz = zeros(size(zr));
    
    for i = 1:length(zr)
        temp = sys.f([0,0,zr(i),zeros(1,9)]',zeros(params.solenoids.N,1));
        Fz(i) = temp(9);
    
        if Fz(i) < 0.1  && Fz(i) >= 0
           corresponding_current_lev(2,j) = zr(i);
        end
    end
end

%% Sort out upper and lower value

while corresponding_current_lev(2,k) < levitating_height
      k = k+1;
end
    
min_value(:,1) = [corresponding_current_lev(1,k-1);corresponding_current_lev(2,k-1)];
max_value(:,1) = [corresponding_current_lev(1,k);corresponding_current_lev(2,k)];
min_current = min_value(1,1);
min_lev = min_value(2,1);
max_current = max_value(1,1);
max_lev = max_value(2,1);

    for i = 1:10
        new_current = (min_current + max_current)/2;
        new_lev = (min_lev + max_lev)/2;
        if new_lev > levitating_height
            max_current = new_current;
            max_lev = new_lev;
        elseif new_lev < levitating_height
            min_current = new_current;
            min_lev = new_lev;
        elseif new_lev == levitating_height
            break
        end
    end

approx_current = new_current;
approx_lev = new_lev;

%% Plot the results

    %params.levitatingmagnet.I = -approx_current;
    params.magnets.I = 43.2163;
    params.levitatingmagnet.I = -approx_current;
    x0 = zeros(12,1); x0(3) = levitating_height;
    sys = maglevSystem(x0, params, approximationType);

    zr = linspace(0.01,0.15,1500);
    Fz = zeros(size(zr));

    for i = 1:length(zr)
        temp = sys.f([0,0,zr(i),zeros(1,9)]',zeros(params.solenoids.N,1));
        Fz(i) = temp(9);
    end

figure(2)
clf; grid on; hold on;
plot(zr,Fz, 'linewidth', 2)
plot(zr,zeros(size(zr)),'black--', 'linewidth', 2)
xline(approx_lev,'--r');
title('Set current: ', num2str(approx_current),'interpreter','latex')
ylabel('$F_z$','interpreter','latex','fontsize',20)
xlabel('$z$','interpreter','latex','fontsize',20)
ylim([-50 50])

figure(3)
clf; grid; hold on;
plot(corresponding_current_lev(1,:),corresponding_current_lev(2,:))
title('Levitating height: ', num2str(approx_lev),'interpreter','latex')
xline(approx_current,'--r');
yline(approx_lev,'--b');
ylabel('Levitating height','interpreter','latex','fontsize',15)
xlabel('Set current','interpreter','latex','fontsize',15)
if approximationType
    xlim([0 300])
else
    xlim([0 2000])
end