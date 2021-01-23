%% clc;
clear;
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ input_file_names , file_num ]= dir_FileNames("01_drv_table/*.csv");

disp("File Number = " + file_num)

%% Create output directory
if ~dir_FileExist("./", "01_drv_table_combined")
    mkdir("01_drv_table_combined");
end

for num = 1:file_num/2
    input_file_name_1 = input_file_names( 2 * num - 1 );
    input_file_name_2 = input_file_names( 2 * num );
    output_file_name = "drv_table_combined_00" + num2str(num)+".csv";

    drv_data_1 = readtable("./01_drv_table/" + input_file_name_1);
    drv_data_2 = readtable("./01_drv_table/" + input_file_name_2);

    drv_data_combined = vertcat(drv_data_1,drv_data_2);

    %% add variables

    drv_data_combined.distance = min(drv_data_combined.distance_C, drv_data_combined.distance_P);
    drv_data_combined.v_dif_lim = drv_data_combined.Speed - drv_data_combined.Speed_lim;
    drv_data_combined.v_dif_pre = drv_data_combined.Speed - drv_data_combined.Speed_P;
    drv_data_combined.v_dif = max(drv_data_combined.v_dif_lim, drv_data_combined.v_dif_pre);

    writetable(drv_data_combined, "./01_drv_table_combined/" + output_file_name)
    disp(input_file_name_1)
    disp(input_file_name_2)
    disp(" ------ Finished  " + num + " / "+ file_num/2 + "---------")

    clearvars -except  input_file_names file_num num

end

clearvars input_file_names file_num num

disp(" ----------- All Files Finished  ----------- ")
