function [ tadj, threshold ] = thresholdMatDensity( adj, density )
% Threshold matrix at a given edge density.


% Main function:

% record and sort edges in decreasing order
edges = adj(:);
sortedEdges = sort(edges,'descend');
nEdges = length(edges);

% Calculate threshold
threshold = sortedEdges(ceil(nEdges*density));

% Threshold matrix
tadj = adj;
tadj(tadj<threshold) = 0;


end

