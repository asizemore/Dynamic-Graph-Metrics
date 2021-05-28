function [ reachGraph ] = reachabilityGraph(contactSequence,...
    directed,contactTimes,nNodes)
% Construct a binary graph encoding existence of time-respecting paths
% between nodes.
%
% Inputs:
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t.
%       directed = 1 if network is directed, 0 if undirected.
%
% Optional Inputs:
%       contactTimes = ascending vector of all possible contact times. Ex.
%           1:20. Default assumes all possible times exist in
%           contactSequence.
%       nNodes = number of nodes total in dynamic network. Default assumes 
%           all nodes are present in contactSequence.
%
% Output:
%       reachabilityGraph = nNodes x nNodes binary matrix recording if 
%           recording if node j can be reached from node i via a 
%           time-respecting path up to that time index.
%       
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% Main function:

if ~exist('contactTimes','var') || isempty(contactTimes);
    contactTimes = sort(unique(contactSequence(:,3),'sorted'));
end
if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end



reachabilityArray = makeReachabilityArray(contactSequence,...
    directed,contactTimes,nNodes);
reachGraph = reachabilityArray(:,:,end);

end

