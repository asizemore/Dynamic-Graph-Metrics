function [ C,L ] = temporalSmallWorldness(contactSequence,...
    directed,nNodes)
% temporalSmallWorldness returns values needed to compute the temporal
% small worldness of a dynamic network.
%
% Inputs:
%       contactSequence = nEdges x 3 matrix encoding contacts between node
%           i,j at time t by (i,j,t). 
%       directed = 1 if the dynamic network is directed, 0 otherwise.
%
% Optional Inputs:
%       nNodes = number of nodes in the dynamic network. Default is all
%           nodes which appear in contactSequence (have at least one
%           contact).
%
% Outputs:
%       C = temporal correlation of input dynamic network
%       L = efficientcy of dynamic network
%
%
% Main function:


if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end


[C] = temporalCorrelation( contactSequence,directed);

% compute efficiency
[~,L_mat] = betweennessCentrality(contactSequence,directed);


L = (1/(nNodes*(nNodes-1)))*sum(L_mat(:));



end

