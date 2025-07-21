% PURPOSE:
%   Solves the inverse problem for a dynamic system described by the 
%   Euler–Lagrange formalism. Given noisy measurements of the generalized 
%   coordinates over time, this function estimates unknown system parameters 
%   by minimizing the error between estimated and measured trajectories.
%
% SYNTAX:
%   RunInverse(num_ex, dBs, method)
%
% INPUTS:
%   num_ex - (Integer) ID of the system to be analyzed, corresponding to 
%            the file 'Vars0<num_ex>.m' located in the /Variables folder.
%
%   dBs    - (Scalar, Optional) Signal-to-Noise Ratio in decibels (dB) used 
%            to corrupt the reference generalized coordinates and simulate 
%            the measured data. Default is 20 dB.
%
%   method - (String or Integer, Optional) Optimization algorithm used to 
%            solve the inverse problem. Options include:
%              'TRD' or 1 : Trust-Region-Dogleg
%              'LMA' or 2 : Levenberg-Marquardt
%              'PSO' or 3 : Particle Swarm Optimization (default)
%              'GA'  or 4 : Genetic Algorithm
%              'SOS' or 5 : Stochastic Optimization Strategy
%              'SA'  or 6 : Simulated Annealing
%              'PS'  or 7 : Pattern Search
%              'TRR' or 8 : Trust-Region-Reflective
%
% OUTPUTS:
%   - Plots comparing:
%       * Estimated vs. Measured generalized coordinates.
%       * Estimated vs. Reference (clean) generalized coordinates.
%   - A table summarizing reference and estimated values of the system 
%     parameters.
%
% AUTHOR:
%   William Cancino, 2023


function RunInverse(num_ex, dBs, method)
    % Clean console and close figures
    clc, close all

    % Default values for method and dBs
    if nargin<3, method = 'PSO'; end
    if nargin<2, dBs = 20; end
    
    % Calling scripts
    addpath(genpath('Scripts/'))
    
    % Add variables
    run("Variables/Vars0"+string(num_ex)+".m")

    % Update constants, Lagrangian and Rayleigh dissipation function
    D = str2sym(D);
    if exist('oconst', 'var')
        [L, D, lconst, vconst] = UpdateConst(L, D, lconst, vconst, oconst);
    else
        [L, D, lconst, vconst] = UpdateConst(L, D, lconst, vconst);
    end
    
    % Solving direct problem
    Eq = LagrangeDynamicEqDeriver(L, D, q, Dq) - F;
    [SS, X, xx] = DynamicEqSolver(Eq, q, Dq, lconst, vconst, tt, ic);
    
    % Generating the experimental values
    xx_exp = AddNoise(xx, dBs);
    
    % Obtaining constants will not be estimated
    cond = ~ismember(lconst, le_const);
    lo_const = lconst(cond);
    vo_const = vconst(cond);

    % New le_const
    le_const = lconst(~cond);
    
    % Reorder the array "lconst"
    lconst = [le_const lo_const];
    
    % Number of parameters to be estimated
    N = length(le_const);
    
    % Initial values for the search process
    y0 = (rand(1,N).*(x_H-x_L)) + x_L;
    
    % Choose method
    switch method
        case {1, 'TRD'}    
            options = optimset('MaxFunEvals', iter*3, 'MaxIter', iter, 'TolX', tolX, 'Algorithm', 'trust-region-dogleg', 'Display', 'iter');
            [P, fval, exitflag, output] = fsolve(@(P) ObjFunc(SS, X, lconst, P, vo_const, xx_exp, tt, ic), y0, options);
            
        case {2, 'LMA'}
            options = optimset('MaxFunEvals', iter*3, 'MaxIter', iter, 'TolX', tolX, 'Algorithm', 'levenberg-marquardt', 'Display', 'iter');
            [P, fval, exitflag, output] = fsolve(@(P) ObjFunc(SS, X, lconst, P, vo_const, xx_exp, tt, ic), y0, options);
            
        case {3, 'PSO'}        
            options = optimoptions(@particleswarm, 'MaxIterations', iter, 'FunctionTolerance', tolF, 'Display', 'iter', 'UseParallel', true, 'SwarmSize', 100);
            [P, fval, exitflag, output] = particleswarm(@(P) ObjFunc(SS, X, lconst, P, vo_const, xx_exp, tt, ic), N, x_L, x_H, options);
    
        case {4, 'GA'}
            options = optimoptions(@ga, 'MaxGenerations', iter, 'FunctionTolerance', tolF, 'Display', 'iter', 'UseParallel', true);
            [P, fval, exitflag, output] = ga(@(P) ObjFunc(SS, X, lconst, P, vo_const, xx_exp, tt, ic), N, [], [], [], [], x_L, x_H, [], options);
    
        case {5, 'SOS'}
            params = struct('ecosize', 100, 'Tol', tolX, 'maxFE', iter*1e3, 'globalMin', tolF);
            P = SOS(@(P) ObjFunc(SS, X, lconst, P, vo_const, xx_exp, tt, ic), N, x_L, x_H, params);
            
        case {6, 'SA'}
            options = optimoptions('simulannealbnd', 'MaxIterations', iter*10, 'FunctionTolerance', tolF, 'Display', 'iter');
            [P, fval, exitflag, output] = simulannealbnd(@(P) ObjFunc(SS, X, lconst, P, vo_const, xx_exp, tt, ic), y0, x_L, x_H, options);
    
        case {7, 'PS'}
            options = optimoptions(@patternsearch, 'MaxIterations', iter*10, 'FunctionTolerance', tolF, 'Display', 'iter', 'UseParallel', true);
            [P, fval, exitflag, output] = patternsearch(@(P) ObjFunc(SS, X, lconst, P, vo_const, xx_exp, tt, ic), y0, [], [], [], [], x_L, x_H, [], options);
            
        case {8, 'TRR'}
            options = optimoptions('lsqnonlin', 'Algorithm', 'trust-region-reflective', 'Display', 'iter', 'MaxIterations', iter, 'FunctionTolerance', tolF, 'StepTolerance', tolX);
            [P, resnorm, residual, exitflag, output] = lsqnonlin(@(P) ObjFunc(SS, X, lconst, P, vo_const, xx_exp, tt, ic), y0, x_L, x_H, options);
    end
    
    % Obtain estimated values
    [~, xx_est] = SsOdeSolver(SS, X, lconst, [P, vo_const], tt, ic);

    % Find the name of the image to save
    sv_idx = find(strcmp(varargin_ip, 'Save'))+1;
    dvd = string(split(varargin_ip{sv_idx}, '.'));

    % Set the name file for each figure
    varargin1 = varargin_ip;
    varargin2 = varargin_ip;    
    varargin1{sv_idx} = char(dvd(1)+"_ee."+dvd(2));
    varargin2{sv_idx} = char(dvd(1)+"_oe."+dvd(2));
    
    % Plot experimental and estimated values
    figure(1)
    ftitle1 = sprintf("Experimental and estimated values");
    lgds1 = [legends+" - Estimated" legends+" - Experimental"];
    PlotEq(xx_est, tt, ftitle1, ylabels, lgds1, [varargin1 'Other' xx_exp]);
    
    % Plot original and estimated values
    figure(2)
    ftitle2 = sprintf("Original and estimated values");
    lgds2 = [legends+" - Estimated" legends+" - Original"];
    PlotEq(xx_est, tt, ftitle2, ylabels, lgds2, [varargin2 'Other' xx]);
    
    % Table comparing the original values with the estimated values
    total = [string(lconst(:)), ...
             [string(vconst(~cond)'); string(vo_const')], ... 
             [string(P(:)); repmat('-', length(vo_const), 1)]];
    final = array2table(total, 'VariableNames', {'Constant','Original','Estimated'});
    disp(final)
end