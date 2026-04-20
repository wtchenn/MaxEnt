%%����һ��������ڽ����Լ�һ����Ӧ������,�������ӡ����Ļ��
%%CWT 2020-11-15

%AΪ�ڽ���,pos_tableΪλ�ñ�,sΪ�������ʽ
function my_show_network(A,pos_table,s)

N = size(A,2); 

for i = 1 : N
    for j = i+1 : N
        if A(i,j) == 1
            xx = pos_table([i,j],1)';
            yy = pos_table([i,j],2)';
            hold on;
            plot(xx,yy,s,'linewidth',2)
        end
    end
end