% PURPOSE:
%   Determines whether the input is numeric or a string representation of a numeric value.
%
% SYNTAX:
%   out = IsNumeric(x)
%
% INPUTS:
%   x   - Variable to evaluate. It can be numeric, a string, a character array, or another type.
%
% OUTPUTS:
%   out - Logical value (true or false):
%           true  → if x is numeric or a string that can be converted to a number.
%           false → if x contains letters or cannot be interpreted as a numeric value.
%
% AUTHOR:
%   William Cancino, 2023


function [out] = IsNumeric(x)
    try 
        cond1 = isnan(double(x));
        cond2 = any(isstrprop(string(x), 'alpha'));
        if cond1 && cond2, out = false; else, out = true; end
    catch
        out = false;
    end
end