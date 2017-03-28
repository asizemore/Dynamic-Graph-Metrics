function [ contactSequence ] = randomDN(nNodes,nEdges,edgeTimes)
% Create a dynamic network with randomly connected nodes and random times.
%
% Inputs:
%       nNodes = number of nodes
%       nEdges = total number of connections
%       edgeTimes = 1 x nEdges vector of times a connection could occur.
%               ex: 1:20
%
% Outputs:
%       contactSequence = nEdges x 3 with row (i,j,t) a contact from node i
%               to node j at time t.
%
%
% Main function:

contactSequence = zeros(nEdges,3);

% choose first nodes
contactSequence(:,1) = randi(nNodes,nEdges,1);

% choose second node (self edges not allowed)
for n = 1:nEdges
    
    secondNode = randperm(nNodes,1);
    firstNodes = contactSequence(n,1);
    
    while secondNode == firstNodes
    secondNode = randperm(nNodes,1);
    end
    
    contactSequence(n,2) = secondNode;
    
end

% randomly assign times
contactSequence(:,3) = randi(max(edgeTimes),nEdges,1);

% sort by ascending contact time
[~,idx] = sort(contactSequence(:,3));
contactSequence = contactSequence(idx,:);


end

