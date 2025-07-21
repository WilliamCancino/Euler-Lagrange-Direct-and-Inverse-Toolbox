%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legends = ["$x$", "$\theta_{1}$", "$\theta_{2}$"];
ylabels = ["Length [m]", "Angle [rad]", "Angle [rad]"];
varargin_dp = {'Save', 'Ex04_dp.png'};
varargin_ip = {'Save', 'Ex04_ip.png'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIRECT PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time range
tt = linspace(0, 35, 1000); % linspace(start_time, end_time, sample_number)

% Symbolic variables
syms t
q = SymsWs(["x", "th1", "th2"], 'caller');
Dq = SymsWs(["Dx", "Dth1", "Dth2"], 'caller');

% Constants
l1 = 1; l2 = 1; 
M_0 = 1; M = "M_0"*exp(-t/4); m1 = 0.5; m2 = 2;
g = 9.81;
b2 = 0.5;
vconst = [l1 l2 M m1 m2 g b2];
lconst = SymsWs(["l1" "l2" "M" "m1" "m2" "g" "b2"], 'caller');
oconst = ["M_0", M_0];

% Rayleigh dissipation function
D = "1/2*b2*Dx^2";
%D = "1/2*b2*Dth2^2";

% Kinetic and potential energy
v1x = l1*Dth1*cos(th1) + Dx;
v1y = l1*Dth1*sin(th1);
v2x = l1*Dth1*cos(th1) + l2*Dth2*cos(th2) + Dx;
v2y = l1*Dth1*sin(th1) + l2*Dth2*sin(th2);
v1t = v1x^2 + v1y^2; 
v2t = v2x^2 + v2y^2; 
T = 1/2*M*Dx^2 + 1/2*m1*v1t + 1/2*m2*v2t;

V1 = m1*g*l1*(1-cos(th1));
V2 = m2*g*(l1*(1-cos(th1))+l2*(1-cos(th2)));
V = V1 + V2;

% Lagrangian
L = T - V;

% External forces
F = [(heaviside(t-15)-heaviside(t-16));      ...
     0;                                        ...
     -5*(heaviside(t-3)-heaviside(t-4))];

% Initial conditions
ic = [0, pi/3, 2*pi/3, 0, 0, 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INVERSE PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
le_const = SymsWs(["l1" "l2" "m1" "M_0"], 'caller');    % Parameters to be stimated

method = 7;                 % Choose optimizer (you can also define the optimizer in the "RunInverse" function)
iter = 80;                  % Number of iterations
x_L = [0.8 0.8 0.2 0.6];    % Lower limit of the search space          
x_H = [4 4 1 2];            % Upper limit of the search space
tolF = 1e-12;               % Tolerance in the change of the objective function in two consecutive iterations of the optimizer
tolX = 1e-12;               % Desired closeness between the solutions of two successive optimizer iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
