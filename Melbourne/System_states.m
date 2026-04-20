mkdir('./Clustering')
mkdir('./Clustering/Movement')
mkdir('./Clustering/Count')
load('./Estimation/Result_T450.mat')
Result = [Result];

for hour = 5:24
    target = mod(hour,24);

    time_filter = find(Count_Table.Hour==target);

    Count_Table_par = Count_Table(time_filter,:);

    Count_Ensemble = table2array(Count_Table(time_filter,8:end));

    P_Ensemble = Result(time_filter,:);
    P_Ensemble(:,find(min(isnan(P_Ensemble))==1)) = [];

    Date = [num2str(Count_Table_par.Day),'-' * ones(size(Count_Table_par.Month)),num2str(Count_Table_par.Month)];

    open('./Clustering/temp.fig')
    clf;

    Y=pdist(P_Ensemble,'correlation')
    Z=linkage(Y,'complete')
    H=dendrogram(Z,0,'ColorThreshold',median([Z(end-3,3) Z(end-2,3)]),'Labels',Date)

    xlabel('Date (Day-Month)')
    ylabel('D')

    set(H,'LineWidth',2)
    set(gca,'FontSize',24)
    set(gca,'linewidth',2)
    xtickangle(75)
    %saveas(gca,'./Clustering/{target}.fig')
    eval(['saveas(gca,''./Clustering/Movement/',num2str(target),'.fig'')'])
    eval(['saveas(gca,''./Clustering/Movement/',num2str(target),'.png'')'])

    close;

    open('./Clustering/temp.fig')
    clf;
    Y=pdist(Count_Ensemble,'correlation')
    Z=linkage(Y,'complete')
    H=dendrogram(Z,0,'ColorThreshold',median([Z(end-2,3) Z(end-3,3)]),'Labels',Date)
    set(H,'LineWidth',2)
    set(gca,'FontSize',24)
    set(gca,'linewidth',2)
    xtickangle(75)
    
    xlabel('Date (Day-Month)')
    ylabel('D')
    eval(['saveas(gca,''./Clustering/Count/',num2str(target),'_count.fig'')'])
    eval(['saveas(gca,''./Clustering/Count/',num2str(target),'_count.png'')'])
    close;

end