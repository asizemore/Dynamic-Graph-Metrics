function plotArcNetwork(adj,nodeColor,edgeColor)
%plotArcNetwork plots a weighted network in a circle with the edges shown
%as colored arcs

% Inputs
    % adj = weighted adjacency matrix. 
    % nodeColor = 1 x 3 vector specifying node color
    % edgeColor = 1 x 3 vector specifying edge color for the maximally
        % weighted edge. Edge colors are determined by a gradient from gray to
        % edgeColor and colors edge by ranking. Will plot the line
        % thickness according to the actual edge weight.
        
%% Circle plot

t = linspace(-pi,pi,10001);

npoints = size(adj,1);
pos = linspace(-pi+0.3,pi+0.3,npoints+1);
 
if ~isempty(find(adj~=adj', 1))
    disp('network is not symmetric. Symmetrizing...')
    adj = adj+adj';
    adj = 0.5*adj;
end

% add a tiny bit of noise to get unique edge weights
Adj = adj;
for i = 1:length(adj)
    for j = i+1:length(adj)
        
        if Adj(i,j)>0
        Adj(i,j) = Adj(i,j) + 0.000001*rand;
        Adj(j,i) = Adj(i,j);
        end
        
    end
end

Edges_1 = sort(unique(Adj(:)),'descend');
Edges = zeros(length(Edges_1),2);
nedges = 0.5*nnz(Adj);
for k = 1:length(Edges_1)
    find(Adj==Edges_1(k));
    [j,h] = find(Adj==Edges_1(k));
    Edges(k,1) = j(1);
    Edges(k,2) = h(1);
end

lw = linspace(3,0.3,nedges);
gradient = [linspace(edgeColor(1),0.8,nedges)' linspace(edgeColor(2),0.8,nedges)' linspace(edgeColor(3),0.8,nedges)'];

%figure('Color',[1 1 1])
for i = 1:size(Edges,1)
    
edge = Edges(i,:);              % 'edge' contains end nodes
edge = sort(edge,'ascend');

    if adj(edge(1),edge(2))>0

        % Get node positions (x1,y1) and (x2,y2)    
        y1 = sin(pos(edge(1)));
        x1 = cos(pos(edge(1)));

        y2 = sin(pos(edge(2)));
        x2 = cos(pos(edge(2)));


        % Calculate the center of the circle which is perpendicular to the
        % large, outer circle at points (x1,y1) and (x2,y2). The center of 
        % this smaller circle will be called
        % (xx,yy).

        m1 = -x1/y1;
        m2 = -x2/y2;

        xx = (m1*x1-y1-m2*x2+y2)/(m1-m2);
        yy = m1*(xx-x1)+y1;

        % Will have radius r = distance from (x1,y1) to (xx,yy)
        r = sqrt((x1-xx)^2 + (y1-yy)^2);

        % plot!
        plot(r*cos(t)+xx,r*sin(t)+yy,'Color',gradient(i,:),'LineWidth',lw(i))
        hold on
    end                 % finished plotting one edge
end                     % finished plotting all edges

% Cover up edges outside our circle
xout = 15*cos(t);
yout = 15*sin(t);
patch([xout,cos(t)],[yout,sin(t)],'w','facealpha',1,'EdgeColor','w')


plot(cos(t),sin(t),'Color',[.67 .67 .67],'LineWidth',3)

plot(cos(pos),sin(pos),'.','Color',nodeColor,'MarkerSize',20)
axis([-1 1 -1 1])
axis square
axis off
grid off
end

