function [ adjArray ] = networksFromContacts(contactSequence,directed)
% networksFromContacts creates an array of networks (weighted or binary)
% from a contact sequence.
%
% Input:
%       contactSequence = nEdges x 3 matrix encoding contacts between node
%           i,j at time t by (i,j,t). Optionally a fourth column denotes 
%           edge weight.
%       directed = 1 for creating a directed network, 0 otherwise.
%
%
% Output: 
%       adjArray = nNodes x nNodes x nTimes array describing binary or
%           weighted network at each time point.
%
%
%
%
% Main function:

times = unique(contactSequence(:,3));

nNodes = length(unique([contactSequence(:,1) ; contactSequence(:,2)]));
adjArray = zeros(nNodes,nNodes,length(times));
if size(contactSequence,2) == 3
    edgeWeights = ones(size(contactSequence,1),1);
else
    edgeWeights = contactSequence(:,4);
end


for t = 1:length(times)

    edges = find(contactSequence(:,3) == times(t));
    
    nodes = contactSequence(edges,1:2);
    
    for i = 1:size(nodes,1)
        
        if size(nodes,1) == 1
            adjArray(nodes(1),nodes(2),t) = edgeWeights(edges(i));
            if ~directed
                adjArray(nodes(2),nodes(1),t) = edgeWeights(edges(i));
            end
            
        else
            adjArray(nodes(i,1),nodes(i,2),t) = edgeWeights(edges(i));
            if ~directed
                adjArray(nodes(i,2),nodes(i,1),t) = edgeWeights(edges(i));
            end
            
        end
        
    end
   
   
    
end

    
    
end

