function [fig,mean_in_bin,std_in_bin] = my_show_frequency_scatter(x,y,y_std)

mean_in_bin = [];
std_in_bin = [];
delete = isnan(y);
x(delete) = [];
y(delete) = [];

fig = [];

if isempty(y)
    return;
end

unique_x = unique(x);

y_neighbor = zeros(size(y));

for i = 1:length(unique_x)
    temp_bin_idx = find(x == unique_x(i));
    temp_bin = y(temp_bin_idx);
    mean_in_bin = [mean_in_bin,[unique_x(i);mean(temp_bin,'omitnan')]];
    std_in_bin = [std_in_bin,[unique_x(i);std(temp_bin,'omitnan')]];

    for j = 1:length(temp_bin_idx)
        y_neighbor(temp_bin_idx(j)) = length(find((temp_bin<temp_bin(j)+y_std) .* (temp_bin>temp_bin(j)-y_std))) - 1;
    end
end

mx = max(y_neighbor)+1;
colors = jet(mx);

cMatrix = colors(y_neighbor+1,:);

fig = scatter(x, y, 15, cMatrix, 'filled');
colormap(colors);

colorbar;

if mx > 10
    colorbar('YTick', linspace(0, 1, 10), 'YTickLabel', round(1:mx/10:mx));
else
    colorbar('YTick', linspace(0, 1, mx), 'YTickLabel', 1:1:mx);
end

hold on;
plot(mean_in_bin(1,:),mean_in_bin(2,:),':r','linewidth',2);
xlim([min(mean_in_bin(1,:)) max(mean_in_bin(1,:))]);



% colorbar('YTick', linspace(1/(2*mx), 1-1/(2*mx), 10), 'YTickLabel', 1:ceil(mx/10):mx);
% colorbar('YTick', linspace(0, 1, 10), 'YTickLabel', 1:round(mx/10):mx);