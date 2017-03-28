function [ rand_contactSequence ] = randomPermutedTimes(contactSequence)
% randomPermutedTimes returns a randomized dynamic network from the input
% contact sequence by randomly permuting the times of each contact.
%
% Input:
%       contactSequence = nEdges x 3 matrix encoding contacts between node
%           i,j at time t by (i,j,t). 
%
% Output:
%       rand_contactSequence = contact sequence of randomized input data. 
%
%
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% Main function:


newOrder = randsample(size(contactSequence,1),size(contactSequence,1));

rand_contactSequence = contactSequence;
rand_contactSequence(:,3) = rand_contactSequence(newOrder,3);


end

