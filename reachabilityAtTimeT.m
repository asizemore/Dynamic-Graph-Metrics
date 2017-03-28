function [ badj ] = reachabilityAtTimeT(contactSequence,t,directed,nNodes)
% Create a binary network summarizing contacts which appear at time t. 
%
% Inputs: 
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t.
%       t = time at which to create graph
%       directed = 1 if network is directed, 0 if undirected.
%
% Optional Inputs:
%       nNodes = number of nodes total in dynamic network. Default assumes 
%           all nodes are present in contactSequence.
%
% Output:
%       badj = nNodes x nNodes binary graph indicating which nodes are
%           connected at time t in dynamic network.
%
%
% Main function:

if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end

badj = zeros(nNodes);
times = find(contactSequence(:,3) == t);
    
    if ~isempty(times)
        for t1 = 1:length(times)
            badj(contactSequence(times(t1),1),contactSequence(times(t1),2)) = 1;
            if directed == 0
                badj(contactSequence(times(t1),2),contactSequence(times(t1),1)) = 1;
            end
            
        end
    end
    


end

