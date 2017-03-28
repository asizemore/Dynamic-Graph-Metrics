function [ B, cov, sigma, m ] = burstiness(sequence)
% Calculate the burstiness of a given sequence.
%
% Input:
%       sequence = vector, often the vector of contact times
%
% Outputs:
%       B = burstiness of input sequence
%       cov = coefficient of variation
%       sigma = standard deviaiton
%       m = mean of input sequence
%
%
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% Main function:

% first calculate sigma, the standard deviation

sigma = std(sequence);

% now calculate the mean

m = mean(sequence);

% coefficient of variation

cov = sigma/m;

% burstiness

B = (sigma - m)/(sigma + m);


end

