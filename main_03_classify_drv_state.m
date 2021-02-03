%clc;
%clear;
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [ input_file_names , file_num ]= dir_FileNames("01_drv_table/*.csv");
[ input_file_names , file_num ]= dir_FileNames("02_drv_table_combined/UE*/*.csv");
disp("File Number = " + file_num)

%% Create output directory
if ~dir_FileExist("./", "03_drv_table_combined_classified")
    mkdir("03_drv_table_combined_classified");
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p_thres = 50;
v_thres = 3;
d_thres = 70;
% thr_thres_list = [1,1,1,1,1,1,1 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(" ---------- Start Classify driving state ---------- ")

for num = 1 : file_num

    input_file_name = input_file_names(num);
    if num < file_num/2+1
        tmp = dir("./02_drv_table_combined/UE1/"+input_file_name);
    else
        tmp = dir("./02_drv_table_combined/UE2/"+input_file_name);
    end
    input_dir = tmp.folder;
    %output_file_name = "classified_" + extractBetween(input_file_name, "table_",".csv") + ".csv";
    output_dir = "./03_drv_table_combined_classified/" + extractAfter(input_dir, '02_drv_table_combined\') + "/";
    output_file_name = "drv_table_combined_classified_" + extractBetween(input_file_name, "table_combined_",".csv") + ".csv";

    drv_states = ["Accelerate","Cruise","Braking","Stop"];

    %% import drv_table timestep:0.05 ms and Decide Driving State for each timestep
    
    disp("read " + input_file_name)
    disp("input dir : " + input_dir)
    disp("output dir : " + output_dir)
    drv_data = readtable(input_dir + "/" + input_file_name);
    %drv_data_org = drv_data_org(100 : height(drv_data_org) - 100,:);

    drv_data.ExistPrecar = drv_data.ExistPrecar & drv_data.distance_P<d_thres & drv_data.distance_P < drv_data.distance_C;


    disp("classify drv_state")
    [ drv_data.state ] = classify_drv_state(drv_data, p_thres, v_thres);

    %% Create a table every 1000ms, 500ms, 200ms, 100ms

    drv_data.Stay_1000 = [abs(drv_data.Thr_dif_future_1000) <= 0.01];
    drv_data.Action_1000 = [drv_data.Thr_dif_future_1000 > 0.01];
    drv_data.Stay_500 = [abs(drv_data.Thr_dif_future_500) <= 0.01];
    drv_data.Action_500 = [drv_data.Thr_dif_future_500 > 0.01];
    drv_data.Stay_200 = [abs(drv_data.Thr_dif_future_200) <= 0.01];
    drv_data.Action_200 = [drv_data.Thr_dif_future_200 > 0.01];
    drv_data.Stay_100 = [abs(drv_data.Thr_dif_future_100) <= 0.01];
    drv_data.Action_100 = [drv_data.Thr_dif_future_100 > 0.01];


    clearvars j idx i
    disp("Set New Variable to drv_data : Action Release")

    writetable(drv_data, output_dir + output_file_name)

    % save("./02_drv_table_combined/" + output_file_name, "drv_data")

    % clearvars -except num input_file_names file_num p_thres_list v_thres_list thr_thres_list

    disp(" ------ Finished  " + num + " / "+ file_num + "---------")
end

% clear num input_file_names file_num p_thres v_thres

%run("plot_data_03.m")

disp(" ----------- All Files Finished  ----------- ")