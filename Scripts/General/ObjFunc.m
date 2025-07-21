% PURPOSE:
%   Computes the root mean square error (RMSE) between measured and estimated 
%   generalized coordinates for a given parameter set. Useful for parameter estimation
%   in dynamic systems via inverse problem formulations.
%
% SYNTAX:
%   rmse = ObjFunc(SS, X, lconst, P, orig_const, xx_exp, tspan, ic)
%
% INPUTS:
%   SS         - (Symbolic array) Symbolic state-space system.
%   X          - (Symbolic array) State variable vector (generalized coordinates and their derivatives).
%   lconst     - (Symbolic array) Ordered list of all symbolic parameters of the system.
%   P          - (Numeric array) Values of the parameters to be estimated.
%   orig_const - (Numeric array) Values of the fixed parameters (not being estimated).
%   xx_exp     - (Matrix) Measured data of generalized coordinates and their derivatives.
%   tspan      - (Array) Time span for the simulation.
%   ic         - (Array) Initial conditions for the simulation.
%
% OUTPUTS:
%   rmse       - (Scalar) Root mean square error between estimated and measured signals.
%
% AUTHOR:
%   William Cancino, 2023


function rmse = ObjFunc(SS, X, lconst, P, orig_const, xx_exp, tspan, ic)
    span = 1:(size(xx_exp,2)/2);
    vconst = [P orig_const];
    [~, xx_est] = SsOdeSolver(SS, X, lconst, vconst, tspan, ic);
    se = xx_exp(:, span) - xx_est(:, span);
    rmse = sqrt(mean(se(:).^2));
end