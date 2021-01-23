%% clc;
clear;
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ input_file_names , file_num ]= dir_FileNames("drv_table_combined/*.csv");

disp("File Number = " + file_num)
disp(" ---------- Start Processing Data ---------- ")

for num = 1  : file_num
    input_file_name = input_file_names(num);
    output_dir_name = extractBetween(input_file_name, "table_",".csv");

    disp("read drv_table.csv")
    drv_table = readtable("./drv_table_combined/" + input_file_name);

    %% Create output files
    if ~dir_FileExist("./pedal_predictor", output_dir_name)
        mkdir("./pedal_predictor/" + output_dir_name);
    end

    writetable(drv_table, "./pedal_predictor/" + output_dir_name + "/drv_table_test.csv")

    %%clearvars -except num input_file_names file_num
    disp(" ------ Finished  " + num + " / "+ file_num + "---------")
end

%%clear num input_file_names file_num 
disp(" ----------- All Files Finished  ----------- ")