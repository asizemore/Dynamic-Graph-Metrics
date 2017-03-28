function [ C,C_vec ] = temporalCorrelation( contactSequence,directed )
% temporalCorrelation calculates the temporal correlation of a dynamic
% network as defined in Tang et al. 2010.
%
% Inputs:
%       contactSequence = nEdges x 3 matrix encoding contacts between node
%           i,j at time t by (i,j,t). 
%       directed = 1 if the dynamic network is directed, 0 otherwise.
%
% Output:
%       C = temporal correlation coefficient of the network
%       C_vec = temporal correlation of each node
%
%
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% Main function:



adjArray = networksFromContacts(contactSequence,directed);

T = size(adjArray,3);
nNodes = size(adjArray,1);

C_vec = zeros(nNodes,1);

for node_i = 1:size(adjArray,1)

   
    
    gammaVec = zeros(1,T-1);

    for t = 1:T-1
        num = 0;

        for j = 1:nNodes
            if node_i~= j
                num = num + adjArray(node_i,j,t)*adjArray(node_i,j,t+1);
            end
        end

        den = sqrt(sum(adjArray(node_i,:,t))*sum(adjArray(node_i,:,t+1)));

        if den~=0
        gamma = num/den;
        gammaVec(t) = gamma;
        end

    end

    % sum over timepoints

    C_i = (1/(T-1))*sum(gammaVec);

    C_vec(node_i) = C_i;

end

C = sum(C_vec)/nNodes;

end

