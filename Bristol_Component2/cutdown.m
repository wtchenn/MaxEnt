%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                  Cut into two                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('before_estimation.mat')

A_sensor = D_between_sensor;

A_sensor(A_sensor<1500) = 1;
A_sensor(A_sensor>1500) = 0;

[node_to_com,com_num] = my_Disjoint_Set_Union(A_sensor)

CC_1 = node_to_com(1,find(node_to_com(2,:)==4));
CC_2 = setdiff([1:41],CC_1);

% >18 CC_1
% <=18 CC_2

target1 = find(SensorIDinCount>18);
target2 = find(SensorIDinCount<=18);

Count_Table = Count_Table(:,[1:7,7+target2]);
SensorIDinCount = SensorIDinCount(target2);
SensorIDinCount2num = SensorIDinCount2num(target2);

save before_estimation_CC2