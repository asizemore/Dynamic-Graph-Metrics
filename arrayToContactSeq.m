function [ contactSequence ] = arrayToContactSeq(adjArray,isdirected)
% arrayToContactSeq takes a sequence of matrices and converts this to a
% long format contact sequence.
%
% Inputs:
%       adjArray = an nNodes x nNodes x time-points array encoding a
%           dynamic network
%       isdirected = boolean indicating if the network is directed
%
% Output:
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t. If adjArray is weighted,
%           this will be an nEdges x 4 array of (i,j,t,w) including the
%           edge weight w.
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% Main function

%% making contact sequence from networks

% networsk are adjArray

nNodes = size(adjArray,1);
contactSequence = [];

for t = 1:size(adjArray,3)
if ~isdirected
    for i =1:nNodes
        for j = i+1:nNodes
            if adjArray(i,j,t) ~= 0
            contactSequence = [contactSequence; i j t adjArray(i,j,t)];
            end
        end
    end

else
    for i = 1:nNodes
        for j = 1:nNodes
            if i~=j
                if adjArray(i,j,t) ~=0
                contactSequence = [contactSequence; i j t adjArray(i,j,t)];
                end
            end
        end
    end
end

end
    


% if it is unweighted, return only the first three columns
if length(unique(contactSequence(:,4))) == 1
    contactSequence = contactSequence(:,1:3);
end


end

