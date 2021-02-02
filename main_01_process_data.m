%% clc;
clear
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Course_Number = 1;

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

disp("File Number = " + file_num)
disp(" ---------- Start Processing Data ---------- ")

TimeLists = table;

for num = 1 : 2%file_num

    input_file_name = input_file_names(num);
    tmp = dir("./00_drivingdata/UE*/Driver_0*/"+input_file_name);
    input_dir = tmp.folder;
    output_file_name = "drv_table_" + extractBetween(input_file_name, "2021-",".csv") + ".csv";

    clearvars tmp

    %% import driving data / map data
    disp("Input File : " + input_file_name)
    disp("Output File : " + output_file_name)
    disp("Map File : " + map_input)
    if dir_FileExist("./01_drv_table/UE2/Driver_0*/", output_file_name)
        disp("Already Pcocessed")
        continue
    end
    driving_data = readtable(input_dir + "/" + input_file_name);
    map_data = readtable(map_input);
    Precar1 = readtable(Precar1_input);
    Precar2 = readtable(Precar2_input);
    Precar3 = readtable(Precar3_input);
    Precar4 = readtable(Precar4_input);

    %% Replace the initial value of time with zero
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

    %% Set other data
    drv_table.Station = driving_data.Station;
    drv_table.Thr = driving_data.Throttle;
    drv_table.Steer_SW = driving_data.Steer_SW;
    drv_table.Speed = driving_data.Vx;
    drv_table.Accel = driving_data.Ax;
    if num<6
        drv_table.Bk_Stat = (driving_data.Throttle==0)&driving_data.Ax<-0.07;
    else
        drv_table.Bk_Stat = driving_data.Pbk_Con > 0.25;
        drv_table.Pbk_Con = driving_data.Pbk_Con;
    end
    drv_table.X = driving_data.Xo;
    drv_table.Y = driving_data.Yo;

    drv_table.Thr_dif_pre_1000 = drv_table.Thr - [zeros(40,1); drv_table.Thr(1:height(drv_table)-40);];
    drv_table.Thr_dif_pre_500 = drv_table.Thr - [zeros(20,1); drv_table.Thr(1:height(drv_table)-20);];
    drv_table.Thr_dif_pre_200 = drv_table.Thr - [zeros(8,1); drv_table.Thr(1:height(drv_table)-8);];
    drv_table.Thr_dif_pre_100 = drv_table.Thr - [zeros(4,1); drv_table.Thr(1:height(drv_table)-4);];
    drv_table.Thr_dif_future_1000 = [drv_table.Thr(41:height(drv_table)); zeros(40,1);] - drv_table.Thr;
    drv_table.Thr_dif_future_500 = [drv_table.Thr(21:height(drv_table)); zeros(20,1);] - drv_table.Thr;
    drv_table.Thr_dif_future_200 = [drv_table.Thr(9:height(drv_table)); zeros(8,1);] - drv_table.Thr;
    drv_table.Thr_dif_future_100 = [drv_table.Thr(5:height(drv_table)); zeros(4,1);] - drv_table.Thr;



    %% Edit Time %%%%%%%%

    TimeList=table;
    TimeList.drv_file_name = input_file_name;
    TimeList.idx_start =  find(drv_table.Road_num==1,1,"first");
    TimeList.idx_end =  find(drv_table.Road_num==14,1,"last");
    TimeList.time_start = drv_table.Time(TimeList.idx_start);
    TimeList.time_end = drv_table.Time(TimeList.idx_end);

    drv_table = drv_table(TimeList.idx_start-40:TimeList.idx_end+40,:);
    drv_table.Time = drv_table.Time-drv_table.Time(1);

    TimeLists(num,:)=TimeList;

    clearvars tmp a1

    %% caluculate distance to road boundary point
    %% SET V_lim
    disp("Start Calc D_corner")
    for i = 1 : height(drv_table)
        if drv_table.Road_num(i) == 0
            drv_table.distance_C(i) = 0;
            continue
        end

        drv_table.RoadType(i) = map_data.Road(drv_table.Road_num(i));
        drv_table.ExistPrecar(i) = map_data.ExistPrecar(drv_table.Road_num(i));
        drv_table.ExistO1(i) = map_data.ExistO1(drv_table.Road_num(i));
        drv_table.ExistO2(i) = map_data.ExistO2(drv_table.Road_num(i));
        drv_table.Speed_lim(i) = map_data.vlim(drv_table.Road_num(i));
        drv_table.Speed_O1(i) = map_data.vo1(drv_table.Road_num(i));
        drv_table.Speed_O2(i) = map_data.vo2(drv_table.Road_num(i));

        drv_table.distance_C(i) = abs(drv_table.X(i)-map_data.x(drv_table.Road_num(i))) + abs(drv_table.Y(i)-map_data.y(drv_table.Road_num(i)));
        if drv_table.Road_num(i) == 11
            drv_table.distance_C(i) = drv_table.distance_C(i) + 498.2;
        elseif drv_table.Road_num(i) == 13
            drv_table.distance_C(i) = drv_table.distance_C(i) + 498.2;
        end

    end

    clearvars i



    %% caluculate distance to preceding car
    disp("Start Calc D_precar")
    isStarted_Precar1 = false;
    isStarted_Precar2 = false;
    isStarted_Precar3 = false;
    isStarted_Precar4 = false;
    for i = 1 : height(drv_table)
        %% PrecedingCar 1 %%
        if (~isStarted_Precar1) & abs(drv_table.X(i)-Precar1_trigger(1)) + abs(drv_table.Y(i)-Precar1_trigger(2)) < 15
            isStarted_Precar1 =true;
            T0_Precar1 = i-1;
        end

        if isStarted_Precar1
            if drv_table.Road_num(i) == 1
                drv_table.distance_P(i) = Precar1.S(i - T0_Precar1) - (-drv_table.Y(i)-1.8);
                drv_table.Speed_P(i) = Precar1_Speed(1);
            elseif drv_table.Road_num(i) == 2
                drv_table.distance_P(i) = Precar1.S(i - T0_Precar1) - (396.4 + drv_table.X(i) - 1.8);
                drv_table.Speed_P(i) = Precar1_Speed(2);
            elseif drv_table.Road_num(i) == 3
                drv_table.distance_P(i) = Precar1.S(i - T0_Precar1) - (596.4 - drv_table.Y(i) - 398.2);
                drv_table.Speed_P(i) = Precar1_Speed(3);
            elseif drv_table.Road_num(i) == 4
                isStarted_Precar1 = false;
            end
        end

        %% PrecedingCar 2 %%
        if (~isStarted_Precar2) & abs(drv_table.X(i)-Precar2_trigger(1)) + abs(drv_table.Y(i)-Precar2_trigger(2)) < 15
            isStarted_Precar2 =true;
            T0_Precar2 = i-1;
        end

        if isStarted_Precar2
            if drv_table.Road_num(i) == 11
                drv_table.distance_P(i) = Precar2.S(i - T0_Precar2) - (1014.5 + drv_table.Y(i));
                drv_table.Speed_P(i) = Precar2_Speed(2);
                if Precar2.S(i - T0_Precar2) > 314.5
                    drv_table.Speed_P(i) = Precar2_Speed(3);
                end
            elseif drv_table.Road_num(i) == 12
                drv_table.distance_P(i) = Precar2.S(i - T0_Precar2) - (1014.5 + drv_table.Y(i));
                drv_table.Speed_P(i) = Precar2_Speed(3);
            elseif drv_table.Road_num(i) == 13
                isStarted_Precar2 = false;
            end
        end

        %% PrecedingCar 3 %%
        if (~isStarted_Precar3) & abs(drv_table.X(i)-Precar3_trigger(1)) + abs(drv_table.Y(i)-Precar3_trigger(2)) < 15
            isStarted_Precar3 =true;
            T0_Precar3 = i-1;
        end

        if isStarted_Precar3
            if drv_table.Road_num(i) == 8
                drv_table.distance_P(i) = Precar3.S(i - T0_Precar3) - (drv_table.X(i)-398.3);
                drv_table.Speed_P(i) = Precar3_Speed(1);
            elseif drv_table.Road_num(i) == 9
                drv_table.distance_P(i) = Precar3.S(i - T0_Precar3) - (250 - drv_table.Y(i) - 488.8);
                drv_table.Speed_P(i) = Precar3_Speed(2);
            elseif drv_table.Road_num(i) == 10
                isStarted_Precar3 = false;
            end
        end

        %% PrecedingCar 4 %%
        if (~isStarted_Precar4) & abs(drv_table.X(i)-Precar4_trigger(1)) + abs(drv_table.Y(i)-Precar4_trigger(2)) < 15
            isStarted_Precar4 = true;
            T0_Precar4 = i-1;
        end

        if isStarted_Precar4
            if drv_table.Road_num(i) == 5
                drv_table.distance_P(i) = Precar4.S(i - T0_Precar4) - (-drv_table.Y(i)-686.5);
                drv_table.Speed_P(i) = Precar4_Speed(2);
            elseif drv_table.Road_num(i) == 6
                drv_table.distance_P(i) = Precar4.S(i - T0_Precar4) - (315.3 + drv_table.X(i) - 1.8);
                drv_table.Speed_P(i) = Precar4_Speed(3);
            elseif drv_table.Road_num(i) == 7
                isStarted_Precar4 = false;
            end
        end
    end

    clearvars i isStarted_Precar1 T0_Precar1 isStarted_Precar2 T0_Precar2 isStarted_Precar3 T0_Precar3 isStarted_Precar4 T0_Precar4


    writetable(drv_table, "./01_drv_table/" + extractAfter(input_dir, '00_drivingdata\') + "/" + output_file_name)
    disp("writetable drv_table to output csv file")
    disp(" ------ Finished  " + num + " / "+ file_num + "---------")

    % %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % % figure
    % % gscatter(drv_table.Speed, drv_table.Accel, drv_table.Road_num)
    % % 
    % % figure
    % % gscatter(drv_table.Speed, drv_table.Thr, drv_table.Road_num)

    clearvars -except map_data input_file_names file_num num input_dir map_input Course_Number Precar1_input Precar1_Speed Precar1_trigger Precar2_input Precar2_Speed Precar2_trigger Precar3_input Precar3_Speed Precar3_trigger Precar4_input Precar4_Speed Precar4_trigger TimeLists
end

%writetable(TimeLists,"./01_drv_table/UE1/UE1_TimeList.csv")

% clearvars num input_dir map_input Course_Number map_data input_file_names file_num

disp(" ----------- All Files Finished  ----------- ")