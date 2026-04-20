addpath('../Tool')
addpath('../Tool/MaxEnt')
addpath('../Tool/parfor_progress')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Import Data                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Import sensor count data               

%% Set up the Import Options and import the data
opts = detectImportOptions(".\Data Source\Melbourne_Data_Cleaned.xlsx",'ReadVariableNames',true,'PreserveVariableNames',true);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:BX705";

% Specify column names and types
opts.VariableTypes = ["double","double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Import the data
Count_Table = readtable(".\Data Source\Melbourne_Data_Cleaned.xlsx", opts);

%% Clear temporary variables
clear opts


%%% Import sensor information        


%% Import data from spreadsheet
opts = spreadsheetImportOptions("NumVariables", 6);

% Specify sheet and range
opts.Sheet = "pedestrian-counting-system-sens";
opts.DataRange = "A2:F164";

% Specify column names and types
opts.VariableNames = ["Location_ID", "Sensor_Description_Cleaned", "Sensor_Description_Original", "Latitude", "Longitude", "Comment"];
opts.VariableTypes = ["double", "char", "char", "double", "double", "char"];

% Specify variable properties
opts = setvaropts(opts, ["Sensor_Description_Cleaned", "Sensor_Description_Original", "Comment"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Sensor_Description_Cleaned", "Sensor_Description_Original", "Comment"], "EmptyFieldRule", "auto");

% Import the data
Sensor_Info = readtable(".\Data Source\pedestrian-counting-system-sensor-locations.xlsx", opts, "UseExcel", false);

%% Clear temporary variables
clear opts


%%%  Import edgelist      

opts = delimitedTextImportOptions("NumVariables", 47);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = " ";

% Specify column names and types
opts.VariableNames = ["point1", "point2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47"];
opts.SelectedVariableNames = ["point1", "point2"];
opts.VariableTypes = ["double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.LeadingDelimitersRule = "ignore";

% Specify variable properties
opts = setvaropts(opts, ["Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["point1", "point2"], "ThousandsSeparator", ",");

% Import the data
EdgeList = readtable(".\Data Source\Melbourne_links.txt", opts);

%% Convert to output type
EdgeList = table2array(EdgeList);

%% Clear temporary variables
clear opts


%%%  Import Node Table      


%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["NodeID", "y", "x", "street_count", "highway", "ref"];
opts.VariableTypes = ["double", "double", "double", "double", "categorical", "char"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "ref", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["highway", "ref"], "EmptyFieldRule", "auto");

% Import the data
Node_Table = readtable(".\Data Source\Melbourne_nodes.csv", opts);


%% Clear temporary variables
clear opts

% %Backup Point
% save raw_data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Construct Networks                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%
EdgeList(find(EdgeList(:,1)==EdgeList(:,2)),:) = [];

%%%%%% Node ID to the idx in the adjacency mateix

N = length(Node_Table.NodeID);

NodeID = Node_Table.NodeID;
idx = [1:N]';

idx2NodeId = table(idx,NodeID);

clear NodeID idx;

A = sparse(N,N);
D_T = sparse(N,N);
link_coor = [];

% Coordinate systems
wgs84 = wgs84Ellipsoid("m");

for i = 1:size(EdgeList,1)
    index1 = find(idx2NodeId.NodeID == EdgeList(i,1));
    index2 = find(idx2NodeId.NodeID == EdgeList(i,2));

    num1 = idx2NodeId.idx(index1);
    num2 = idx2NodeId.idx(index2);
    A(num1,num2) = 1;
    A(num2,num1) = 1;

    index1 = find(Node_Table.NodeID == EdgeList(i,1));
    index2 = find(Node_Table.NodeID == EdgeList(i,2));

    link_coor = [link_coor;[Node_Table.x(index1),Node_Table.y(index1),Node_Table.x(index2),Node_Table.y(index2)]];

    D_T(num1,num2) = distance(Node_Table.y(index1),Node_Table.x(index1),Node_Table.y(index2),Node_Table.x(index2),wgs84);
    D_T(num2,num1) = D_T(num1,num2);
end

clear i num1 num2 index1 index2;

%%Show Pictures
% my_show_network(A,[Node_Table.x,Node_Table.y],'b.-')
% saveas(gca,'Map.fig')

%%%%%%%% Sensor embedding

Embedded_A = A;
Embedded_D = D_T;
Embedded_Node = Node_Table(:,[1:3]);
Embedded_idx2NodeId = idx2NodeId;

Embedded_Edgelist = EdgeList;

Location_ID = [];
new_Latitude = [];
new_Longitude = [];

Sensor_Position = table(Location_ID,new_Latitude,new_Longitude);

clear Location_ID new_Latitude new_Longitude;

link_coor(:,5) = (link_coor(:,4)-link_coor(:,2))./(link_coor(:,3)-link_coor(:,1));
link_coor(:,6) = link_coor(:,4) - link_coor(:,5) .* link_coor(:,3);

for i = 1:size(Sensor_Info.Location_ID,1)

    if ~isempty(find(Sensor_Position.Location_ID == Sensor_Info.Location_ID(i)))
        continue;
    end

    x = Sensor_Info.Longitude(i);
    y = Sensor_Info.Latitude(i);

    temp_k = -1./link_coor(:,5);
    temp_b = y-x*temp_k;

    temp_intersect_x = -(link_coor(:,6) - temp_b)./(link_coor(:,5) - temp_k);
    temp_intersect_y = temp_k.*temp_intersect_x+temp_b;

    temp_beyond_scope = find( (temp_intersect_x<min(link_coor(:,1),link_coor(:,3))) + (temp_intersect_x>max(link_coor(:,1),link_coor(:,3))));
    temp_idx_for_point1 = find(abs(temp_intersect_x(temp_beyond_scope)-link_coor(temp_beyond_scope,1))<abs(temp_intersect_x(temp_beyond_scope)-link_coor(temp_beyond_scope,3)));
    temp_idx_for_point2 = find(abs(temp_intersect_x(temp_beyond_scope)-link_coor(temp_beyond_scope,1))>=abs(temp_intersect_x(temp_beyond_scope)-link_coor(temp_beyond_scope,3)));

    temp_intersect_x(temp_beyond_scope(temp_idx_for_point1)) = link_coor(temp_beyond_scope(temp_idx_for_point1),1);
    temp_intersect_y(temp_beyond_scope(temp_idx_for_point1)) = link_coor(temp_beyond_scope(temp_idx_for_point1),2);

    temp_intersect_x(temp_beyond_scope(temp_idx_for_point2)) = link_coor(temp_beyond_scope(temp_idx_for_point2),3);
    temp_intersect_y(temp_beyond_scope(temp_idx_for_point2)) = link_coor(temp_beyond_scope(temp_idx_for_point2),4);

    [~,edge_idx] = min(sqrt((temp_intersect_x-x).^2 + (temp_intersect_y-y).^2));

    temp_cell = {Sensor_Info.Location_ID(i),temp_intersect_y(edge_idx),temp_intersect_x(edge_idx)};

    Sensor_Position = [Sensor_Position;temp_cell];

    %% Change networks;

    idx1 = Embedded_idx2NodeId.idx(find(Embedded_idx2NodeId.NodeID == Embedded_Edgelist(edge_idx,1)));
    idx2 = Embedded_idx2NodeId.idx(find(Embedded_idx2NodeId.NodeID == Embedded_Edgelist(edge_idx,2)));

    idx = size(Embedded_Node,1)+1;

    Embedded_Node = [Embedded_Node;temp_cell];
    Embedded_idx2NodeId = [Embedded_idx2NodeId;{Embedded_idx2NodeId.idx(end)+1,Sensor_Info.Location_ID(i)}];

    Embedded_A(idx1,idx2) = 0;
    Embedded_A(idx2,idx1) = 0;

    Embedded_Edgelist(edge_idx,:) = [];
    link_coor(edge_idx,:) = [];

    Embedded_A(idx,[idx1,idx2]) = 1;
    Embedded_A([idx1,idx2],idx) = 1;
    Embedded_Edgelist = [Embedded_Edgelist;[Embedded_Node.NodeID(idx),Embedded_Node.NodeID(idx1)]];
    Embedded_Edgelist = [Embedded_Edgelist;[Embedded_Node.NodeID(idx),Embedded_Node.NodeID(idx2)]];

    temp_coor = [
        Embedded_Node.x(idx1),Embedded_Node.y(idx1),Embedded_Node.x(idx),Embedded_Node.y(idx);
        Embedded_Node.x(idx2),Embedded_Node.y(idx2),Embedded_Node.x(idx),Embedded_Node.y(idx)
        ];
        
    temp_coor(:,5) = (temp_coor(:,4)-temp_coor(:,2))./(temp_coor(:,3)-temp_coor(:,1));
    temp_coor(:,6) = temp_coor(:,4) - temp_coor(:,5) .* temp_coor(:,3);
    link_coor = [link_coor;temp_coor];

    Embedded_D(idx,idx1) = distance(Embedded_Node.y(idx1),Embedded_Node.x(idx1),Embedded_Node.y(idx),Embedded_Node.x(idx),wgs84);
    if (Embedded_D(idx,idx1)==0)
        Embedded_D(idx,idx1) = 0.01;
    end
    Embedded_D(idx1,idx) = Embedded_D(idx,idx1);

    Embedded_D(idx,idx2) = distance(Embedded_Node.y(idx2),Embedded_Node.x(idx2),Embedded_Node.y(idx),Embedded_Node.x(idx),wgs84);
    if (Embedded_D(idx,idx2)==0)
        Embedded_D(idx,idx2) = 0.01;
    end
    Embedded_D(idx2,idx) = Embedded_D(idx,idx2);

    Embedded_D(idx1,idx2) = 0;
    Embedded_D(idx2,idx1) = 0;

    % % Draw pictures for each embedding sensor
    % openfig('Map.fig');

    % plot(x,y,'ko','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',[1,0,0]);
    % plot(Embedded_Node.x(idx),Embedded_Node.y(idx),'ko','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0]);
    % xlim([Sensor_Info.Longitude(i)-0.001 Sensor_Info.Longitude(i)+0.001])
    % ylim([Sensor_Info.Latitude(i)-0.001 Sensor_Info.Latitude(i)+0.001])
    % plot([Embedded_Node.x(idx),Sensor_Info.Longitude(i)],[Embedded_Node.y(idx),Sensor_Info.Latitude(i)],':k','linewidth',3)

    % saveas(gca,[num2str(i),'.png'])

    close;

    display(i);

end

clear i x y temp_k temp_b temp_intersect_x temp_intersect_y idx temp_cell idx1 idx2 idx temp_idx_for_point1 temp_idx_for_point2 link_coor temp_beyond_scope edge_idx temp_coor;

%Create Pictures
my_show_network_with_map(Embedded_A,[Embedded_Node.y,Embedded_Node.x],'b.-')
saveas(gca,'embedded_network.fig')
geoplot(Sensor_Position.new_Latitude,Sensor_Position.new_Longitude,'ro','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',[1,0,0])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                 Compute the geodesic distance                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D_between_sensor = zeros(length((size(A,1)+1):size(Embedded_A,1)),size(Embedded_A,1));

parfor i = 1:(size(Embedded_A,1)-size(A,1))
    display(i)
    D_between_sensor(i,:) = my_shortest_path(size(A,1)+i,Embedded_A,Embedded_D);
end

% [D,B] = my_dijkstra_full(Embedded_A,Embedded_D);

D_between_sensor = D_between_sensor(:,(size(A,1)+1):size(Embedded_A));

SensorIDinCount = [];

target = Count_Table.Properties.VariableNames(8:end);

for i = 1:length(target)
    SensorIDinCount(i)=str2num(cell2mat(target(i)));
    SensorIDinCount2num(i) = find(Embedded_Node.NodeID==SensorIDinCount(i))-size(A,1);
end

clear target N i 
% % Create backup points
% save before_estimation


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             Estimation transition probabilities                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for Distance_Threshold = 850:-50:200

    clearvars -except Distance_Threshold
    load('before_estimation.mat')

    A_between_sensor = D_between_sensor;
    A_between_sensor(A_between_sensor>Distance_Threshold) = 0;
    A_between_sensor(A_between_sensor>0) = 1;

    [x,y] = find(A_between_sensor == 1);

    Result = nan*ones(size(Count_Table,1),length(x));
    O_Result = nan*ones(size(Count_Table,1),size(A_between_sensor,1));
    D_Result = nan*ones(size(Count_Table,1),size(A_between_sensor,1));

    num_of_possible_links = size(Result,2);

    Deal_sequence = [];
    Original_count_simplified = [];
    Count_Modified_store = [];
    Error_store = [];

    parfor i = 1:size(Count_Table,1)

        target = nan*ones(1,size(A_between_sensor,1));
        target(SensorIDinCount2num) = table2array(Count_Table(i,8:end));
        idx = find(~isnan(target));
        target(isnan(target)) = [];
        temp_A_between_sensor = A_between_sensor(idx,idx);

        [node_to_com,com_num] = my_Disjoint_Set_Union(temp_A_between_sensor);
        gcc_table = my_groupby(node_to_com(2,:));
        [~,max_idx] = max(gcc_table.cnt);
        in_gcc_node = find(node_to_com(2,:) == max_idx);

        idx = idx(in_gcc_node);
        temp_A_between_sensor = temp_A_between_sensor(in_gcc_node,in_gcc_node);
        target = target(in_gcc_node);

        Original_count_simplified = [Original_count_simplified;target];

        try_num = 0;

        if ~isempty(target)

            flag = 0;
            while (flag==0)
                [P_M,O,D,flag,count_modified,Error] = my_estimate_p_newton_new(temp_A_between_sensor,target');
            end
            Count_Modified_store = [Count_Modified_store,count_modified];
            Deal_sequence = [Deal_sequence,i];
            Error_store = [Error_store,Error];


            [temp_x,temp_y] = find((temp_A_between_sensor)==1);
            temp_Result = nan * ones(1,num_of_possible_links);
            temp_O = nan * ones(1,size(A_between_sensor,1));
            temp_D = nan * ones(1,size(A_between_sensor,1));

            temp_O(idx) = O';
            temp_D(idx) = D';

            for k = 1:length(temp_x)
                temp_idx = find((x==idx(temp_x(k))) .* (y==idx(temp_y(k))));
                temp_Result(temp_idx) = P_M(temp_x(k),temp_y(k));
            end

            Result(i,:) = temp_Result;

            O_Result(i,:) = temp_O;
            D_Result(i,:) = temp_D;
        end

        fprintf('Now is the %d data point, Distance Threshold = %d.\n',i,Distance_Threshold)
    end

    %% Save results
    % save Result_T{Distance_Threshold}
    eval(['save(''./Estimation/Result_T',num2str(Distance_Threshold),''');'])
end

save before_shuffling Count_Table 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                         Print Figures                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

target = 1;

neighbor_y_index = find(x==target);

temp = Result(1:size(Count_Table,1),neighbor_y_index);

temp_relative = (temp-mean(temp','omitnan')') ./ std(temp','omitnan')';

for i = 1:3%length(neighbor_y_index)
    if min(isnan(temp_relative(find(Count_Table.State==0),i)))==0
        subplot(1,3,i);
        temp = Count_Table.Hour(find(Count_Table.State==0));
        temp(temp==0) = 24;
        my_show_frequency_scatter(temp,temp_relative(find(Count_Table.State==0),i),0.2);
        if i ==3 
            a=get(gca,'colorbar');
            a.Label.String = 'Days';
        end


        hold on;
        plot([0,23],[0,0],'k:','linewidth',3);
        ylim([-3 3]);
        xlabel('Hour')
        if 1 == 1
            ylabel('M_{ij}*')
        end
        set(gca,'FontWeight','Bold', 'FontSize',15,'LineWidth', 2);
        % title([num2str(SensorIDinCount(find(SensorIDinCount2num==x(neighbor_y_index(i))))),'to',num2str(SensorIDinCount(find(SensorIDinCount2num==y(neighbor_y_index(i)))))]);
            title(['(',num2str(SensorIDinCount(find(SensorIDinCount2num==x(neighbor_y_index(i))))),',',num2str(SensorIDinCount(find(SensorIDinCount2num==y(neighbor_y_index(i))))),')']);
    end
end

temp_count = nan * ones(1,size(A_between_sensor,1));
temp_count(SensorIDinCount2num) = table2array(Count_Table(1,8:end));

neighbor_y_index(isnan(temp_count(y(neighbor_y_index)))) = [];

all_nodes = [target,y(neighbor_y_index)'];
temp_position = table2array(Sensor_Position(all_nodes,[2,3]));
figure;my_show_network_with_map(A_between_sensor(all_nodes,all_nodes),temp_position,'ko-')
for i = 1:length(all_nodes)
    % text(temp_position(i,1)+0.00001,temp_position(i,2)+0.00001,[num2str(all_nodes(i)),'&Sensor:',num2str(SensorIDinCount(find(SensorIDinCount2num==all_nodes(i))))],'Color','red','FontSize',13);
    text(temp_position(i,1)+0.00001,temp_position(i,2)+0.00001,['#',num2str(SensorIDinCount(find(SensorIDinCount2num==all_nodes(i))))],'Color','blue','FontSize',13,'FontWeight','bold');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%           Present Network          %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

target = 1;

% temp_relative = (Result-BaseLine) ./ BaseLine;


P_M = ones(size(A_between_sensor)) * nan;

% P_M(sub2ind(size(A_between_sensor),x,y)) = temp_relative(target,:);
P_M(sub2ind(size(A_between_sensor),x,y)) = Result(target,:);

temp_count = nan * ones(1,size(P_M,1));
temp_count(SensorIDinCount2num) = table2array(Count_Table(target,8:end));

temp_P_M = P_M;
% temp_P_M(temp_P_M==0) = nan;
idx = find(min(isnan(temp_P_M))==0);

% P_M(idx,idx)'*temp_count(idx)' - temp_count(idx)'

temp_P_M = P_M(idx,idx);
temp_P_M = (temp_P_M - mean(temp_P_M','omitnan')') ./ std(temp_P_M','omitnan')';


my_show_flow(temp_P_M,A_between_sensor(idx,idx),[Sensor_Position.new_Latitude(idx),Sensor_Position.new_Longitude(idx)]',temp_count(idx));
