function [ S ] = setOfInfluence( node_i, contactSequence,  directed, ...
    t_i,t_end,contactTimes, nNodes)
% Determine the set of influence of a node (the set of nodes which can be 
% reached from node i via a time-respecting paths beginning at time t 
% or later).
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
%       t_end = tme at which to end calculation. Default is inf.
%       contactTimes = ascending vector of all possible contact times. Ex.
%           1:20. Default assumes all possible times exist in
%           contactSequence.
%       nNodes = number of nodes total in dynamic network. Default assumes 
%           all nodes are present in contactSequence.
%
% Output:
%       S = set of Influence vector for node i
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
if ~exist('t_end','var') || isempty(t_end);
    t_end = inf;
end



% find nodes which can be reached from nodei
    
contactSequence(contactSequence(:,3) <t_i,:) = [];
contactSequence(contactSequence(:,3) >t_end,:) = [];

reachabilityArray = makeReachabilityArray(contactSequence,directed,...
    contactTimes(contactTimes>=t_i),nNodes);


S = find(reachabilityArray(node_i,:,end));




end

