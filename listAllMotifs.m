function [ motifs ] = listAllMotifs( contactSequence, directed, T, nNodes )
% listAllMotifs returns all motifs (here defined as time-respecting paths
% which visit a new node at each time point) of length >=2 in a dynamic
% network.
%
% Inputs: 
%       contactSequence = nEdges x 3 matrix encoding contacts between node
%           i,j at time t by (i,j,t).
%       directed = 1 for creating a directed network, 0 otherwise.
%
% Optional Inputs:
%       T = the last time at which to use for the calculation. Default is
%           last time within the contactSequence.
%       nNodes = number of nodes in the network. Default includes all nodes
%           with a connection in contactSequence.
%
% Outputs: 
%       motifs = T+1 x nNodes x nPaths array recording at entry (t,n,p) the
%           node at which motif p is visiting at time t-1.
%
% Notes: This function requires a good deal of time/memory for most dynamic
% networks. Not recommended for large or dense dynamic networks. 
%
% Main function:

disp('starting code')
tic
% first need to find all three-node adjacent paths
largeNumber = 100;      % for preallocation only
adjArray = networksFromContacts(contactSequence,directed);
motifs = zeros(T+1,nNodes,largeNumber);
nmotifs = 1;
for t = 1:T-1
    
    g1 = adjArray(:,:,t);
    g2 = adjArray(:,:,t+1);
    
    % first we want to see which paths will exist at t+1
    g_12 = g1*g2;
    
    [pathFrom,pathTo] = find(g_12);
    
    % Now we have nodes from which path began and where it ends
    % Iterate through these to find the middle node
    if ~isempty(pathFrom)
        for p = 1:length(pathFrom)
            
            middleNode = find(g1(pathFrom(p),:).*g2(:,pathTo(p))');
            % This is the middle node in a connected path
            
            for m = 1:length(middleNode)
            % need to store all of this in an effective way
            motifs(t,pathFrom(p),nmotifs) = 1;
            motifs(t+1,middleNode(m),nmotifs) = 1;
            motifs(t+2,pathTo(p),nmotifs) = 1;
            
            nmotifs = nmotifs+1;
            
            end
            
        end
    end
    
   
end

keeps = find(squeeze(sum(sum(motifs))));
motifs = motifs(:,:,keeps);


% Now we need to glue these motif parts together.     
     
motifsLenK = motifs;


for len = 4:nNodes
    
    toGlue = (sum(motifsLenK,3)>=2);
    [glueTime,glueingNode] = find(toGlue);

    gluedMotifs = zeros(T+1,nNodes,largeNumber);
    ngluedmotifs = 1;

    for g = 1:length(glueTime)

        % make sure these both aren't at the start of paths
        ps = find(motifsLenK(glueTime(g),glueingNode(g),:));


        for p1 = 1:length(ps)-1
            for p2 = p1+1:length(ps)

                % We need to know which path begins first
                t1 = find(sum(motifsLenK(:,:,ps(p1)),2),1);
                t2 = find(sum(motifsLenK(:,:,ps(p2)),2),1);
                % only want to add one contact at a time
                if abs(t1-t2)==1
                    if t1 < t2
                        % then we need to glue the first part of the p1 to the
                        % second of p2

                        newmot = [motifsLenK(1:glueTime(g),:,ps(p1)); ...
                        motifsLenK(glueTime(g)+1:end,:,ps(p2))];

                        if nnz(newmot) == len
                            gluedMotifs(:,:,ngluedmotifs) = newmot;
                            ngluedmotifs = ngluedmotifs+1;
                            
                        end


                    elseif t1 > t2
                        % then glue the first part of p2 to second part of p1
                        newmot = [motifsLenK(1:glueTime(g),:,ps(p2)); ...
                        motifsLenK(glueTime(g)+1:end,:,ps(p1))];

                        if nnz(newmot)==len
                            gluedMotifs(:,:,ngluedmotifs) = newmot;
                            ngluedmotifs = ngluedmotifs+1;
                            
                        end


                    end       
                end


            end
        end

    end

    % remove unused preallocated paths
    keeps = find(squeeze(sum(sum(gluedMotifs))));
    gluedMotifs = gluedMotifs(:,:,keeps);
    gluedMotifs = uniqueArray(gluedMotifs,len);
    motifs = cat(3,motifs,gluedMotifs);

    % update with newest motifs of length len
    motifsLenK = gluedMotifs;
    fprintf('Found %d new paths of length %d\n',ngluedmotifs-1,len)
end
    

toc
    
end

