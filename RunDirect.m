% PURPOSE:
%   Solves the direct problem for a dynamic system defined in a Vars0X.m file.
%   Derives the equations of motion using the Euler-Lagrange formulation, 
%   solves them numerically, and visualizes the generalized coordinates over time.
%
% SYNTAX:
%   RunDirect(num_ex)
%   RunDirect(num_ex, opt_awgn)
%   RunDirect(num_ex, opt_awgn, dBs)
%
% INPUTS:
%   num_ex   - (Integer) ID of the system to simulate. Corresponds to a file
%              named 'Vars0X.m' in the /Variables folder.
%
%   opt_awgn - (String, Optional) Option to add noise:
%              'normal': No noise (default).
%              'noise' : Adds Gaussian noise.
%              'both'  : Shows both clean and noisy results.
%
%   dBs      - (Integer, Optional) Signal-to-noise ratio (in dB), 
%              required if opt_awgn is 'noise' or 'both'.
%
% OUTPUTS:
%   - Plot of the generalized coordinates over time.
%   - Animation of the system’s behavior.
%
% NOTES:
%   L : Symbolic expression of the Lagrangian (L = T - U or general form).
%   D : Symbolic Rayleigh dissipation function (optional), used to model energy loss.
%   The equations of motion are derived using the Euler-Lagrange equations:
%       d/dt(∂L/∂dq) - ∂L/∂q + ∂D/∂dq = Q
%
% AUTHOR:
%   William Cancino, 2023


function RunDirect(num_ex, opt_awgn, dBs)
    % Clean console and close figures
    clc, close all

    % If an option is not inserted, no noise is added
    if nargin<3, opt_awgn = 'normal'; end

    % Check if opt_awgn is valid
    if ~ismember(opt_awgn, ["normal", "noise", "both"])
        error('Invalid option. Only "normal", "noise" or "both" can be used')
    end
        
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
    
    % Solve the equations
    Eq = LagrangeDynamicEqDeriver(L, D, q, Dq) - F;
    [~, ~, xx] = DynamicEqSolver(Eq, q, Dq, lconst, vconst, tt, ic);
    
    % Title for the figure
    ftitle = 'Generalized coordinates';
    if ~strcmp(opt_awgn, "normal")
        ftitle = sprintf('Generalized coordinates with noise (%d dB)', dBs);
    end

    % Simulation
    if ismember(opt_awgn, ["both", "noise"]), xx_noise = AddNoise(xx, dBs); end
    if strcmp(opt_awgn, "both")
        legends = [legends, legends+"+noise"];
        varargin_dp = cat(2, varargin_dp, {'Other', xx_noise}); 
    end
    if strcmp(opt_awgn, "noise")
        legends = legends+"+noise";
        PlotEq(xx_noise, tt, ftitle, ylabels, legends, varargin_dp);
    else
        PlotEq(xx, tt, ftitle, ylabels, legends, varargin_dp);
    end
    
    % Animation
    ChooseAnim(num_ex, xx, tt, lconst, vconst)
end