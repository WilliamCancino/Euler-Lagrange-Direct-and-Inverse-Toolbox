%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legends = ["$\theta_{0}$", "$\theta_{s}$", "$x$"];
ylabels = ["Angle [rad]", "Angle [rad]", "Length [m]"];
varargin_dp = {'Save', 'Ex07_dp.png'};
varargin_ip = {'Save', 'Ex07_ip.png'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIRECT PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time range
tt = linspace(0, 20, 1000); % linspace(start_time, end_time, sample_number)

% Symbolic variables
syms t
q = SymsWs(["th0", "ths", "x"], 'caller');
Dq = SymsWs(["Dth0", "Dths", "Dx"], 'caller');

% Constants
R = 5; r = 1; l = 2; 
M = 1; J = 1/2*M*r^2; m_0 = 3; m = "m_0"*exp(-t/3);
k = 30;
g = 9.81;
b1 = 0.5;
vconst = [R, r, l, M, J, m, k, g, b1];
lconst = SymsWs(["R", "r", "l", "M", "J", "m", "k", "g", "b1"], 'caller');
oconst = ["m_0" m_0];

% Rayleigh dissipation function
D = "1/2*b1*Dths^2";

% Kinetic and potential energy
VM = (R-r)*Dth0*[cos(th0), sin(th0)];
Wd  = (R-r)*Dth0/r;
Vm = (R-r)*Dth0*[cos(th0), -sin(th0)] + (l+x)*Dths*[cos(ths), -sin(ths)] + Dx*[sin(ths), cos(ths)];
yM = R-(R-r)*cos(th0);
ym = yM + (l+x)*(1-cos(ths));

T = 1/2*M*(VM*VM.') + 1/2*m*(Vm*Vm.') + 1/2*J*Wd^2;
V = M*g*yM + m*g*ym + 1/2*k*x^2;

% Lagrangian
L = T - V;

% External forces
F = [0; ...
     0; ... 
     0];

% Initial conditions
ic = [pi/8, pi/4, 0, 0, 0, 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INVERSE PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
le_const = SymsWs(["R", "r", "m_0"], 'caller'); % Parameters to be stimated

method = 7;         % Choose optimizer (you can also define the optimizer in the "RunInverse" function)
iter = 500;         % Number of iterations
x_L = [2 0.5 0.5];  % Lower limit of the search space  
x_H = [8 3 5];      % Upper limit of the search space
tolF = 1e-12;       % Tolerance in the change of the objective function in two consecutive iterations of the optimizer
tolX = 1e-12;       % Desired closeness between the solutions of two successive optimizer iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
