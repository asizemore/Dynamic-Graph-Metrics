function [ nodeColors ] = plotDNline( contactSequence, nNodes, timeInterval)
% Create a line plot showing contacts across time. Node colors assigned
% randomly.
%
% Input: 
%       contactSequence = nEdges x 3 array of contacts (i,j,t)
%
% Optional Input:
%       nNodes = number of nodes total in dynamic network. Default assumes 
%           all nodes are present in contactSequence.
%       timeInterval = start and end time of network. Default assumes the
%           initial time is at the time of first contact and end time is at 
%           the last contact.
%
% Output:
%       nodeColors = nNodes x 3 array of node colors.
% 

% Main function:

if ~exist('nNodes','var') || isempty(nNodes);
    nNodes = length(unique([contactSequence(:,1); contactSequence(:,2)]));
end

if ~exist('timeInterval','var') || isempty(timeInterval);
    timeInterval = [min(contactSequence(:,3)) max(contactSequence(:,3))];
end

nEdges = size(contactSequence,1);
% draw gray lines for each of the nodes
for n = 1:nNodes
    plot([min(timeInterval) max(timeInterval)],[n n],'-',...
        'Color',[.75 .75 .75])
    hold on
end

axis([min(timeInterval)-1 max(timeInterval) 0.5 nNodes])
a = axis; %// get axis size
plot([a(1) a(2)],[a(3) a(3)],'w','LineWidth',1); %// plot white line over x axis
plot([a(1) a(1)],[a(3) a(4)],'w','LineWidth',1); %// plot white line over y axis


% draw contacts (black)
for edges = 1:nEdges
    t = contactSequence(edges,3);
    plot([t t],[contactSequence(edges,1) contactSequence(edges,2)],...
        'k-')
end

%axis off

% each node needs a color
nodeColors = rand(nNodes,3);
for n = 1:nNodes
    
    times1 = contactSequence(contactSequence(:,1) == n,3);
    times2 = contactSequence(contactSequence(:,2) == n,3);
    
    plot([times1' times2'], n*ones(1,length([times1' times2'])),'.',...
        'Color',nodeColors(n,:),'MarkerSize',20);
    plot(min(timeInterval)-1,n,'.','Color',nodeColors(n,:),'MarkerSize',20)
end
 
box off
ax = gca;
ax.TickLength = [0 0];
xlabel('Time')
ax.XTick = timeInterval(1):timeInterval(2);
ax.YTick = 1:nNodes;
set(gcf,'Position',[0 0 1100 400])
ylabel('Nodes')
end

