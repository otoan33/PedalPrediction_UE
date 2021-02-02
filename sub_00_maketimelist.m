%% clc;
clear
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Course_Number = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Course_Number == 1
    [ input_file_names , file_num ]= dir_FileNames("00_drivingdata/UE1/Driver_0*/*.csv");
    %input_dir = "./00_drivingdata/UE1/Driver_01/";
    map_input = "./map_data/map_UE_1.xlsx";
    Precar1_input = "./map_data/map_UE_1_Precar1.xlsx";
    Precar1_trigger = [0,0];
    Precar1_Speed = [40, 30, 45];
    Precar2_input = "./map_data/map_UE_1_Precar2.xlsx";
    Precar2_trigger = [1000,-1000];
    Precar2_Speed = [20, 45, 60];
    Precar3_input = "./map_data/map_UE_1_Precar3.xlsx";
    Precar3_trigger = [407.5,-490.6];
    Precar3_Speed = [35, 40, 40];
    Precar4_input = "./map_data/map_UE_1_Precar4.xlsx";
    Precar4_trigger = [10,-700];
    Precar4_Speed = [20, 30, 45];
elseif Course_Number == 2
    [ input_file_names , file_num ]= dir_FileNames("00_drivingdata/UE2/Driver_0*/*.csv");
    map_input = "./map_data/map_UE_1.xlsx";
    % Precar1_input = "./map_data/map_UE_1_Precar1.xlsx";
    % Precar1_trigger = [0,0];
    % Precar1_Speed = [40, 30, 45];
    % Precar2_input = "./map_data/map_UE_1_Precar2.xlsx";
    % Precar2_trigger = [1000,-1000];
    % Precar2_Speed = [20, 45, 60];
    % Precar3_input = "./map_data/map_UE_1_Precar3.xlsx";
    % Precar3_trigger = [407.5,-490.6];
    % Precar3_Speed = [35, 40, 40];
    % Precar4_input = "./map_data/map_UE_1_Precar4.xlsx";
    % Precar4_trigger = [10,-700];
    % Precar4_Speed = [20, 30, 45];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Create output directory
if ~dir_FileExist("./", "01_drv_table")
    mkdir("01_drv_table");
end

TimeLists = table;
map_data = readtable(map_input);

for num = 1 : file_num

    input_file_name = input_file_names(num);
    tmp = dir("./00_drivingdata/UE*/Driver_0*/"+input_file_name);
    input_dir = tmp.folder;
    output_file_name = "drv_table_" + extractBetween(input_file_name, "2021-",".csv") + ".csv";

    clearvars tmp

    %% import driving data / map data
    disp("Input File : " + input_file_name)
    disp("Output File : " + output_file_name)
    disp("Map File : " + map_input)

    driving_data = readtable(input_dir + "/" + input_file_name);


    drv_table = table;
    drv_table.Time = driving_data.Time - driving_data.Time(1);

    %% SET ROAD NUMBER
    disp("Start SET ROAD NUMBER")
    road_num = 0;
    curve_state = 0;
    tmp=0;
    for i = 1 : height(drv_table)
        if road_num == 0
            turn_x = 1.8;
            turn_y = 1.8;
        else
            turn_x = map_data.x(road_num);
            turn_y = map_data.y(road_num);
        end

        
        if i < tmp+120
            drv_table.Road_num(i) = 0;
        elseif curve_state==0 & abs(driving_data.Xo(i)-turn_x) + abs(driving_data.Yo(i)-turn_y) < 20
            tmp=i;
            drv_table.Road_num(i) = 0;
            if (curve_state == 0)
                curve_state = 1;
            end
            if road_num == 11
                drv_table.Road_num(i) = 11;
                road_num=12;
                curve_state = 0;
                tmp=0;
            elseif road_num == 13
                drv_table.Road_num(i) = 13;
                road_num=14;
                curve_state = 0;
                tmp=0;
            end
        elseif curve_state == 1 & abs(driving_data.Steer_SW(i)) > 50
            drv_table.Road_num(i) = 0;
        else
            if (curve_state == 1)
                curve_state = 0;
                road_num = road_num + 1;
                if road_num>14
                    road_num = road_num -14;
                end
            end
            drv_table.Road_num(i) = road_num;
        end
    end

    drv_table.Include = (drv_table.Road_num~=0);

    clearvars i curve_state road_num lap_num turn_x turn_y


    TimeList=table;
    TimeList.drv_file_name = input_file_name;
    TimeList.idx_start =  find(drv_table.Road_num==1,1,"first");
    TimeList.idx_end =  find(drv_table.Road_num==14,1,"last");
    TimeList.time_start = drv_table.Time(TimeList.idx_start);
    TimeList.time_end = drv_table.Time(TimeList.idx_end);

    TimeLists(num,:)=TimeList;
end