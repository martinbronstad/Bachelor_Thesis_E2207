function Mr = rotationMatrix(alpha,beta,gamma)
    Mr =[
        cos(beta)*cos(gamma), cos(gamma)*sin(alpha)*sin(beta) - cos(alpha)*sin(gamma), sin(alpha)*sin(gamma) + cos(alpha)*cos(gamma)*sin(beta), 0;
        cos(beta)*sin(gamma), cos(alpha)*cos(gamma) + sin(alpha)*sin(beta)*sin(gamma), cos(alpha)*sin(beta)*sin(gamma) - cos(gamma)*sin(alpha), 0;
        -sin(beta), cos(beta)*sin(alpha), cos(alpha)*cos(beta), 0;
        0,0,0,1
        ];
end