%% clc;
clear;
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ input_dir_names , dir_num ] = dir_FileNames("01_drv_table/UE2/Driver_0*");

disp("File Number = " + dir_num)

%% Create output directory
if ~dir_FileExist("./", "02_drv_table_combined")
    mkdir("02_drv_table_combined");
end

for num = 1:dir_num
    input_dir_name = input_dir_names(num);
    [ input_file_names , file_num ] = dir_FileNames("01_drv_table/UE2/"+input_dir_name+"/*.csv");

    output_file_name = "drv_table_combined_Driver_0" + num2str(num)+".csv";
    if num > 10
        output_file_name = "drv_table_combined_Driver_0" + num2str(num)+".csv";
    end

    % if dir_FileExist("./02_drv_table_combined/UE1/", output_file_name)
    %     disp(input_dir_name + " Already Combined")
    %     continue
    % end

    drv_data_combined = readtable("01_drv_table/UE2/"+input_dir_name+"/"+input_file_names(1));
    disp(input_file_names(1))
    for i = 2:file_num
        drv_data = readtable("01_drv_table/UE2/"+input_dir_name+"/"+input_file_names(i));
        drv_data_combined = vertcat(drv_data_combined, drv_data);
        disp(input_file_names(i))
    end


    writetable(drv_data_combined, "./02_drv_table_combined/UE2/" + output_file_name)

    disp(" ------ Finished  " + num + " / "+ dir_num + "---------")

    clearvars -except  input_dir_names dir_num num

end

clearvars input_dir_names dir_num num

disp(" ----------- All Files Finished  ----------- ")
