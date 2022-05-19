function u = PIDfun(y,PIDparams)
    persistent previous_ex previous_ey previous_ez prev_u;
    
    if isempty(prev_u)
        prev_u = zeros(1,3);
        previous_ex = zeros(1,2);
        previous_ey = zeros(1,2);
        previous_ez = zeros(1,2);
    end
    KPx = PIDparams.KPx; 
    KIx = PIDparams.KIx; 
    KDx = PIDparams.KDx;

    KPy = PIDparams.KPy; 
    KIy = PIDparams.KIy; 
    KDy = PIDparams.KDy;

    KPz = PIDparams.KPz; 
    KIz = PIDparams.KIz;
    KDz = PIDparams.KDz;

    rx = PIDparams.rx; ry = PIDparams.ry; rz = PIDparams.rz;
   
    % Inputs x, y and z readings
    yx = y(1);
    yy = y(5);
    yz = y(9);

    % Measurement error
    ex = rx - yx;
    ey = ry - yy;
    ez = rz - yz;

    % Compute gain
    ux = prev_u(1) + KPx*(ex - previous_ex(1)) + KIx*ex + KDx*(ex - 2*previous_ex(1) + previous_ex(2));
    uy = prev_u(2) + KPy*(ey - previous_ey(1)) + KIy*ey + KDy*(ey - 2*previous_ey(1) + previous_ey(2));
    uz = prev_u(3) + KPz*(ez - previous_ez(1)) + KIz*ez + KDz*(ez - 2*previous_ez(1) + previous_ez(2));

    % Update values
    prev_u(1) = min(max(ux,-255),255);
    circshift(previous_ex,1);
    previous_ex(1) = ex;

    prev_u(2) = min(max(uy,-255),255);
    circshift(previous_ey,1);
    previous_ey(1) = ey;

    prev_u(3) = min(max(uz,-100),100);
    circshift(previous_ez,1);
    previous_ez(1) = ez;

    % Gain to current in solenoids (divided by 255/0.5):
    if yx >= 0 % positive x-position
        u_x1 = (-abs(ux) + uz)/510;
        u_x2 = uz/510;
    elseif yx < 0
        u_x1 = uz/510;
        u_x2 = (-abs(ux) + uz)/510;
    end
    
    if yy >= 0 % positive y-position
        u_y1 = (-abs(uy) + uz)/510;
        u_y2 = uz/510;
    elseif yy < 0
        u_y1 = uz/510;
        u_y2 = (-abs(uy) + uz)/510;
    end

    %% Saturation
    u_y1 = min(max(u_y1,-0.5),0.5);
    u_x1 = min(max(u_x1,-0.5),0.5);
    u_y2 = min(max(u_y2,-0.5),0.5);
    u_x2 = min(max(u_x2,-0.5),0.5);

    u = [u_y1 u_x1 u_y2 u_x2];
end