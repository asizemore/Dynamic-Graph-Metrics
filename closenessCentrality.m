function [ Cc, tau_vec ] = closenessCentrality(node_i,time,...
    contactSequence,directed,contactTimes,nNodes)
% Calculate the closeness centrality of a given node beginning at a
% particular time.
%
% Inputs:
%       node_i = starting node
%       time = earliest time a path can begin
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t.
%       directed = 1 if network is directed, 0 if undirected.
% Optional Inputs:
%       contactTimes = ascending vector of all possible contact times. Ex.
%           1:20. Default assumes all possible times exist in
%           contactSequence.
%       nNodes = number of nodes total in dynamic network. Default assumes 
%           all nodes are present in contactSequence.
%
% Output:
%       Cc = closeness centrality of node i at time t.
%       tau_vec = vector recording values of tau_{i,t}(j) (forward
%           latency). Unreachable nodes and node i are given value inf. 
%
%
% Note: if input time is that of a contact originating at node i, the 
% forward latency will be 0 for that node, making the overall Cc = inf
% (since we take the average of 1/tau). 
%
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
%
% Main function:

if ~exist('contactTimes','var') || isempty(contactTimes);
    contactTimes = sort(unique(contactSequence(:,3)),'ascend');
end
if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end






for node_j = 1:nNodes
    
    tau = inf;
    
    if node_j ~= node_i
    [tau] = forwardLatency(node_i,node_j,time,...
    contactSequence,directed,contactTimes,nNodes);

    end
    
    tau_vec(node_j) = tau;
    
end

Cc = (1/(nNodes-1)) * sum(1./tau_vec);


end

