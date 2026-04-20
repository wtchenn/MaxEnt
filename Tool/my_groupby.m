%select label,count(*) from array group by label;
%CWT 2021-05-14

function result = my_groupby(array)

group_num = unique(array);

result = table(group_num',zeros(size(group_num))','VariableNames',{'cate' 'cnt'});

for i = 1 : length(result.cate)
    result.cnt(i) = sum(array == result.cate(i));
end
