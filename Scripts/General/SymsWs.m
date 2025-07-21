% PURPOSE:
%   This function creates symbolic variables from a list of names provided
%   as strings and assigns them to the specified workspace.
%   It is useful when symbolic variables need to be dynamically declared.
%
% SYNTAX:
%   out = SymsWs(inp)
%   out = SymsWs(inp, scope)
%
% INPUTS:
%   inp   - (String array, character vector, or cell array of character vectors)
%           Names of the symbolic variables to be created.
%           Example: ["x", "y", "z"] or {'a', 'b'}
%
%   scope - (String, Optional) Name of the workspace where the variables
%           will be assigned. Use 'base' to assign to the base workspace,
%           or 'caller' to assign to the calling function's workspace.
%           Default is 'base'.
%
% AUTHOR:
%   William Cancino, 2023


function out = SymsWs(inp, scope)
    % Default value if no value is inserted for scope
    if nargin<2, scope = 'base'; end

    % Convert string to symbolic
    out = str2sym(inp);

    % Assigning symbolic variables to a workspace
    for i = 1:numel(inp)
        assignin(scope, inp(i), out(i));
    end
end