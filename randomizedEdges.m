function [ rand_contactSequence ] = randomizedEdges( contactSequence,repeats)
% randomEdges returns a randomized dynamic network from the initial contact
% sequence by randomly rewiring each edge. 
%
% Inputs:
%       contactSequence = nEdges x 3 matrix encoding contacts between node
%           i,j at time t by (i,j,t). 
%       repeats = number of times each edge should be rewired.
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

nEdges = size(contactSequence,1);
rand_contactSequence = contactSequence;

for reps = 1:repeats
    for ed = 1:nEdges
        % take each edge and swap end nodes with another

        edge1 = rand_contactSequence(ed,1:2);

        ed2 = randsample(nEdges,1);

        % new edge is at position ed2
        edge2 = rand_contactSequence(ed2,1:2);
        
        r = rand;
        if r < 0.5
            if edge1(1) ~= edge2(2) && edge2(1) ~= edge1(2)
            rand_contactSequence(ed,1:2) = [edge1(1) edge2(2)];
            rand_contactSequence(ed2,1:2) = [edge2(1) edge1(2)];
            end
        else 
            if edge1(1) ~= edge2(1) && edge1(2) ~= edge2(2)
            rand_contactSequence(ed,1:2) = [edge1(1) edge2(1)];
            rand_contactSequence(ed2,1:2) = [edge1(2) edge2(2)];
            end
        end
        

    end
end

