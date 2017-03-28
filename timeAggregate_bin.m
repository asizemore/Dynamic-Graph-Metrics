function [ adj ] = timeAggregate_bin(contactSequence,nNodes)
% Create a time aggregated graph from a dynamic network
%
% Input:
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t.
%
% Optional Input:
%       nNodes = number of nodes total in dynamic network. Default assumes 
%           all nodes are present in contactSequence.
%
% Output:
%       adj = binary adjacency matrix for time aggregated graph. If two
%           nodes connect at any time in contactSequence, they are 
%           connected by an edge in the output.
%
%
%
% Main function:

if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end


adj = zeros(nNodes);
for edges = 1:size(contactSequence,1)
    adj(contactSequence(edges,1),contactSequence(edges,2)) = 1;
    adj(contactSequence(edges,2),contactSequence(edges,1)) = 1;
    
end




end

