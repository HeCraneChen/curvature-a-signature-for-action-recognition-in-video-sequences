% The Globally Optimal Reparameterization Algorithm for trajectories in R^n

% This is the Matlab implementation of the 'basic' or 'vanilla' GORA from
% the paper "The Globally Optimal Reparameterization Algorithm: an Alternative to
% Fast Dynamic Time Warping for Action Recognition in Video Sequences" by
% T. W. Mitchel, S. Ruan. Y. Gao, and G. Chirikjian, 2018

% Input:
%   tau/t  : original timescale
%   X    : Trajectory in R^n, should be n x T array, where T is the number
%   of time instances

% Outputs:
% X_opt : The reparameterization of the input signal to its UST, i.e. X(\tau^*(t))
% tau_opt : The globally optimal reparameterizqtion found by GORA, i.e. tau^*(t)

% @authors: Thomas Mitchel, Sipu Ruan, tmitchel@jhu.edu, ruansp@jhu.edu, 2018

%% GORA
function [X_opt, tau_opt,c,F] = GORA(X, tau) 

g = g_tau(X, tau);

[tau_opt,c,F] = temporalReparam(g, tau);

X_opt = interp1(tau, X.', tau_opt, 'spline').';

end

%% Compute g(tau)
function g = g_tau(X, t)
%Find dX/dt through high order finite difference 
DX = df_array(1, t, X, 4, 2);

% Compute g_tau = sqrt([dX/dt]^T [dX/dt])
g = sum(DX.^2, 1);
end

%% Temporal Reparameterization
function [tau_opt,c,F] = temporalReparam(g, tau)
t_opt = (0:length(tau)-1)/(length(tau) - 1);
F = cumtrapz(tau, g.^(1/2));%F
c=F(end);
F = F/F(end);%c
tau_opt = interp1(F, tau, t_opt, 'pchip');
end
