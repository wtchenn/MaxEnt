Thresholds = [450];

Reality_std_table = [];

for t = 1:length(Thresholds)
    i = Thresholds(t);
    % load('Result_T{i}.mat');
    eval(['load(''./Estimation/Result_T',num2str(i),'.mat'');']);
    target = Result(Count_Table.State==0,:);
    target = target(:,find(min(isnan(target))==0));
    temp_table = nan * ones(1,24);
    for h = 1:24
        temp_idx = find(Count_Table.Hour(Count_Table.State==0) == mod(h,24));
        temp_table(h) = mean(std(target(temp_idx,:)));
    end

    Reality_std_table = [Reality_std_table;temp_table];
end

clearvars -except Reality_std_table Thresholds Count_Table

for repeat_time = 1:10

    % Randomized_std_table = [];

    % for t = 1:length(Thresholds)
    %     i = Thresholds(t);
    %     % load('Result_T{i}.mat');
    %     eval(['load(''./Null/Randomized/Randomized_Result_T',num2str(i),'_',num2str(repeat_time),'.mat'');']);
    %     target = Result(Count_Table.State==1,:);
    %     target = target(:,find(min(isnan(target))==0));
    %     temp_table = nan * ones(1,24);
    %     for h = 5:24
    %         temp_idx = find(Count_Table.Hour(Count_Table.State==1) == mod(h,24));
    %         temp_table(h) = mean(std(target(temp_idx,:)));
    %     end

    %     Randomized_std_table = [Randomized_std_table;temp_table];
    % end


    % % Randomized_std_table_{repeat_time} = Randomized_std_table;
    % eval(['Randomized_std_table_',num2str(repeat_time),' = Randomized_std_table;'])

    Shuffled_std_table = [];


    for t = 1:length(Thresholds)
        i = Thresholds(t);
        % load('Result_T{i}.mat');
        eval(['load(''./Null/Shuffled/Shuffled_Result_T',num2str(i),'_',num2str(repeat_time),'.mat'');']);
        target = Result(Count_Table.State==0,:);
        target = target(:,find(min(isnan(target))==0));
        temp_table = nan * ones(1,24);
        for h = 1:24
            temp_idx = find(Count_Table.Hour(Count_Table.State==0) == mod(h,24));
            temp_table(h) = mean(std(target(temp_idx,:)));
        end

        Shuffled_std_table = [Shuffled_std_table;temp_table];
    end

    % Shuffled_std_table_{repeat_time} = Shuffled_std_table;
    eval(['Shuffled_std_table_',num2str(repeat_time),'= Shuffled_std_table;'])

end


target_Thresholds = [1];

for j = 1:length(target_Thresholds)

    i = target_Thresholds(j);
    target = Thresholds(target_Thresholds(j));

    %subplot(3,3,j);

    plot(1:24,Reality_std_table(i,:),'-x','linewidth',2,'color',[0 0.4470 0.7410])
    hold on 

    temp_randomized = [];
    temp_shuffled = [];

    for repeat_time = 1:10
        % temp_randomized = [temp_randomized;Randomized_std_table_{repeat_time}(target,:)];
        % eval(['temp_randomized = [temp_randomized;Randomized_std_table_',num2str(repeat_time),'(i,:)];'])
        % temp_shuffled = [temp_shuffled;Shuffled_std_table_{repeat_time}(target,:)];
        eval(['temp_shuffled = [temp_shuffled;Shuffled_std_table_',num2str(repeat_time),'(i,:)];'])
    end

    % plot(1:24,temp_shuffled,'-bx','linewidth',3)
    errorbar(1:24,mean(temp_shuffled),std(temp_shuffled))
    % plot(1:24,temp_randomized,'-rx','linewidth',3)
    % errorbar(1:24,mean(temp_randomized),std(temp_randomized))
    legend('Reality','Shuffled')

    title(['Threshold:',num2str(target),'m'])
    xlabel('Hour')
    set(gca,'FontSize',12,'LineWidth', 1)
    set(gca,'FontWeight','bold')
    ylabel('Std^h - Weekdays')
    xlim([1 24])

end