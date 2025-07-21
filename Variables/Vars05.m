%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legends = ["$x_{1}$", "$x_{2}$", "$\theta_{1}$", "$\theta_{2}$"];
ylabels = ["Length [m]", "Length [m]", "Angle [rad]", "Angle [rad]"];
varargin_dp = {'Save', 'Ex05_dp.png'};
varargin_ip = {'Save', 'Ex05_ip.png'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIRECT PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time range
tt = linspace(0, 15, 500); % linspace(start_time, end_time, sample_number)

% Symbolic variables
syms t
q = SymsWs(["x1", "x2", "th1", "th2"], 'caller');
Dq = SymsWs(["Dx1", "Dx2", "Dth1", "Dth2"], 'caller');

% Constants
k1 = 50; k2 = 100;
m1_0 = 2; m1 = "m1_0"*exp(-t/30); m2_0 = 4; m2 = "m2_0"*exp(-t/10);
l1 = 1; l2 = 1;
g = 9.81;
b1 = 0.6; b2 = 0.5;
vconst = [k1 k2 m1 m2 l1 l2 g b1 b2];
lconst = SymsWs(["k1" "k2" "m1" "m2" "l1" "l2" "g" "b1" "b2"], 'caller');
oconst = ["m1_0" m1_0 "m2_0" m2_0];

% Rayleigh dissipation function
D = "1/2*b1*Dth1^2 + 1/2*b2*Dth2^2";

% Kinetic and potential energy
v1x = Dx1*sin(th1) + (l1 + x1)*Dth1*cos(th1);
v1y = Dx1*cos(th1) - (l1 + x1)*Dth1*sin(th1);
v2x = Dx1*sin(th1) + (l1 + x1)*Dth1*cos(th1) + Dx2*sin(th2) + (l2 + x2)*Dth2*cos(th2);
v2y = Dx1*cos(th1) - (l1 + x1)*Dth1*sin(th1) + Dx2*cos(th2) - (l2 + x2)*Dth2*sin(th2);
v1t = v1x^2 + v1y^2; 
v2t = v2x^2 + v2y^2; 
T = 1/2*m1*v1t + 1/2*m2*v2t;

V1 = -m1*g*((l1 + x1)*cos(th1)) + 1/2*k1*x1^2;
V2 = -m2*g*((l1 + x1)*cos(th1) + (l2 + x2)*cos(th2)) + 1/2*k2*x2^2;
V = V1 + V2;

% Lagrangian
L = T - V;

% External forces
F = [0;                                     ...
     0;                                     ...
     2*(heaviside(t-3)-heaviside(t-4));     ...
     0];

% Initial conditions
ic = [0, 0, pi/3, 2*pi/3, 0, 0, 0, 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INVERSE PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
le_const = SymsWs(["m1_0" "m2_0" "l1"], 'caller'); % Parameters to be stimated

method = 3;                             % Choose optimizer (you can also define the optimizer in the "RunInverse" function)
iter = 10;                             % Number of iterations
x_L = [1 2 0.5];                        % Lower limit of the search space  
x_H = [3 5 2];                          % Upper limit of the search space
tolF = 1e-12;                           % Tolerance in the change of the objective function in two consecutive iterations of the optimizer
tolX = 1e-12;                           % Desired closeness between the solutions of two successive optimizer iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
