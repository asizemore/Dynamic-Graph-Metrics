function [ betweennessCent, durationShortestPaths, nFastestPaths ] = ...
    betweennessCentrality(contactSequence,directed)
%% Calculate the betweenness centrality of all nodes in a dynamic network.
%
% Inputs:
%       contactSequence = nEdges x 3 array of (i,j,t) tuples indicating
%           contact between nodes i,j at time t.
%       directed = 1 if network is directed, 0 if undirected.
%
% Outputs:
%       betweennessCent = nNodes x 1 vector recording the betweenness
%           centrality at each node.
%       durationShortestPath = nNodes x nNodes matrix recording the
%           duration of the shortest path from node i to node j in entry
%           ij.
%       nFastestPaths = nNodes x nNodes matrix with entry ij the number of
%           fastest paths from node i to node j.
%
%
%
% Reference: Ann E. Sizemore and Danielle S. Bassett, "Dynamic Graph 
% Metrics: Tutorial, Toolbox, and Tale." Submitted. (2017)
%
% Main function:

% betweenness centrality
adjArray = networksFromContacts(contactSequence,directed);

npoints = size(adjArray,3);
nNodes = size(adjArray,1);
durationShortestPaths = zeros(nNodes);


nPathsDurationt = sum(adjArray,3);
nFastestPathsDurationt = nPathsDurationt;
nFastestPaths = nFastestPathsDurationt;
nFastestPaths(logical(eye(nNodes))) = 1;
durationShortestPaths(find(nPathsDurationt)) = 1;
durationShortestPaths(logical(eye(nNodes))) = 1;

startingInfo = zeros(nNodes,nNodes,npoints);


% Note: we assume time steps are 1:nPoints 

for t = 2:npoints
    
    tArray = zeros(nNodes,nNodes,npoints-t+1);
    
    for p = 1:size(tArray,3)
        
        tArray(:,:,p) = adjArray(:,:,p);
        for j = p+1:p+t-1
            
            tArray(:,:,p) = tArray(:,:,p)*adjArray(:,:,j)+ (tArray(:,:,p)>0);
        end
        
        tArraySlice = tArray(:,:,p);
        startingInfoSlice = startingInfo(:,:,p);
        
        startingInfoSlice(nFastestPaths==0) = tArraySlice(nFastestPaths==0);
        startingInfo(:,:,p) = startingInfoSlice;
        
    end
    
      
    % need to update shortest path matrix
    nPathsDurationt = sum(tArray,3);
    nFastestPathsDurationt(nFastestPaths==0) = ...
        nPathsDurationt(nFastestPaths==0);
    newPathind = nFastestPathsDurationt;
    newPathind(newPathind>0) = 1;
    durationShortestPaths(nFastestPaths==0) = t*newPathind(nFastestPaths==0);
    
    % update fastest paths
    nFastestPaths(nFastestPaths==0) = ...
        nFastestPathsDurationt(nFastestPaths==0);
    
       
    
    
end



% Prepare to find path members

durationShortestPaths(~durationShortestPaths) = inf;
durationShortestPaths(logical(eye(nNodes))) = 0;
nFastestPaths(~nFastestPaths) = 1;



% Finding which nodes belong in each path

betweennessCent = zeros(nNodes,1);
for t = 1:npoints-1

    shortestPathsStartingAtTimet = startingInfo(:,:,t);
    
    % Records number of shortest paths
    lengthShortestPathsStartingAtTimet = zeros(nNodes);
    lengthShortestPathsStartingAtTimet(shortestPathsStartingAtTimet>0) = ...
        durationShortestPaths(shortestPathsStartingAtTimet>0);
    
    [startingNode,endingNode] = find(shortestPathsStartingAtTimet);

    for p = 1:length(startingNode)

        dur = lengthShortestPathsStartingAtTimet(startingNode(p),endingNode(p));
        if ~isinf(dur) && dur>1
        if dur == 2
            betweenNode = intersect(find(adjArray(startingNode(p),:,t)),...
                find(adjArray(:,endingNode(p),t+1)));
            betweennessCent(betweenNode) = betweennessCent(betweenNode) + ...
                1/nFastestPaths(startingNode(p),endingNode(p));
        else
            
            
        
            node2 = find(adjArray(startingNode(p),:,t)>0);

            keeps = [];
            for n = 1:length(node2)
                yn = setOfInfluence(node2(n),contactSequence,directed,t,t+dur-1,[],nNodes);
                if ismember(endingNode(p),yn)
                    keeps = [keeps n];
                end
            end
            node2 = node2(keeps);
            paths = node2';


            for t_i = t+1:t+dur-2

                allNewPaths = [];
                for n1 = 1:size(paths,1)

                    nodet_i = paths(n1,end);
          
                    [~,more] = find(adjArray(nodet_i,:,t_i)>0);
                    nodet_i = union(nodet_i,more)';

                    keeps = [];
                    for n = 1:length(nodet_i)
                        yn = setOfInfluence(nodet_i(n),contactSequence,directed,t_i+1,...
                                t+dur-1,[],nNodes);
                        if ismember(endingNode(p),yn)
                            keeps = [keeps; n];
                        end
                    end

                    nodet_i = nodet_i(keeps);

                    %add new paths
                    oldPaths = repmat(paths(n1,:),[length(nodet_i) 1]);
                    newPaths = [oldPaths nodet_i];
                    allNewPaths = [allNewPaths; newPaths];
                    
                end

                paths = allNewPaths;

            end

            % Then we need to add this to betweenness centrality vector
            for n3 = 1:size(paths,1)
                betweennessCent(unique(paths(n3,:))) = ...
                    betweennessCent(unique(paths(n3,:))) + ...
                    1/nFastestPaths(startingNode(p),endingNode(p));

            end

            
        end
        end

    end

end




end

