function [ S_o ] = sourceSet(node_i,contactSequence,directed,t_i,...
    contactTimes,nNodes)
% Determine the source set of a node (the set of nodes from which node i 
% can be reached via time-respecting paths beginning at time t or later).
%
% Inputs:
%       node_i = node of interest
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t.
%       directed = 1 if network is directed, 0 if undirected.
%
% Optional Inputs:
%       t_i = time t at which to begin recording connectivity. Default is
%           the time of first contact or min(contactTimes).
%       contactTimes = ascending vector of all possible contact times. Ex.
%           1:20. Default assumes all possible times exist in
%           contactSequence.
%       nNodes = number of nodes total in dynamic network. Default assumes 
%           all nodes are present in contactSequence.
%
% Output:
%       S_o = source set vector for node i
%
% Main function:

if ~exist('contactTimes','var') || isempty(contactTimes);
    contactTimes = sort(unique(contactSequence(:,3)),'ascend');
end
if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end
if ~exist('t_i','var') || isempty(t_i);
    t_i = min(contactTimes);
end


% find nodes which can reach node_i at time t_i
    
cS = contactSequence;
cS(cS(:,3) > t_i,:) = [];
reachabilityArray = makeReachabilityArray(cS,directed,...
    contactTimes(contactTimes<=t_i),nNodes);


S_o = find(reachabilityArray(:,node_i,end));


end

