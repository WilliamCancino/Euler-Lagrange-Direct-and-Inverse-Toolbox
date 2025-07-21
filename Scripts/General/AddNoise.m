% PURPOSE:
%   Adds Additive White Gaussian Noise (AWGN) to a matrix of generalized 
%   coordinates evolving over time. Noise is applied independently to each 
%   coordinate to ensure the specified Signal-to-Noise Ratio (SNR) is met.
%
% INPUTS:
%   xx  - (Matrix [m x n]) Clean data matrix, where 'm' is the number of 
%         time steps and 'n' is the number of generalized coordinates.
%
%   dBs - (Scalar) Desired Signal-to-Noise Ratio in decibels (dB) to be 
%         applied independently to each generalized coordinate (column) of 'xx'.
%
% OUTPUTS:
%   xx_noise - (Matrix [m x n]) Noisy data matrix with the same dimensions 
%              as the input 'xx'.
%
% AUTHOR:
%   William Cancino, 2023


function xx_noise = AddNoise(xx, dBs)
    [m, n] = size(xx);
    xx_noise = zeros(m, n);
    for i = 1:n
        xx_noise(:, i) = awgn(xx(:, i), dBs, 'measured');
    end
end