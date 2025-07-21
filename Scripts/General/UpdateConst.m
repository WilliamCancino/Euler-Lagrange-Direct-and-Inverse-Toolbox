% PURPOSE:
%   Updates the symbolic expressions L (Lagrangian) and D (Rayleigh dissipation 
%   function) by replacing known symbolic constants with their corresponding values. 
%   Constants defined via symbolic expressions (e.g., k = m*g) are replaced only when 
%   all their symbolic dependencies are resolved via the optional oconst argument.
%
% SYNTAX:
%   [L, D, lconst, vconst] = UpdateConst(L, D, lconst, vconst)
%   [L, D, lconst, vconst] = UpdateConst(L, D, lconst, vconst, oconst)
%
% INPUTS:
%   L       - (Symbolic) Lagrangian of the system.
%   D       - (Symbolic) Rayleigh dissipation function.
%   lconst  - (1×N sym array) Symbolic constants used in L and D.
%   vconst  - (1×N array) Numeric or symbolic expressions associated with lconst.
%   oconst  - (Optional, 1×(2M) cell array) Additional constant-value pairs used to 
%             evaluate symbolic expressions in vconst. Format: {'c1', val1, 'c2', val2, ...}
%
% OUTPUTS:
%   L       - Updated Lagrangian with resolvable constants replaced by numeric values.
%   D       - Updated Rayleigh function with resolvable constants replaced.
%   lconst  - Updated list of unresolved symbolic constants.
%   vconst  - Corresponding numeric values for updated lconst.
%
% NOTES:
%   - The function identifies symbolic expressions in vconst that cannot yet be 
%     numerically evaluated (e.g., vconst = m*g if g is still symbolic).
%   - Constants depending on unresolved symbols are kept in lconst and vconst.
%   - If oconst is provided, any additional symbols within vconst expressions 
%     are resolved and appended to lconst/vconst.
%
% EXAMPLE USAGE:
%   [L, D, lconst, vconst] = UpdateConst(L, D, lconst, vconst, {'g', 9.81});
%
% AUTHOR:
%   William Cancino, 2023


function [L, D, lconst, vconst] = UpdateConst(L, D, lconst, vconst, oconst)
    
    % Is there any symbolic variable in "vconst"?
    vconst_temp = mat2cell(vconst, ones(1,size(vconst,1)), ones(1,size(vconst,2)));
    cond = cellfun(@(x) ~IsNumeric(x), vconst_temp);

    % Position of the items with symbolic variables
    rm_idx = find(cond);
    
    % Replace in L and D the symbolic variables found
    L = subs(L, lconst(rm_idx), vconst(rm_idx));
    D = subs(D, lconst(rm_idx), vconst(rm_idx)); 
    
    % Remove from "lconst" and "vconst" the symbolic variables
    lconst(rm_idx) = [];
    vconst(rm_idx) = [];
    vconst = double(vconst); % Convert to double

    % Does exist other array of parameters (oconst)?
    % "oconst" contains the parameters that appear in the symbolic variables of "vconst"
    if nargin > 4
        N = length(oconst);                 % Length of vconst
        o_lconst = oconst(1:2:N);           % Extract the name of the parameters
        o_vconst = double(oconst(2:2:N));   % Extract the values of the parameters
        
        % Add to "lconst" and "vconst" the parameters of "oconst"
        lconst = [lconst, sym(o_lconst)];
        vconst = [vconst, o_vconst];
    end
end