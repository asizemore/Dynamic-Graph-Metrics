function [l,lastContact,pathLength] = latency(contactSequence,node_i,node_j,directed,...
    interval,contactTimes,nNodes)
% Calculate the latency between node i and node j.
%
% Inputs:
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t.
%       node_i = node 1
%       node_j = node 2
%       directed = 1 if network is directed, 0 if undirected.
% Optional Inputs:
%       interval = 1 x 2 vector containing desired start and end points for
%           the calculation. Default is [-inf inf].
%       contactTimes = ascending vector of all possible contact times. Ex.
%           1:20. Default assumes all possible times exist in
%           contactSequence.
%       nNodes = number of nodes total in dynamic network. Default assumes 
%           all nodes are present in contactSequence.
%
% Output:
%       l = the minimum time needed to get from node_i to node_j via a time
%           respecting path.
%
%
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% Main function:

if ~exist('interval','var') || isempty(interval);
    interval = [-inf inf];
end
if ~exist('contactTimes','var') || isempty(contactTimes);
    contactTimes = sort(unique(contactSequence(:,3)),'ascend');
end
if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end


% use only times wihtin the given interval
contactTimes(contactTimes < interval(1),:) = [];
contactTimes(contactTimes > interval(2),:) = [];

[latencyMatrix,lastContactTimes,pathLengthMatrix] = ...
    latencyComputations(contactSequence,directed,...
    interval,contactTimes,nNodes);

l = min(latencyMatrix(node_i,node_j,:));

% find the first point at which the latency was minimal.
time = find(latencyMatrix(node_i,node_j,:) == l,1,'first');

lastContact = lastContactTimes(node_i,node_j,time);
pathLength = pathLengthMatrix(node_i,node_j,time);


end

