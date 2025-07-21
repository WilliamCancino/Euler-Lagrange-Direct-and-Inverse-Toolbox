% PURPOSE:
%   Derives the equations of motion using the Euler-Lagrange formulation 
%   from the Lagrangian (L) and Rayleigh dissipation function (D).
%
% SINTAX:
%   Eq = LagrangeDynamicEqDeriver(L, D, q, Dq)
%
% INPUTS:
%   L          - (Symbolic) Lagrangian of the system (L = T - V).
%   D          - (Symbolic) Rayleigh dissipation function.
%   q          - (Symbolic array) Generalized coordinates.
%   Dq         - (Symbolic array) First derivatives of generalized coordinates.
%
% OUTPUTS:
%   Eq         - (Symbolic array) System of second-order differential equations.
%
% ORIGINAL AUTHOR:
%   Mansour Torabi
%
% MODIFIED BY:
%   William Cancino, 2023


function Eq = LagrangeDynamicEqDeriver(L, D, q, Dq)

%%
syms t
N = length(q);

%% Calculation of L_q = r.L/r.q and L_Dq = r.L/r.Dq
D_Dq = sym(zeros(N,1));
L_q = sym(zeros(N,1));
L_Dq = sym(zeros(N,1));

for ii = 1:N
   D_Dq(ii) = diff(D, Dq(ii));
   L_q(ii) = diff(L, q(ii));
   L_Dq(ii) = diff(L, Dq(ii));
end

%% Calculation of  L_Dq_dt = qd/dt( r_Dq ) 
L_Dq_dt = sym(zeros(N,1));

for ii = 1:N
    for jj = 1:N
        q_dst = str2sym(sprintf('%s(t)', q(jj)));
        Dq_dst = str2sym(sprintf('diff(%s, t)', q_dst));
        L_Dq(ii) = subs(L_Dq(ii), {q(jj), Dq(jj)}, {q_dst, Dq_dst});
    end
    
    L_Dq_fcn = symfun(L_Dq(ii), t);
    L_Dq_dt(ii) = diff(L_Dq_fcn, t);
    
    for jj = 1:N
        q_sym = str2sym(sprintf('%s(t)', q(jj)));
        L_Dq_dt(ii) = subs(L_Dq_dt(ii), diff(q_sym, t, t), sprintf('DD%s', q(jj)));
        L_Dq_dt(ii) = subs(L_Dq_dt(ii), diff(q_sym, t), Dq(jj));
        L_Dq_dt(ii) = subs(L_Dq_dt(ii), q_sym, q(jj));
    end
end

%% Lagrange's equations (Second kind) 
Eq = sym(zeros(N,1));

for ii = 1:N
   Eq(ii) = simplify(L_Dq_dt(ii) - L_q(ii) + D_Dq(ii)) ;
end