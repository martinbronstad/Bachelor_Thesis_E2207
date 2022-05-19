clear; close all;
%%
approximationType = 0;
load('params.mat');

if approximationType == 0
    params.levitatingmagnet.ri = 0.02;
    params.levitatingmagnet.ro = 0.02;
end

x0 = zeros(12,1); x0(3) = 0.0475;
sys = maglevSystem(x0, params, approximationType);

%% Force 3D plot

permRadius = linspace(0.05,0.1,50);

zr = linspace(0,0.08,50);
Fz = meshgrid(length(zr), length(permRadius));
eq = meshgrid(length(zr), length(permRadius));

for i = 1:length(permRadius)
    params.magnets.R = permRadius(i);
    sys = maglevSystem(x0, params, approximationType);
    
    
    for j = 1:length(zr)
        temp = sys.f([0,0,zr(j),zeros(1,9)]',zeros(params.solenoids.N,1));
        Fz(i,j) = temp(9);
        eq(i,j) = 0;
    end

end



figure(2)
surf(zr, permRadius, Fz)
hold on
surf(zr, permRadius, eq, 'FaceColor', 'r', 'LineStyle', ':')
hold off
zlim([-50 50])
xlabel('Levitating height');
ylabel('Permanent magnet radius');