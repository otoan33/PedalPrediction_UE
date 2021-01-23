%% clc;
clear;
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ dir_names , dir_num ]= dir_FileNames("03_pedal_predictor/combined*"); % exclude dir "." , ".."

disp("File Number = " + dir_num)
disp(" ---------- Start Prediction ---------- ")

%% test %%%%%%%%%%%%%%%%%%%%%

isTest = false;

%% for debug %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j_num = 4;
if isTest == true
    dir_num = 1;
    j_num = 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d=[1000,500,200,100];

Cof = cell(1,4);
for j = 1:4
    Cof{1,j} = zeros(dir_num,9);
end

for num = 1  : dir_num
    if ~dir_FileExist("./03_pedal_predictor/" + dir_names(num), "predictor.mat")
        disp(dir_names(num) + " has no predictor.mat")
        continue
    end

    load("./03_pedal_predictor/" + dir_names(num) + "/predictor.mat");
    % Cof.Properties.RowNames = Action_Classifier{1,1}.GeneralizedLinearModel.Coefficients.Properties.RowNames;

    for j = 1:4
        Cof{1,j}(num,:) = Action_Classifier{1,j}.GeneralizedLinearModel.Coefficients{:,"Estimate"};
        %Cof{1,j}.Properties.VariableNames(num) = "D_"+num;
    end

    clearvars -except dir_names dir_num j_num isTest d Cof
end


load("./03_pedal_predictor/" + dir_names(1) + "/predictor.mat");
for j = 1:4
    varNames = Action_Classifier{1,j}.GeneralizedLinearModel.Coefficients.Properties.RowNames;
    varNames{1,1} = 'Intercept';
    Cof{1,j} = array2table(Cof{1,j});
    Cof{1,j}.Properties.VariableNames = varNames;
end
clearvars -except dir_names dir_num j_num isTest d Cof

%% clear num input_file_names file_num 
disp(" ----------- All Files Finished  ----------- ")