%并查集
%用于查找网络中的连通集团数
%2021-05-14 CWT

function [node_to_com,com_num] = my_Disjoint_Set_Union(A)

%init
N = size(A,2);
node_to_com = zeros(2,N);
node_to_com(1,:) = 1:N;
node_to_com(2,:) = 1:N;

for i = 1:N
    for j = i+1:N 
        if (A(i,j) == 1)
            index1 = node_to_com(2,i);
            index2 = node_to_com(2,j);
            index = min(index1,index2);
            node_to_com(2,find(node_to_com(2,:) == index1)) = index;
            node_to_com(2,find(node_to_com(2,:) == index2)) = index;
        end
    end
end

com_num = numel(unique(node_to_com(2,:)));

%将root_node转化为社团号
root_num = unique(node_to_com(2,:));
for i = 1:com_num
    temp = root_num(i);
    node_to_com(2,find(node_to_com(2,:) == temp)) = i;
end