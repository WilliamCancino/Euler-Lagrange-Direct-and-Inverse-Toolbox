%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legends = ["$\theta$", "$x$"];
ylabels = ["Angle [rad]", "Length [m]"];
varargin_dp = {'Save', 'Ex02_dp.png'};
varargin_ip = {'Save', 'Ex02_ip.png'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIRECT PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time range
tt = linspace(0, 20, 600); % linspace(start_time, end_time, sample_number)

% Symbolic variables
syms t
q = SymsWs(["th", "x"], 'caller');
Dq = SymsWs(["Dth", "Dx"], 'caller');

% Constants
m_0 = 1; m = "m_0"*exp(-t/8); 
l = 1; 
k = 30; 
g = 9.81;
b1 = 0.8; b2 = 0.8;
vconst = [m l k g b1 b2];
lconst = SymsWs(["m", "l", "k", "g", "b1", "b2"], 'caller');
oconst = ["m_0" m_0];

% Rayleigh dissipation function
D = "1/2*b1*Dth^2 + 1/2*b2*Dx^2";

% Kinetic and potential energy
T = 1/2*m*(Dx^2 + (l + x)^2*Dth^2);
V = -m*g*(l+x)*cos(th) + 1/2*k*x^2;

% Lagrangian
L = T - V;

% External forces
F = [10*(heaviside(t-8)-heaviside(t-8.5)); ... 
     1*sin(2*pi*(1/0.5)*t)];

% Initial conditions
ic = [45/180*pi, 0.1, 0, 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INVERSE PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
le_const = SymsWs(["m_0" "l" "b1" "b2"], 'caller'); % Parameters to be stimated

method = 7;                             % Choose optimizer (you can also define the optimizer in the "RunInverse" function)
iter = 1;                             % Number of iterations
x_L = [0.3 0.5 0.1 0.1];                % Lower limit of the search space  
x_H = [4 4 2 2];                        % Upper limit of the search space
tolF = 1e-12;                           % Tolerance in the change of the objective function in two consecutive iterations of the optimizer
tolX = 1e-12;                           % Desired closeness between the solutions of two successive optimizer iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%