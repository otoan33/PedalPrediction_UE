%clc;
%clear;
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ input_file_names , file_num ]= dir_FileNames("01_drv_table/*.csv");
[ input_file_names , file_num ]= dir_FileNames("01_drv_table_combined/*.csv");
disp("File Number = " + file_num)

%% Create output directory
if ~dir_FileExist("./", "02_drv_table_combined")
    mkdir("02_drv_table_combined");
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p_thres_list = [ 60,60,60,60,60,60,60 ];
v_thres_list = [ -5, -5, -5, -10, -5, 0, 0 ];
thr_thres_list = [1,1,1,1,1,1,1 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(" ---------- Start Classify driving state ---------- ")

for num = 1 : file_num

    input_file_name = input_file_names(num);
    %output_file_name = "classified_" + extractBetween(input_file_name, "table_",".csv") + ".csv";
    output_file_name = "classified_cell_" + extractBetween(input_file_name, "table_",".csv") + ".mat";

    drv_states = ["Accelerate","Cruise","Braking","Stop"];

    %% import drv_table timestep:0.05 ms and Decide Driving State for each timestep
    
    disp("read " + input_file_name)
    drv_data_org = readtable("./01_drv_table_combined/" + input_file_name);
    %drv_data_org = drv_data_org(100 : height(drv_data_org) - 100,:);


    disp("classify drv_state")
    [ drv_data_org.state ]= classify_drv_state(drv_data_org, p_thres_list(num), v_thres_list(num), thr_thres_list(num));

    %% Create a table every 1000ms, 500ms, 200ms, 100ms
    d=[1000,500,200]; %[ms]
    step = d/100;
    
    drv_data_1000ms = drv_data_org(~isnan(drv_data_org.Thr_dif_1000), :);
    drv_data_0500ms = drv_data_org(~isnan(drv_data_org.Thr_dif_500),:);
    drv_data_0200ms = drv_data_org(~isnan(drv_data_org.Thr_dif_200),:);

    drv_data_1000ms = drv_data_1000ms(drv_data_1000ms.Include==1,:);
    drv_data_0500ms = drv_data_0500ms(drv_data_0500ms.Include==1,:);
    drv_data_0200ms = drv_data_0200ms(drv_data_0200ms.Include==1,:);

    drv_data={drv_data_1000ms,drv_data_0500ms,drv_data_0200ms,drv_data_org};

    clearvars step d
    clearvars drv_data_1000ms drv_data_0500ms drv_data_0200ms

    %% Classify by whether the next pedal action is zero(0), release(-1), or otherwise(1)
    d = [1000 500 200 100];
    for j = 1:4
        idx = join(['Thr_dif_', num2str(d(j))]);
        for i = 1:height(drv_data{1,j})-1
            if drv_data{1,j}{i,idx}==0
                drv_data{1,j}.action(i) = 0;
                drv_data{1,j}.release(i) = 0;
            elseif drv_data{1,j}.Thr(i) == -1 * drv_data{1,j}{i,idx}
                drv_data{1,j}.action(i) = 1;
                drv_data{1,j}.release(i) = 1;
            else
                drv_data{1,j}.action(i) = 1;
                drv_data{1,j}.release(i) = 0;
            end
        end

    end

    clearvars j idx i
    disp("Set New Variable to drv_data : Action Release")

    save("./02_drv_table_combined/" + output_file_name, "drv_data")

    clearvars -except num input_file_names file_num p_thres_list v_thres_list thr_thres_list

    disp(" ------ Finished  " + num + " / "+ file_num + "---------")
end

clear num input_file_names file_num p_thres v_thres

%run("plot_data_03.m")

disp(" ----------- All Files Finished  ----------- ")