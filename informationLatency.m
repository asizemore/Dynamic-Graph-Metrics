function [ phi, lambda] = informationLatency(node_i,node_j,time,contactSequence,...
    directed,interval,contactTimes,nNodes)
% Return node_i's view of node_j's information at a particular time.
%
% Inputs:
%       node_i = node receiving information
%       node_j = node sending information
%       time = time at which to measure node i's view of node j's
%           information.
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t.
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
%       phi = the last point at which information from node j reached node
%           i.
%       lambda = time - phi
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



[~, lastContactTimeArray] = latencyComputations(contactSequence,directed,...
    interval,contactTimes,nNodes);


point = find(contactTimes<time,1,'last');
phi = lastContactTimeArray(node_j,node_i,point);
lambda = time-phi;

end

