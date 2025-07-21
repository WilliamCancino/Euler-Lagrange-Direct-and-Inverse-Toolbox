%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legends = ["$\theta_{1}$", "$\theta_{2}$"];
ylabels = ["Angle [rad]", "Angle [rad]"];
varargin_dp = {'Save', 'Ex06_dp.png'};
varargin_ip = {'Save', 'Ex06_ip.png'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIRECT PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time range
tt = linspace(0, 20, 1000); % linspace(start_time, end_time, sample_number)

% Symbolic variables
syms t
q = SymsWs(["th1", "th2"], 'caller');
Dq = SymsWs(["Dth1", "Dth2"], 'caller');

% Constants
l0 = 2; l1 = 1; l2 = 1.5; l3 = 2; 
m1_0 = 4; m1 = "m1_0"*exp(-t/10); m2 = 3;
k = 20;
g = 9.81;
b2 = 2;
vconst = [l0 l1 l2 l3 m1 m2 k g b2];
lconst = SymsWs(["l0" "l1" "l2" "l3" "m1" "m2" "k" "g" "b2"], 'caller');
oconst = ["m1_0", m1_0];

% Rayleigh dissipation function
D = "1/2*b2*Dth2^2";

% Kinetic and potential energy
v1x = l1*Dth1*cos(th1) ;
v1y = -l1*Dth1*sin(th1);
v2x = l2*Dth2*cos(th2) ;
v2y = -l2*Dth2*sin(th2);
v1t = v1x^2 + v1y^2; 
v2t = v2x^2 + v2y^2; 
T = 1/2*m1*v1t + 1/2*m2*v2t;

dXX = l0 + l2*sin(th2) - l1*sin(th1);
dYY = l1*cos(th1) - l2*cos(th2);
dx = (dXX^2 + dYY^2)^0.5 - l3;
V1 = -m1*g*(l1*cos(th1)) + 1/2*k*dx^2;
V2 = -m2*g*(l2*cos(th2));
V = V1 + V2;

% Lagrangian
L = T - V;

% External forces
F = [5*sin(2*pi*0.5*t); ...
     0];

% Initial conditions
ic = [pi/6, pi/2.5, 0, 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INVERSE PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
le_const = SymsWs(["l1" "l2" "l3" "m2" "k" "b2"], 'caller');    % Parameters to be stimated

method = 3;                     % Choose optimizer (you can also define the optimizer in the "RunInverse" function)
iter = 80;                      % Number of iterations
x_L = [0.5 0.5 0.5 1 10 0.5];   % Lower limit of the search space
x_H = [5 5 5 5 30 5];           % Upper limit of the search space
tolF = 1e-12;                   % Tolerance in the change of the objective function in two consecutive iterations of the optimizer
tolX = 1e-12;                   % Desired closeness between the solutions of two successive optimizer iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
