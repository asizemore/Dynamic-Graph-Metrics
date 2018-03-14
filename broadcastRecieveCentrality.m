function [ broadcastCentrality, receiveCentrality ] = ...
    broadcastRecieveCentrality( contactSequence,alpha, nNodes )
%% Calculate the broadcast and receive centrality as defined in Mantzaris
% et al. 2013.
%
% Inputs:
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t. Assumes undirected.
%       alpha = scalar in (0,1) governing weight given to paths based on
%           the number of edges.
%
% Optional Inputs:
%       nNodes = number of nodes in the dynamic network. Default is all
%           nodes which appear in contactSequence (have at least one
%           contact).
%
% Outputs:
%       broadcastCentrality = nNodes x 1 vector recording the broadcast
%           centrality at each node.
%       receiveCentrality = nNodes x 1 vector recording the receive
%           centrality at each node.
%
% 
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% 
%
% Main function:

if ~exist('nNodes','var') || isempty(nNodes)
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end

% convert contact sequence to array of networks
directed = 0;
[ adjArray ] = networksFromContacts(contactSequence,directed);
badj = adjArray(:,:,1);
badj(badj>0) = 1;
P_sd = inv(eye(nNodes) - alpha*badj);
nTimes = size(adjArray,3);

for n = 2:nTimes
    badj = thresholdMatDensity(adjArray(:,:,n),0.1);
    badj(badj>0) = 1;
    P_sd = P_sd*inv(eye(nNodes) - alpha*badj);
end

Q_sd = P_sd/norm(P_sd);

broadcastCentrality = sum(Q_sd,2);
receiveCentrality = sum(Q_sd,1);

end

