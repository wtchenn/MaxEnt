function fig =  my_show_flow(flow,A,node2pos,count)

color_num = 100;

flow(isnan(flow)) = 0;

[x,y] = find(flow~=0);
flow_array = flow(sub2ind(size(A),x,y));

flow_array_color = floor((flow_array - min(flow_array))/((max(flow_array) - min(flow_array))/(color_num-1)))+1;

colors = turbo(color_num);
flow_array_color = colors(flow_array_color,:);


fig = figure;
geolimits([min(node2pos(1,:)) max(node2pos(1,:))],[min(node2pos(2,:)) max(node2pos(2,:))])
hold on;

%%%%%%%%%%%%%%
%%% Plot links

for i = 1:length(x)
    if x(i) == y(i)
        continue;
    end
    temp_vector = node2pos([1,2],y(i)) - node2pos([1,2],x(i));
    x_shift = 0;
    y_shift = 0;
    if abs(temp_vector(2)) >= abs(temp_vector(1))
        if temp_vector(2) >= 0
            x_shift = -1;
        else 
            x_shift = +1;
        end
    else
        if temp_vector(1) >= 0
            y_shift = +1;
        else 
            y_shift = -1;
        end
    end
    % geoplot(node2pos(1,[x(i),y(i)])+[0.00001,0.00001].*x_shift,node2pos(2,[x(i),y(i)])+[0.00001,0.00001].*y_shift,'color',flow_array_color(i,:),'linewidth',1.5);
    geoplot(node2pos(1,[x(i),y(i)])+[0.00001,0.00001].*x_shift,node2pos(2,[x(i),y(i)])+[0.00001,0.00001].*y_shift,'color','blue','linewidth',1.5);

    temp_length = temp_vector' * temp_vector;

    arrow1 = [cosd(-150),-sind(-150);sind(-150),cosd(-150)] * temp_vector./temp_length;
    arrow2 = [cosd(150),-sind(150);sind(150),cosd(150)] * temp_vector./temp_length;

    mid_point = [sum(node2pos(1,[x(i),y(i)]))/2;sum(node2pos(2,[x(i),y(i)]))/2];
    % arrow1_end = mid_point + arrow1*temp_length/10;
    % arrow2_end = mid_point + arrow2*temp_length/10;

    arrow1_end = mid_point + arrow1./sqrt(sum(arrow1.^2))*temp_length*15;
    arrow2_end = mid_point + arrow2./sqrt(sum(arrow1.^2))*temp_length*15;

    geoplot([mid_point(1),arrow1_end(1)]+[0.00001,0.00001]*x_shift,[mid_point(2),arrow1_end(2)]+[0.00001,0.00001]*y_shift,'color',flow_array_color(i,:),'linewidth',1.5);
    geoplot([mid_point(1),arrow2_end(1)]+[0.00001,0.00001]*x_shift,[mid_point(2),arrow2_end(2)]+[0.00001,0.00001]*y_shift,'color',flow_array_color(i,:),'linewidth',1.5);

end

%%%%%%%%%%%%%
%% Plot nodes

% node_idx = find(x==y);
node_idx = 1:size(A,1)

for i = 1:length(node_idx)
    target = node_idx(i)
    % geoplot(node2pos(1,x(node_idx(i))),node2pos(2,y(node_idx(i))),'o','MarkerSize',8,'MarkerFaceColor',flow_array_color(node_idx(i),:) ,'MarkerEdgeColor','none');
    geoplot(node2pos(1,i),node2pos(2,i),'ok','MarkerSize',6,'MarkerFaceColor','green');
    %text(node2pos(1,x(node_idx(i)))+0.0005,node2pos(2,y(node_idx(i)))+0.00015,num2str(count(x(node_idx(i)))),'FontSize',8);
end


%colorbar('YTick', linspace(0, 1, color_num/ceil(color_num/10)), 'YTickLabel', linspace(min(flow_array), max(flow_array), color_num/ceil(color_num/10)));
colormap(colors);
a = colorbar('YTick', linspace(0, 1, color_num/ceil(color_num/10)), 'YTickLabel', round(linspace(min(flow_array), max(flow_array), color_num/ceil(color_num/10)),2));
a.Label.String = 'M^*';

geobasemap streets-light;