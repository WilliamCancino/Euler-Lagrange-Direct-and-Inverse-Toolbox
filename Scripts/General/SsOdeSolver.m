% PURPOSE:
%   Solves a symbolic state-space system using MATLAB's ODE solver by substituting 
%   parameter values and converting the system into a numerical function.
%
% SINTAX:
%   [ts, xx] = SsOdeSolver(SS, X, ParamList, ParamVal, tspan, InitCnd)
%
% INPUTS:
%   SS         - (Symbolic array) Symbolic state-space system.
%   X          - (Symbolic array) State variable vector (generalized coordinates and their derivatives).
%   ParamList  - (Symbolic array) List of symbolic parameters to be replaced.
%   ParamVal   - (Array) Numerical values corresponding to ParamList.
%   tspan      - (Array) Time range for simulation.
%   InitCnd    - (Array) Initial conditions for state variables.
%
% OUTPUTS:
%   ts         - (Array) Time vector for the solution.
%   xx         - (Matrix) Time response of the state variables.
%
% AUTHOR:
%   William Cancino, 2023


function [ts, xx] = SsOdeSolver(SS, X, ParamList, ParamVal, tspan, InitCnd)
    syms t
    N = length(X)/2;

    % Convert the state matrix to a function of ordinary differential equation   
    SS_0 = subs(SS, ParamList, ParamVal);
    SS_ode0 = matlabFunction(SS_0, 'vars', {X, t});
    SS_ode = @(t, x)SS_ode0(x(1:2*N)',t);

    % ODE solver
    [ts, xx] = ode45(SS_ode, tspan, InitCnd);
end