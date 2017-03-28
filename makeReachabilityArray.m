function [ reachabilityArray ] = makeReachabilityArray(contactSequence,...
    directed,contactTimes,nNodes)
% Create an array encoding time-respecting paths between nodes
%
% Inputs:
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
%       reachabilityArray = nNodes x nNodes x nContactTimes binary array
%           recording if node j can be reached from node i via a 
%           time-respecting path up to that time index.
%       
%
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% Main function:

if ~exist('contactTimes','var') || isempty(contactTimes);
    contactTimes = sort(unique(contactSequence(:,3)),'ascend');
end
if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end

% Preallocate
reachabilityArray = zeros(nNodes,nNodes,length(contactTimes));


for t = 1:length(contactTimes)
    
    t1 = contactTimes(t);
   
    
    % make binary matrix at this time
    badj = reachabilityAtTimeT(contactSequence,t1,directed,nNodes);
    
    if t == 1
        reachabilityArray(:,:,t) = badj;
    else 
        
    newSlice = reachabilityArray(:,:,(t-1))*badj;
    
    reachabilityArray(:,:,t) = newSlice + badj + ...
        reachabilityArray(:,:,(t-1));
    
    reachabilityArray(reachabilityArray>0) = 1;

    end
    
    
end



end

