%% clc;
clear;
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isUsingCombinedTable = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (isUsingCombinedTable == 0)
    [ input_file_names , file_num ]= dir_FileNames("02_drv_table_classified/*.csv");
else
    [ input_file_names , file_num ]= dir_FileNames("02_drv_table_combined/*.mat");
end

disp("File Number = " + file_num)

%% Create output directory
if ~dir_FileExist("./", "03_pedal_predictor")
    mkdir("03_pedal_predictor");
end


disp(" ---------- Start Processing Data ---------- ")

for num = 1  : file_num

    input_file_name = input_file_names(num);
    output_dir_name = extractBetween(input_file_name, "classified_cell_",".mat");

    %% import drv_table timestep:0.05 ms and Decide Driving State for each timestep
    disp("read " + input_file_name)
    if (isUsingCombinedTable == 0)
        drv_data_classified = readtable("./02_drv_table_classified/" + input_file_name);
    else
        % drv_data_classified = readtable("./02_drv_table_combined/" + input_file_name);
        load("./02_drv_table_combined/" + input_file_name)
    end

    drv_states = ["Accelerate","Cruise","Braking","Stop"];


    %% 
    training_data = cell(1,4);
    test_data = cell(1,4);
    for i = 1:4
        [trainInd,valInd,testInd] = dividerand(height(drv_data{1,i}),0.8,0.0,0.2);
        training_data{1,i} = drv_data{1,i}(trainInd,:);
        test_data{1,i} = drv_data{1,i}(testInd,:);
    end

    %% 1: prediction of action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% Set the variables used in the logistic regression for each driving state
    disp("Set New Var : lavel")
    varNames = drv_data{1,1}.Properties.VariableNames;
    rowNames = {'Accelerate','Cruise','Braking','Stop'};

    lavel = readtable('./function/lavel.csv');
    lavel = lavel(:,2:8);
    lavel.Properties.RowNames = rowNames;
    index=[6 8 9 10 15 24 27];

    %% Create Training_data for logistic regression
    training_data_action = cell(2,4);  %% (i,j) {i : State, j : timestep}
    d = [1000 500 200 100];
    for i = 1:2
        for j = 1:4
            idx = join(['Thr_dif_', num2str(d(j))]);
            idx_pre = join(['Thr_dif_pre_', num2str(d(j))]);
            select_idx = [index(find([lavel{drv_states(i),:}])),find(strncmp(varNames,idx_pre,19)),find(strncmp(varNames,'action',6)),find(strncmp(varNames,'release',7)),find(strncmp(varNames,idx,15))];
            % split each timestep drv_data into each drv_state
            training_data_action{i,j} = training_data{1,j}(training_data{1,j}.state==drv_states(i),select_idx);
        end
    end

    clearvars i j idx select_idx
    disp("Create Training_data")

    %% Train "action" predict model by logistic regression
    Action_Classifier = cell(2,4);  %% (i,j) {i : State, j : timestep}
    Action_Accuracy = cell(2,4);
    pred_training_action = cell(2,4);  %% variable for plot
    pred_training_action_z = cell(2,4); %% variable for plot

    for i = 1:2
        for j = 1:4
            predictorNames = [varNames(index(find([lavel{drv_states(i),:}]))),join(['Thr_dif_pre_', num2str(d(j))]) ];
            [Action_Classifier{i,j}, Action_Accuracy{i,j}] = trainClassifier(training_data_action{i,j},predictorNames,"action");
            % pred_training_action{i,j} = Action_Classifier{i,j}.predict_prob(training_data_action{i,j});

            % pred_training_action_z{i,j} = zeros(1,length(pred_training_action{i,j}));
            % for k = 1 : length(pred_training_action{i,j})
            %     pred_training_action_z{i,j}(k) = pred_training_action{i,j}(k)/(1 - pred_training_action{i,j}(k));
            % end
            % pred_training_action_z{i,j} = log(pred_training_action_z{i,j});
            disp(i+","+j)
        end
    end

    clearvars i j k


    %% 2: prediction of release %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %% Train "release" predict model by logistic regression
    Release_Classifier =cell(2,4);  %% (i,j) {i : State, j : timestep}
    Release_Accuracy = cell(2,4);
    pred_training_release = cell(2,4);
    pred_training_release_z = cell(2,4);

    training_data_release = cell(2,4);
    for i = 1:2
        for j = 1:4
            training_data_release{i,j} = training_data_action{i,j}(training_data_action{i,j}.action==1,:);
        end
    end


    for i = 1:2
        for j = 1:4
            predictorNames = [varNames(index(find([lavel{drv_states(i),:}]))),join(['Thr_dif_pre_', num2str(d(j))]) ];
            [Release_Classifier{i,j}, Release_Accuracy{i,j}] = trainClassifier(training_data_release{i,j},predictorNames,"release");
            % pred_training_release{i,j} = Release_Classifier{i,j}.predict_prob(training_data_release{i,j});

            % pred_training_release_z{i,j} = zeros(1,length(pred_training_release{i,j}));
            % for k = 1 : length(pred_training_release{i,j})
            %     pred_training_release_z{i,j}(k) = pred_training_release{i,j}(k)/(1 - pred_training_release{i,j}(k));
            % end
            % pred_training_release_z{i,j} = log(pred_training_release_z{i,j});
            disp(i+","+j)
        end
    end

    clearvars i j k predictorNames


    %% 3: prediction of amount %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %% Train "Amount" predict model by multiple regression

    % lavel_2 = readtable('./function/lavel_multiple.csv');
    % lavel_2 = lavel_2(:,2:9);
    % lavel_2.Properties.RowNames = rowNames;

    lavel_2 = lavel;

    training_data_amount = cell(2,4);

    for i = 1:2
        for j = 1:4
            % idx = join(['Thr_dif_', num2str(d(j))]);
            % select_idx = [find([lavel_2{drv_states(i),:}]), find(strncmp(varNames,idx,15))];
            % % split each timestep drv_data into each drv_state
            % select_rows = drv_data{1,j}.state==drv_states(i) & drv_data{1,j}.action==1 & drv_data{1,j}.release==0;
            % training_data_amount{i,j} = drv_data{1,j}(select_rows,select_idx);
            training_data_amount{i,j} = training_data_release{i,j}(training_data_release{i,j}.release==0, :);
        end
    end


    Amount_Regression = cell(2,4);
    validationRMSE = cell(2,4);
    pred_training_amount = cell(2,4);

    for i = 1:2
        for j = 1:4
            idx = join(['Thr_dif_', num2str(d(j))]);
            predictorNames = [varNames(index(find([lavel{drv_states(i),:}]))),join(['Thr_dif_pre_', num2str(d(j))]) ];
            [ Amount_Regression{i,j}, validationRMSE{i,j} ] = trainRegressionModel(training_data_amount{i,j},predictorNames,idx);
            % pred_training_amount{i,j} = Amount_Regression{i,j}.predictFcn(training_data_amount{i,j});
            disp(i+","+j)
        end
    end

    clearvars i j idx

    %% Create output files
    if ~dir_FileExist("./03_pedal_predictor", output_dir_name)
        mkdir("./03_pedal_predictor/" + output_dir_name);
    end

    % save("./03_pedal_predictor/" + output_dir_name + "/predictor.mat",...
    %     "lavel", "lavel_2", "drv_data", "training_data", "training_data_release","training_data_amount", ...
    %     "Action_Classifier", "Action_Accuracy", "pred_training_action", "pred_training_action_z",...
    %     "Release_Classifier", "Release_Accuracy", "pred_training_release", "pred_training_release_z",...
    %     "Amount_Regression", "validationRMSE", "pred_training_amount",...
    %     "rowNames","varNames","drv_states","d")

    save("./03_pedal_predictor/" + output_dir_name + "/predictor.mat",...
        "lavel", "drv_data", "training_data","test_data","training_data_action", "training_data_release", "training_data_amount", ...
        "Action_Classifier", "Action_Accuracy", ...
        "Release_Classifier", "Release_Accuracy",...
        "Amount_Regression", "validationRMSE", ...
        "rowNames","varNames","drv_states","d")


    clearvars -except num input_file_names file_num isUsingCombinedTable

    disp(" ------ Finished  " + num + " / "+ file_num + "---------")
end

clear num input_file_names file_num 

disp(" ----------- All Files Finished  ----------- ")