//  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  Instruction for driving data analysis code
//  2020.12.08
//  written by Naoto Fukuda
//  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Source_Code
    main_01_a_process_data.m

Abstruct
    process experimental data into proper format as model input
    - set lap number
    - set road number
    - set include yes/no
    - set velocity limit from road number
    - caluculate distance to road boundary point / next turn
    - caluculate distance to preceding car
    - set traffic yes/no
    - caluculate throttle difference from next/pre timestep

Input_Data
    driving_data = "./00_drivingdata/0921_1/2020-**-**.**.**_data_output.csv"
    map_data = "./map_data/xy_data_20200629.xlsx"

Output_Data
    output_file_name = "./01_drv_table/drv_table_**-**.**.**.csv"
    drv_table : type = Table
        =
        { // row info
            timestep = 0.05 s, duration = 0 s ~ 500 s
        }
        { // var info
            'Time'
            'Lap'
            'Road_num'
            'Include'// {0, 1}
            'Station'
            'Thr'
            'Steer_SW'
            'Speed'
            'Accel'
            'Bk_Stat' // {0, 1}
            'Speed_lim'
            'distance_C' // distance to next intersection, curve, etc.
            'distance_P'
            'Speed_P'
            'traffic'// {0, 1}
            'Thr_dif_1000' // Amount of Throttle change in next 1000 ms. 
            'Thr_dif_pre_1000' // Amount of Throttle change in previous 1000 ms. 
            'Thr_dif_500'
            'Thr_dif_pre_500'
            'Thr_dif_200'
            'Thr_dif_pre_200'
            'Thr_dif_100'
            'Thr_dif_pre_100'
        }

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Source_Code
    main_01_b_combine_drv_table.m

Abstruct
    combine drv_tables of 2 maps into 1 drv_table.
    caluculate distance : the smaller in distance_C and distance_P
    caluculate velocity difference : the smaller in the v_lim and v_dif_pre

Input_Data
    driving_data = "./00_drivingdata/0921_1/2020-**-**.**.**_data_output.csv"
    map_data = "./map_data/xy_data_20200629.xlsx"

Output_Data
    output_file_name = "./01_drv_table_combined/drv_table_combined_00*.csv";

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Source_Code
    main_02_a_classify_drv_state.m

Abstruct
    classify driving state by using function/classify_drv_state.m
    
Input_Data
    driving_data = "./01_drv_table/*.csv"
                    / "./01_drv_table_combined/*.csv"

Output_Data
    output_file_name = "./02_drv_table_classified/classified_*.csv"
                    /"./02_drv_table_combined/classified_*.csv"
    ADD variables to drv_data
    {    
        'state'     // {"Accelerate", "Cruise", "Decelerate", "Braking", "Stop"}
    }

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Source_Code
    main_03_predictor_train.m

Abstruct
    extract drv_data with interval ( 1000 ms, 500 ms, 200 ms, 100 ms )
    set "action" ,"release"


Input_Data
    drv_data_classified = "./02_drv_table_combined/classified_*.csv"
    drv_states = ["Accelerate","Cruise","Decelerate","Braking","Stop"]

Processing_Data
    drv_data = { drv_data_1000ms, drv_data_0500ms, drv_data_0200ms, drv_data_0100ms, drv_data_org }
        // extract every 1000 ms, 500 ms, 200 ms, 100 ms drv_data from drv_data_org
    
    ADD variables to drv_data
    {   
        'action'    // next pedal action is zero(0), action(1)
        'release'   // next pedal action is release(0), or other(1)
    }

    lavel : int(5 × 8)  = select parameters used in "action" prediction

// [I] TRAINIG LOGISTIC REGRESSION MODEL TO PREDICT ACTION / NO ACTION AT NEXT TIMESTEP

    training_data : cell(5,5) = extract training_data from "drv_data" according to "lavel" 
        // (i,j) {i : State, j : timestep}
        
    Action_Classifier : cell(5,5) = "action" classifier
    Action_Accuracy : cell(5,5) = classisication accuracy
        // (i,j) {i : State, j : timestep}
    pred_training_action : cell(5,5) = probability of action  x : training_data
    pred_training_action_z : cell(5,5) = output of trained linear function  x : training_data 
        // pred_trainingdata = exp(pred_trainingdata_z) / (1 + exp(pred_trainingdata_z)) as sigmoid function

// [II] TRAINING LOGISTIC REGRESSION MODEL TO PREDICT RELEASE / OTHER ACTION AT NEXT TIMESTEP IN CRUISE MODE

    training_data_release : cell(1,5) = extract "Cruise" and "action == 0" data from "training_data" 
    // (i,j) {i : "Cruise Mode", j : timestep}

    Release_Classifier : cell(1,5) = "action" classifier
    Release_Accuracy : cell(1,5) = classisication accuracy
    // (i,j) {i : State, j : timestep}
    pred_training_release : cell(1,5) = probability of release  x : training_data_release
    pred_training_release_z : cell(1,5) = output of trained linear function  x : training_data_release 
    // pred_trainingdata = exp(pred_trainingdata_z) / (1 + exp(pred_trainingdata_z)) as sigmoid function

// [III] TRAINING MULTIPLE REGRESSION MODEL TO AMOUNT OF ACTION AT NEXT TIMESTEP

    training_data_amount : cell(5,5) = extract "action == 1" and "release = 0" data from "training_data"

    Amount_Regression = cell(5,5);
    validationRMSE = cell(5,5);
    pred_training_amount = cell(5,5);


Output_Data
    dir = "./pedal_predictor/**-**.**.**/"
    file_name = "predictor.mat"
    
    {
        "lavel",
        "lavel_2",
        "drv_data", 
        "training_data", 
        "training_data_release",
        "training_data_amount",
        "Action_Classifier", 
        "Action_Accuracy", 
        "pred_training_action", 
        "pred_training_action_z",   
        "Release_Classifier", 
        "Release_Accuracy", 
        "pred_training_release",
        "pred_training_release_z",
        "Amount_Regression", 
        "validationRMSE", 
        "pred_training_amount",
        "rowNames",
        "varNames",
        "drv_states","d"
    }

    
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sourse_Code
    pedal_predict_04.m

Input_Data
    load('./pedal_predictor/06-28_22.31.55/predictor.mat');
    test_table = readtable("./pred_input/drv_table_test.csv");

Processing_Data
    // for j = 1:5
    //     idx = num2str(d(j));
    //     test_table{:,join(['Action_', idx])} = zeros(height(test_table),1);
    //     test_table{:,join(['Release_', idx])} = zeros(height(test_table),1);
    //     test_table{:,join(['P0_', idx])} = zeros(height(test_table),1);
    //     test_table{:,join(['Pr_', idx])} = zeros(height(test_table),1);
    //     test_table{:,join(['Pa_', idx])} = zeros(height(test_table),1);
    //     test_table{:,join(['Amount_', idx])} = zeros(height(test_table),1);
        "training_data" : cell(1,4)
        "test_data": cell(1,4)
        "drv_data": cell(1,4)
    