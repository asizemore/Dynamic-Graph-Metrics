function [ latencyArray, lastContactTimeArray, pathLengthArray ] = ...
    latencyComputations(contactSequence,directed,interval,...
    contactTimes,nNodes)
% Calculate and record statstics for time respecting paths and connectivity.
%
% Inputs:
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t.
%       directed = 1 if network is directed, 0 if undirected.
% Optional Inputs:
%       interval = 1 x 2 vector containing desired start and end points for
%           the calculation. Default is [-inf inf].
%       contactTimes = ascending vector of all possible contact times. Ex.
%           1:20. Default assumes all possible times exist in
%           contactSequence.
%       nNodes = number of nodes total in dynamic network. Default assumes 
%           all nodes are present in contactSequence.
%
% Output:
%       latencyArray = nNodes x nNodes x nContactTimes recording the
%           latency between node pairs at each contact time.
%       lastContactTimeArray = nNodes x nNodes x nContactTimes recording
%           the last time node a time-respecting path from node i reached 
%           node j.
%       pathLengthArray = nNodes x nNodes x nContactTimes recording number
%           of edges in the most recent time-respecting path from node i to
%           node j.
%
%
% Notes: this code updates the above arrays at each time point, so to find
% the minimum latency, for example, simply take the minimum value across
% time.
%
%
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% Main function:

if ~exist('interval','var') || isempty(interval);
    interval = [-inf inf];
end
if ~exist('contactTimes','var') || isempty(contactTimes);
    contactTimes = sort(unique(contactSequence(:,3)),'ascend');
end
if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end


% use only times wihtin the given interval
contactTimes(contactTimes < interval(1)) = [];
contactTimes(contactTimes > interval(2)) = [];

% Preallocate
reachabilityArray = zeros(nNodes,nNodes,length(contactTimes));
pathLengthArray = zeros(nNodes,nNodes,length(contactTimes));
latencyArray = zeros(nNodes,nNodes,length(contactTimes));
lastContactTimeArray = zeros(nNodes,nNodes,length(contactTimes));

for t = 1:length(contactTimes)
    
    t1 = contactTimes(t);
    
    
    % make binary matrix at this time
    badj = reachabilityAtTimeT(contactSequence,t1,directed,nNodes);
    [a1,b1] = find(badj);
    
    if t == 1
        if ~isempty(a1)
            for i = 1:length(a1)
                reachabilityArray(:,:,t) = badj;
                pathLengthArray(a1(i),b1(i),t) = 1;
                latencyArray(a1(i),b1(i),t) = 0;
                lastContactTimeArray(a1(i),b1(i),t) = t1;
            end
        end
    else 
        
    newSlice = reachabilityArray(:,:,(t-1))*badj;
    reachabilityArray(:,:,t) = newSlice + badj + ...
        reachabilityArray(:,:,(t-1));
    
    reachabilityArray(reachabilityArray>0) = 1;
    
    % record/update latency
    % assume it takes no time to traverse a path, so latency between
    % directly connected nodes is 0 -- but we will subtract this out at the
    % end so for now it is 1.
    
        % Next, for all new paths of length >1 (recorded in newSlice), we need
    % to update latencies if necessary.
    
    [a,b] = find(newSlice);
    newPathPairs = [a b];
    
    % Bring forward old information to later update.
    latencyArray(:,:,t) = latencyArray(:,:,t-1);
    pathLengthArray(:,:,t) = pathLengthArray(:,:,t-1);
    lastContactTimeArray(:,:,t) = lastContactTimeArray(:,:,t-1);
        
    
    % Update node pairs with direct contacts at this time t
    if ~isempty(a1)
        for i = 1:length(a1)
            
            pathLengthArray(a1(i),b1(i),t) = 1;
            latencyArray(a1(i),b1(i),t) = 0;
            lastContactTimeArray(a1(i),b1(i),t) = t1;
            
        end
    end
    
    % Update node pairs with a new time-respecting path connection
    if ~isempty(a)
        for i1 = 1:size(newPathPairs,1)
            % vector for node i
            v_i = reachabilityArray(newPathPairs(i1,1),:,(t-1));
            
            % vector for node j
            v_j = badj(:,newPathPairs(i1,2));
            
            % want only indices where both v_i and v_j are nonzero
            inds = find(v_i.*v_j');
            
            % new latency will be the minimum of v_i plus the time step
            newPathLength = min(pathLengthArray(newPathPairs(i1,1),inds,t-1)) + 1;
            newLatency = t1-max(lastContactTimeArray(newPathPairs(i1,1),inds,t-1) - ...
                latencyArray(newPathPairs(i1,1),inds,t-1)); 
           
            % update!
            latencyArray(newPathPairs(i1,1),newPathPairs(i1,2),t) = ...
                    newLatency;
            pathLengthArray(newPathPairs(i1,1),newPathPairs(i1,2),t) = ...
                    newPathLength;
            lastContactTimeArray(newPathPairs(i1,1),newPathPairs(i1,2),t) = t1;
            
        end
        
        
    end
   
    end
    
    
end


latencyArray(pathLengthArray == 0) = inf;
lastContactTimeArray(pathLengthArray == 0) = -inf;
pathLengthArray(pathLengthArray == 0) = inf;

end

