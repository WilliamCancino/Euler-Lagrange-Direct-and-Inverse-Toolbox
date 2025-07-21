% PURPOSE:
%   This function selects and runs the appropriate animation function
%   based on the system number ("num_anim"). It extracts the corresponding
%   generalized coordinates from the solution matrix ("xx") and calls
%   the relevant 'AnimatorXX.m' script to animate the system.
%
% INPUTS:
%   num_anim - (Integer) ID of the system to animate.
%   xx       - (Matrix) Time evolution of the generalized coordinates.
%              Each row is a time step; each column is a coordinate.
%   tt       - (Vector) Time vector corresponding to the rows of "xx".
%   lconst   - (String Array, Optional) Symbolic names of the system parameters
%              (e.g., ["l1", "m1"]).
%   vconst   - (Vector, Optional) Numerical values of the system parameters.
%
% OUTPUTS:
%   This function generates and displays the system animation.
%
% AUTHOR:
%   William Cancino, 2023


function ChooseAnim(num_anim, xx, tt, lconst, vconst)

    % For animation 6 and 7, two more arguments are necessary
    if (nargin<5) && ismember(num_anim, [6 7])
        error('Not enough input arguments. At least five arguments are required.');
    end

    % Define the animation
    switch num_anim
        case 1
            Animator01(xx(:,1:2), tt)
        case 2
            Animator02(xx(:,1:2), tt)
        case 3
            Animator03(xx(:,1:2), tt)
        case 4
            Animator04(xx(:,1:3), tt)
        case 5
            Animator05(xx(:,1:4), tt)
        case 6
            [~, idx] = ismember(lconst, ["l0", "l1", "l2"]);
            idx = idx(idx>0);
            params = double(vconst(idx));
            Animator06(xx(:,1:2), tt, params)
        case 7
            [~, idx] = ismember(lconst, ["R", "r", "l"]);
            idx = idx(idx>0);
            params = double(vconst(idx));
            Animator07(xx(:,1:3), tt, params)
    end
end
