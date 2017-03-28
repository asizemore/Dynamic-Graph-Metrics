function [ rand_contactSequence ] = shuffledTimeSteps(contactSequence,directed)
% shuffledTimeSteps randomizes the input dynamic network by randomly
% permuting the order of the graph sequence. 
%
% Inputs:
%       contactSequence = nEdges x 3 matrix encoding contacts between node
%           i,j at time t by (i,j,t). 
%       directed = 1 if directed network, 0 if undirected.
%
% Output:
%       rand_contactSequence = contact sequence of randomized input data. 
%
%
% Main function:

adjArray = networksFromContacts(contactSequence,directed);

nTimePoints = size(adjArray,3);

newOrder = randsample(nTimePoints,nTimePoints);

randAdjArray = adjArray(:,:,newOrder);

rand_contactSequence = arrayToContactSeq(randAdjArray,directed);


end

