mkdir('./Null')
% mkdir('./Null/Randomized')
mkdir('./Null/Shuffled')


% for repeat_time = 1:10

%     clearvars -except repeat_time

%     load('./before_shuffling.mat')

%     Hour = Count_Table.Hour;
%     Count_Table_Randomized = Count_Table;

%     for i = 8:size(Count_Table,2)

%         temp = table2array(Count_Table(:,i));
%         temp_Randomized = 100*rand(size(temp));

%         Count_Table_Randomized(:,i) = mat2cell(temp_Randomized,ones(size(temp_Randomized)),1);

%     end

%     % save Suffled_{repeat_time} Count_Table_Randomized
%     eval(['save ./Null/Randomized/Randomized_',num2str(repeat_time),' Count_Table_Randomized'])

% end

for repeat_time = 1:10

    clearvars -except repeat_time

    load('./before_shuffling.mat')

    Hour = Count_Table.Hour;
    Count_Table_Shuffled = Count_Table;
    
    for i = 8:size(Count_Table,2)
    
        temp = table2array(Count_Table(:,i));
        temp_shuffled = nan*ones(size(temp));
    
        for system_states = min(Count_Table.State): max(Count_Table.State)

            temp_window = find(Count_Table.State == system_states);
            temp_Hour = Hour(temp_window);
        
            for target_Hour = 0:1:23
                temp_target = temp_window(find(temp_Hour == target_Hour));
                temp_shuffled(temp_target) = temp(temp_target(randperm(length(temp_target))));
            end
    
        end
    
        Count_Table_Shuffled(:,i) = mat2cell(temp_shuffled,ones(size(temp_shuffled)),1);
    
    end

    % save Suffled_{repeat_time} Count_Table_Randomized
    eval(['save ./Null/Shuffled/Shuffled_',num2str(repeat_time),' Count_Table_Shuffled'])

end

Distance_Threshold_array = [450];


% for repeat_time = 1:10

%     clearvars -except repeat_time Distance_Threshold_array

%     load('before_estimation.mat')

%     % load('save Suffled_{repeat_time}.mat')
%     eval(['load(''./Null/Randomized/Randomized_',num2str(repeat_time),'.mat'')'])

%     Count_Table = Count_Table_Randomized;

%     for t = 1:length(Distance_Threshold_array)

%         Distance_Threshold = Distance_Threshold_array(length(Distance_Threshold_array)-t+1);

%         A_between_sensor = D_between_sensor;
%         A_between_sensor(A_between_sensor>Distance_Threshold) = 0;
%         A_between_sensor(A_between_sensor>0) = 1;
        
%         [x,y] = find(A_between_sensor + eye(size(A_between_sensor)) == 1);
        
%         % my_show_network_with_map(A_between_sensor,[Embedded_Node.y(end-size(A_between_sensor,1)+1:end),Embedded_Node.x(end-size(A_between_sensor,1)+1:end)],'b.-')
        
%         Result = nan*ones(size(Count_Table,1),length(x));
%         O_Result = nan*ones(size(Count_Table,1),size(A_between_sensor,1));
%         D_Result = nan*ones(size(Count_Table,1),size(A_between_sensor,1));

%         num_of_possible_links = size(Result,2);
        
%         Cant_Find_Answer = [];
%         Original_count_simplified = [];
%         Count_Modified_store = [];
%         Error_store = [];
%         Deal_sequence = [];
        
        
%         parfor i = 1:size(Count_Table,1)
        
        
%             target = nan*ones(1,size(A_between_sensor,1));
%             target(SensorIDinCount2num) = table2array(Count_Table(i,8:end));
%             idx = find(~isnan(target));
%             target(isnan(target)) = [];
%             temp_A_between_sensor = A_between_sensor(idx,idx);
        
%             [node_to_com,com_num] = my_Disjoint_Set_Union(temp_A_between_sensor);
%             gcc_table = my_groupby(node_to_com(2,:));
%             [~,max_idx] = max(gcc_table.cnt);
%             in_gcc_node = find(node_to_com(2,:) == max_idx);
        
%             idx = idx(in_gcc_node);
%             temp_A_between_sensor = temp_A_between_sensor(in_gcc_node,in_gcc_node);
%             target = target(in_gcc_node);
        
%             % % Randomizing the observation
%             % target = rand(size(target))*100;
        
%             Original_count_simplified = [Original_count_simplified;target];
        
%             try_num = 0;
        
%             if ~isempty(target)

%                 flag = 0;
%                 while (flag==0)
%                     [P_M,O,D,flag,count_modified,Error] = my_estimate_p_newton_new(temp_A_between_sensor,target');
%                 end
%                 Count_Modified_store = [Count_Modified_store,count_modified];
%                 Deal_sequence = [Deal_sequence,i];
%                 Error_store = [Error_store,Error];
    
        
%                 [temp_x,temp_y] = find((temp_A_between_sensor)==1);
%                 temp_Result = nan * ones(1,num_of_possible_links);
%                 temp_O = nan * ones(1,size(A_between_sensor,1));
%                 temp_D = nan * ones(1,size(A_between_sensor,1));

%                 temp_O(idx) = O';
%                 temp_D(idx) = D';
%                 for k = 1:length(temp_x)
%                     temp_idx = find((x==idx(temp_x(k))) .* (y==idx(temp_y(k))));
%                     temp_Result(temp_idx) = P_M(temp_x(k),temp_y(k));
%                 end
%                 Result(i,:) = temp_Result;

%                 O_Result(i,:) = temp_O;
%                 D_Result(i,:) = temp_D;
%             end
        
%             fprintf('Now is the %d data point, the %d distance threshold, at %d repeat time.\n',i,Distance_Threshold,repeat_time)
%         end
        
%         % temp = (Count_Modified_store-Original_count_simplified)./Original_count_simplified;
%         % temp(temp==inf) = 0;
%         % max(max(temp))
%         % [tempx,tempy] = find((Count_Modified_store-Original_count_simplified) == max(max(Count_Modified_store-Original_count_simplified)))
        
        
%         % save Result_T{Distance_Threshold}_{repeat_time}
%         eval(['save(''./Null/Randomized/Randomized_Result_T',num2str(Distance_Threshold),'_',num2str(repeat_time),''');'])
%         % eval(['save Randomized_Result_T',num2str(Distance_Threshold)])
%     end

% end


for repeat_time = 1:10

    clearvars -except repeat_time Distance_Threshold_array

    load('before_estimation.mat')

    % load('save Suffled_{repeat_time}.mat')
    eval(['load(''./Null/Shuffled/Shuffled_',num2str(repeat_time),'.mat'')'])

    Count_Table = Count_Table_Shuffled;

    for t = 1:length(Distance_Threshold_array)

        Distance_Threshold = Distance_Threshold_array(length(Distance_Threshold_array)-t+1);

        A_between_sensor = D_between_sensor;
        A_between_sensor(A_between_sensor>Distance_Threshold) = 0;
        A_between_sensor(A_between_sensor>0) = 1;
        
        [x,y] = find(A_between_sensor + eye(size(A_between_sensor)) == 1);
        
        % my_show_network_with_map(A_between_sensor,[Embedded_Node.y(end-size(A_between_sensor,1)+1:end),Embedded_Node.x(end-size(A_between_sensor,1)+1:end)],'b.-')
        
        Result = nan*ones(size(Count_Table,1),length(x));
        O_Result = nan*ones(size(Count_Table,1),size(A_between_sensor,1));
        D_Result = nan*ones(size(Count_Table,1),size(A_between_sensor,1));

        num_of_possible_links = size(Result,2);
        
        Cant_Find_Answer = [];
        Original_count_simplified = [];
        Count_Modified_store = [];
        Error_store = [];
        Deal_sequence = [];
        
        
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
        
            % % Randomizing the observation
            % target = rand(size(target))*100;
        
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
        
                [temp_x,temp_y] = find((temp_A_between_sensor + eye(size(temp_A_between_sensor,1)))==1);
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
        
            fprintf('Now is the %d data point, the %d distance threshold, at %d repeat time.\n',i,Distance_Threshold,repeat_time)
        end
        
        % temp = (Count_Modified_store-Original_count_simplified)./Original_count_simplified;
        % temp(temp==inf) = 0;
        % max(max(temp))
        % [tempx,tempy] = find((Count_Modified_store-Original_count_simplified) == max(max(Count_Modified_store-Original_count_simplified)))
        
        
        % save Result_T{Distance_Threshold}_{repeat_time}
        eval(['save(''./Null/Shuffled/Shuffled_Result_T',num2str(Distance_Threshold),'_',num2str(repeat_time),''');'])
        % eval(['save Randomized_Result_T',num2str(Distance_Threshold)])
    end

end
