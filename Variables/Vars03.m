%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legends = ["$\theta$", "$x$"];
ylabels = ["Angle [rad]", "Length [m]"];
varargin_dp = {'Save', 'Ex03_dp.png'};
varargin_ip = {'Save', 'Ex03_ip.png'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIRECT PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time range
tt = linspace(0, 20, 400); % linspace(start_time, end_time, sample_number)

%Symbolic variables
syms t
q = SymsWs(["th", "x"], 'caller');
Dq = SymsWs(["Dth", "Dx"], 'caller');

% Constants
l = 2;
M_0 = 1; M = "M_0"*exp(-t/5); m = 0.5;
k = 20;
g = 9.81;
b1 = 0.5; b2 = 0.2;
vconst = [l M m k g b1 b2];
lconst = SymsWs(["l" "M" "m" "k" "g" "b1" "b2"], 'caller');
oconst = ["M_0", M_0];

% Rayleigh dissipation function
D = "1/2*b1*Dth^2 + 1/2*b2*Dx^2";

% Kinetic and potential energy
Vx2 = (Dx + l*Dth*cos(th))^2 + (l*Dth*sin(th))^2;
T   = 1/2*m*Vx2 + 1/2*M*Dx^2;
V = m*g*l*(1-cos(th)) + 1/2*k*x^2;

% Lagrangian
L = T - V;

% External forces
F = [1; ... 
     10*(heaviside(t-8)-heaviside(t-8.5))];

% Initial conditions
ic = [45/180*pi, 0, 0, 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INVERSE PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
le_const = SymsWs(["l" "m" "k" "M_0" "b2"], 'caller');  % Parameters to be stimated

method = 3;                 % Choose optimizer (you can also define the optimizer in the "RunInverse" function)
iter = 50;                  % Number of iterations 
x_L = [0.1 0.1 1 0.1 0.1];  % Lower limit of the search space
x_H = [10 1 40 1 1];        % Upper limit of the search space
tolF = 1e-12;               % Tolerance in the change of the objective function in two consecutive iterations of the optimizer
tolX = 1e-12;               % Desired closeness between the solutions of two successive optimizer iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
