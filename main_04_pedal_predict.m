%% clc;
clear;
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ dir_names , dir_num ]= dir_FileNames("03_pedal_predictor/combined*"); % exclude dir "." , ".."

disp("File Number = " + dir_num)
disp(" ---------- Start Prediction ---------- ")

for num = 1 : dir_num
    if ~dir_FileExist("./03_pedal_predictor/" + dir_names(num), "predictor.mat")
        disp(dir_names(num) + " has no predictor.mat")
        continue
    end

    load("./03_pedal_predictor/" + dir_names(num) + "/predictor.mat");

    d = [1000 500 200 100];

    err_training = cell(1,4);
    err_test = cell(1,4);
    err_all = cell(1,4);
    num_training = cell(1,4);
    num_test = cell(1,4);
    num_all = cell(1,4);

    for j = 1:4
        idx = join(['Thr_dif_', num2str(d(j))]);
        [ training_data{1,j}, err_training{1,j} , num_training{1,j} ] = predict_pedal( training_data{1,j}, Action_Classifier(:,j), Release_Classifier(:,j), Amount_Regression(:,j), idx );
        [ test_data{1,j}, err_test{1,j}, num_test{1,j} ] = predict_pedal( test_data{1,j}, Action_Classifier(:,j), Release_Classifier(:,j), Amount_Regression(:,j), idx );
        [ drv_data{1,j}, err_all{1,j}, num_all{1,j} ] = predict_pedal( drv_data{1,j}, Action_Classifier(:,j), Release_Classifier(:,j), Amount_Regression(:,j), idx );
        disp(num+","+j)
    end

    save("./03_pedal_predictor/" + dir_names(num) + "/predict_result.mat",...
    "training_data","test_data","drv_data", "err_training", "err_test", "err_all", "num_training", "num_test", "num_all");

    clearvars j i idx input_table input_Action input_Release input_Amount row predictor_Action predictor_Amount predictor_Release

    clearvars -except num  dir_names dir_num

    disp(" ------ Finished  " + num + " / "+ dir_num + "---------")

end

clear num  dir_names dir_num

disp(" ----------- All Files Finished  ----------- ")

function [output_data, modelError, dataNum] = predict_pedal(input_data, Action_Classifier, Release_Classifier, Amount_Regression, idx)
    drv_states = ["Accelerate", "Cruise", "Braking", "Stop"];

    input_data{:,'pred_action'} = NaN(height(input_data),1);
    input_data{:,'pred_action_z'} = NaN(height(input_data),1);
    input_data{:,'pred_release'} = NaN(height(input_data),1);
    input_data{:,'pred_release_z'} = NaN(height(input_data),1);
    input_data{:,'pred_amount'} = NaN(height(input_data),1);

    modelError = zeros(3,3);
    dataNum = zeros(2,3);

    for i = 1:2
        %% Action Prediction
        row_action = find(input_data.state == drv_states(i));
        input_data_action = input_data(row_action,:);
        
        pred_action = Action_Classifier{i,1}.predict_prob(input_data_action);
        pred_action_z = zeros(length(pred_action),1);
        for k = 1 : length(pred_action)
            pred_action_z(k) = pred_action(k)/(1 - pred_action(k));
        end
        pred_action_z = log(pred_action_z);

        %% Release Prediction
        row_release = row_action(find(input_data_action.action==1));
        input_data_release = input_data_action(input_data_action.action==1,:);

        pred_release = Release_Classifier{i,1}.predict_prob(input_data_release);
        pred_release_z = zeros(length(pred_release),1);
        for k = 1 : length(pred_release)
            pred_release_z(k) = pred_release(k)/(1 - pred_release(k));
        end
        pred_release_z = log(pred_release_z);

        %% Amount Prediction
        row_amount = row_release(input_data_release.release==0);
        input_data_amount = input_data_release(input_data_release.release==0, :);

        pred_amount = Amount_Regression{i,1}.predictFcn(input_data_amount);

        input_data{row_action,'pred_action'} = pred_action;
        input_data{row_action,'pred_action_z'} = pred_action_z;
        input_data{row_release,'pred_release'} = pred_release;
        input_data{row_release,'pred_release_z'} = pred_release_z;
        input_data{row_amount,'pred_amount'} = pred_amount;
        % disp([pred_amount, input_data_amount{:,idx}])
        
        modelError(i,1) = CrossEntropyError(pred_action, input_data_action.action);
        modelError(i,2) = CrossEntropyError(pred_release, input_data_release.release);
        modelError(i,3) = RMSE(pred_amount, input_data_amount{:,idx});

        dataNum(i,1) = height(input_data_action);
        dataNum(i,2) = height(input_data_release);
        dataNum(i,3) = height(input_data_amount);
    end


    modelError(3,1) = ( modelError(1,1) * dataNum(1,1) + modelError(2,1) * dataNum(2,1) ) / ( dataNum(1,1) + dataNum(2,1) );
    modelError(3,2) = ( modelError(1,2) * dataNum(1,2) + modelError(2,2) * dataNum(2,2) ) / ( dataNum(1,2) + dataNum(2,2) );
    modelError(3,3) = sqrt(( modelError(1,3)^2 * dataNum(1,3) + modelError(2,3)^2 * dataNum(2,3) ) / ( dataNum(1,3) + dataNum(2,3) ));

    output_data = input_data;
end