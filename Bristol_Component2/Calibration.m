% To calibration the data and select the best network models

load('./Estimation/Result_T200.mat')

Count = Count_Table;

for h = 1:24

    filterAttime = find(Count_Table.Hour==mod(h,24));
    Count_Table_filtered = Count_Table(filterAttime,:);
    Count_Filtered = nan * ones(size(filterAttime,1),144);
    Count_Filtered(1:size(filterAttime,1),SensorIDinCount2num) = table2array(Count_Table(filterAttime,8:end));

    %%% 

    for Distance_Threshold = 200:50:1000

        % load('Result_T{Distance_Threshold}.mat')
        eval(['load(''./Estimation/Result_T',num2str(Distance_Threshold),'.mat'')'])

        P_M_Average_Model = zeros(size(A_between_sensor));
        P_M_Average_Model(sub2ind(size(P_M_Average_Model),x,y)) = mean(Result(filterAttime,:),'omitnan');
        D_Average_Model = mean(D_Result);

        temp_P_M = P_M_Average_Model;
        temp_P_M(temp_P_M==0) = nan;
        idx = find(min(isnan(temp_P_M))==0);
        clear temp_P_M;

        Calibration_Result = nan * ones(length(filterAttime),size(A_between_sensor,2));

        for i = 1:length(filterAttime)
            error = (P_M_Average_Model(idx,idx)' * Count_Filtered(i,idx)' - Count_Filtered(i,idx)'.*(1-D_Average_Model(idx)'))./sum(Count_Filtered(i,idx)');
            % error = (P_M_Average_Model(idx,idx)' * Count_Filtered(i,idx)' - Count_Filtered(i,idx)'.*(1-D_Average_Model(idx)'));
            error(Count_Filtered(i,idx)'==0) = nan;
            Calibration_Result(i,idx) = error';
        end 

        % Calibration_Result_{Distance_Threshold} = Calibration_Result;
        eval(['Calibration_Result_',num2str(Distance_Threshold),' = Calibration_Result;'])
    end

    Result_in_total = [];

    for Distance_Threshold = 200:50:1000
        % Result_in_total = [Result_in_total;mean(abs(Calibration_Result_{Distance_Threshold}),'omitnan')];
        eval(['Result_in_total = [Result_in_total;mean(abs(Calibration_Result_',num2str(Distance_Threshold),'),''omitnan'')];'])
        % eval(['Result_in_total = [Result_in_total;mean(abs(Calibration_Result_',num2str(Distance_Threshold),'))];'])
    end
    % Result_in_total_{h} = Result_in_total;
    eval(['Result_in_total_',num2str(h),' = Result_in_total;'])
end

errorbar(mean(Result_in_total','omitnan'),std(Result_in_total','omitmissing'))

temp_result = [];
clr = jet(21);

for h = 5:24

    % temp = mean(Result_in_total_{h}','omitnan');
    eval(['temp = mean(Result_in_total_',num2str(h),''',''omitnan'');'])

    %plot(200:50:1000,temp,'-x','MarkerSize',10,'color',clr(h-3,:),'linewidth',2)
    temp_result = [temp_result;(temp-min(temp))./(max(temp)-min(temp))];
    hold on;


end



hold on;
subplot(3,2,[1,2,3,4])
errorbar(200:50:1000,mean(temp_result,'omitnan'),std(temp_result,'omitnan'),'linewidth',3)
ylabel('Rescaled Error')
set(gca,'FontSize',15)
set(gca,'FontWeight','bold')
ylim([0 1])
xlim([175 1025])

subplot(3,2,[5,6])
bar(200:50:1000,sum(~isnan(Result_in_total')))
ylabel('Size of GCC')
xlabel('Distance Threshold (m)')
ylim([0 10])
set(gca,'FontSize',15)
set(gca,'FontWeight','bold')



