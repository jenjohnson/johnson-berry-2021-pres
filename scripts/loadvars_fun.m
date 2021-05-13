function [Q, T, C, O, ...
          Abs, beta, CB6F, RUB, Rds, ...
          Kf, Kd, Kp1, Kn1, Kp2, Ku2, ...
          kq, nl, nc, kc, ko, Kc, Ko, ...
          alpha_opt, solve_xcs, ...
          theta1, eps1, eps2] = loadvars_fun(v)

% Rename default values of parameters passed in from 'v' structure

% Environmental variables
Q = v.Q;
T = v.T;
C = v.C;
O = v.O;

% Physiological variables
Abs = v.Abs;
beta = v.beta;
CB6F = v.CB6F;
RUB = v.RUB;
Rds = v.Rds;

% Photochemical constants
Kf = v.Kf;
Kd = v.Kd;
Kp1 = v.Kp1;
Kn1 = v.Kn1; 
Kp2 = v.Kp2;
Ku2 = v.Ku2;

% Biochemical constants
kq = v.kq;
nl = v.nl;
nc = v.nc;
kc = v.kc;
ko = v.ko;
Kc = v.Kc;
Ko = v.Ko;

% Others
alpha_opt = v.alpha_opt;
solve_xcs = v.solve_xcs;
theta1 = v.theta1;
eps1 = v.eps1;
eps2 = v.eps2;

end