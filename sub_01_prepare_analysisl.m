%clc;
clear;
close all;

addpath("tools","function")

[ input_file_names , file_num ]= dir_FileNames("03_drv_table_combined_classified/UE1/*.csv");
disp("File Number = " + file_num)

Input_Amount = ["Accel","Speed"];

for num=1:1%file_num
    input_file_name = input_file_names(num);
    disp("read " + input_file_name)
    drv_data = readtable("./03_drv_table_combined_classified/UE1/" + input_file_name);

    drv_data.va = drv_data.Speed.*drv_data.Accel;
    drv_data.v2 = drv_data.Speed.*drv_data.Speed;
    drv_data.vthr = drv_data.Speed.*drv_data.Thr;
    drv_data.difvlim = drv_data.Speed_lim - drv_data.Speed;
    drv_data.difvp = drv_data.Speed_P - drv_data.Speed;
    drv_data.v2dc = drv_data.v2./ - drv_data.distance_C;
    drv_data.v2dp = drv_data.v2./ - drv_data.distance_P;

end
