function [ connected ] = isStronglyConnected(node_i,node_j,...
    contactSequence,contactTimes,nNodes)
% Determine if node_i and node_j are strongly connected. A pair of nodes
% i,j is strongly connected if there exists a time respecting path from i 
% to j and from j to i. 
%
% Inputs:
%       node_i = node 1 of interest
%       node_j = node 2 of interest
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
% Optional Inputs:
%       contactTimes = ascending vector of all possible contact times. Ex.
%           1:20. Default assumes all possible times exist in
%           contactSequence.
%       nNodes = number of nodes total in dynamic network. Default assumes 
%           all nodes are present in contactSequence.
%
% Output:
%       connected = 1 if node i,j are strongly connected, else 0.
%
% 
% Main function:

if ~exist('contactTimes','var') || isempty(contactTimes);
    contactTimes = sort(unique(contactSequence(:,3),'ascend'));
end
if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end


directed = 1;
reachabilityArray = makeReachabilityArray(contactSequence,directed,...
    contactTimes,nNodes);

if reachabilityArray(node_i,node_j,end) == 1 || reachabilityArray(node_j,node_i,end)==1
    connected = 1;
else 
    connected = 0;
end


end

