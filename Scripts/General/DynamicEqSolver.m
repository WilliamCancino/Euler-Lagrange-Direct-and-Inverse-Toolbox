% PURPOSE:
%   Automatically derives and solves the system’s dynamic equations based on 
%   a given symbolic equation set, converting them into state-space form.
%
% SINTAX:
%   [SS, X, xx] = DynamicEqSolver(Eq, q, Dq, ParamList, ParamVal, tspan, InitCnd)
%
% INPUTS:
%   Eq         - (Symbolic array) System of symbolic equations, typically obtained via Euler-Lagrange formulation.
%   q          - (Symbolic array) Generalized coordinates.
%   Dq         - (Symbolic array) First derivatives of generalized coordinates.
%   ParamList  - (Symbolic array) List of symbolic parameters present in Eq.
%   ParamVal   - (Array) Numerical values corresponding to ParamList.
%   tspan      - (Array) Time interval for simulation (e.g., [0 10]).
%   InitCnd    - (Array) Initial conditions for generalized coordinates and their derivatives.
%
% OUTPUTS:
%   SS         - (Symbolic array) Symbolic expression of the system in state-space form.
%   X          - (Symbolic array) State variables used in SS.
%   xx         - (Matrix) Time evolution of the generalized coordinates and their derivatives.
%
% AUTHOR:
%   Mansour Torabi, smtoraabi@ymail.com


function [SS, X, xx] = DynamicEqSolver(Eq, q, Dq, ParamList, ParamVal, tspan, InitCnd)

%% [1.1]: Convert Eq To State-Space Form:

N = length(Eq);

DDq = sym(zeros(1, N));
for ii = 1:N
    DDq(ii) = sym(['DD', char(q(ii))]);
end
%

% AA * X = BB;

AA = jacobian(Eq, DDq);
BB = -simplify(Eq - AA*DDq.');

DDQQ   = sym(zeros(N, 1));
DET_AA = det(AA);

for ii = 1:N   
    AAn       = AA;
    AAn(:,ii) = BB;
    DDQQ(ii)  = simplify(det(AAn) / DET_AA);
end

%% [1.2]: State Space formation - Final Step

SS = sym(zeros(N, 1));

for ii = 1:N
   SS (ii) = Dq(ii);
   SS (ii + N) = DDQQ(ii);   
end

%% [1.3]: Change variables from q to x

Q = [q, Dq];
X = sym('x_',[1 2*N]);
SS = subs(SS, Q, X);

%% [2.1] Solving ODEs

[ts, xx] = SsOdeSolver(SS, X, ParamList, ParamVal, tspan, InitCnd);