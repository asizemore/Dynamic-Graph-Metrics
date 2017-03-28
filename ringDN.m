function [ contactSequence ] = ringDN(nNodes,timeInterval)
% Create a ring network with each edge connecting adjacent nodes. 
%
% Inputs:
%       nNodes = number of nodes
%       timeInterval = 1 x 2 vector of start and end time
%
% Output:
%       contactSequence = nNodes x 3 matrix with rows of form (i,j,t)
%           indicating a contact between nodes i,j at time t.
%
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% Main function:

contactSequence = zeros(nNodes,3);
contactSequence(:,1) = 1:nNodes;
contactSequence(:,2) = [2:nNodes 1];
contactSequence(:,3) = linspace(timeInterval(1),timeInterval(2),nNodes);


end

