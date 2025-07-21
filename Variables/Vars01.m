%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legends = ["$\theta_{1}$", "$\theta_{2}$"];
ylabels = ["Angle [rad]", "Angle [rad]"];
varargin_dp = {'Save', 'Ex01_dp.png'};
varargin_ip = {'Save', 'Ex01_ip.png'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIRECT PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time range
tt = linspace(0, 20, 500); % linspace(start_time, end_time, sample_number)

% Symbolic variables
syms t
q = SymsWs(["th1", "th2"], 'caller');
Dq = SymsWs(["Dth1", "Dth2"], 'caller');

% Constants
l1 = 0.5; l2 = 0.5; 
m1 = 1; J1 = 1/3*m1*(l1)^2; 
m2 = 10; J2 = 1/3*m2*(l2)^2;
g = 9.81;
b1 = 0.5; b2 = 0.2;
vconst = [l1 l2 m1 m2 J1 J2 g b1 b2]; 
lconst = SymsWs(["l1" "l2" "m1" "m2" "J1" "J2" "g" "b1" "b2"], 'caller');

% Rayleigh dissipation function
D = "1/2*b1*Dth1^2 + 1/2*b2*Dth2^2";

% Kinetic and potential energy
T1 = 1/2*J1*Dth1^2 + 1/2*m1*(l1/2*Dth1)^2;
Vc2_x = l1*Dth1*cos(th1) + l2/2*(Dth2)*cos(th2);
Vc2_y = l1*Dth1*sin(th1) + l2/2*(Dth2)*sin(th2);
Vc2 = sqrt(Vc2_x^2 + Vc2_y^2); 
T2 = 1/2*J2*(Dth2)^2 + 1/2*m2*Vc2^2;
T = T1 + T2;

V1 = m1*g*l1/2 * (1-cos(th1));
V2 = m2*g*(l1*(1-cos(th1)) + l2/2*(1-cos(th2)));
V = V1 + V2;

% Lagrangian
L = T - V;

% External forces
F = [0; ...
     0];

% Initial conditions
ic = [120, 30, 0, 0]/180*pi;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INVERSE PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
le_const = SymsWs(["l1" "l2" "m1" "m2" "J1" "J2" "b1" "b2"], 'caller'); % Parameters to be stimated

method = 3;                             % Choose optimizer (you can also define the optimizer in the "RunInverse" function)
iter = 100;                             % Number of iterations
x_L = [0.1 0.1 0.1 1 0.01 0.1 0.1 0.1]; % Lower limit of the search space  
x_H = [5 5 10 30 10 10 5 5];            % Upper limit of the search space
tolF = 1e-12;                           % Tolerance in the change of the objective function in two consecutive iterations of the optimizer
tolX = 1e-12;                           % Desired closeness between the solutions of two successive optimizer iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
