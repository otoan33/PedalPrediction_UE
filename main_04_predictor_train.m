%% clc;
clear;
close all;

addpath("tools","function")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ input_file_names , file_num ]= dir_FileNames("03_drv_table_combined_classified/UE1/*.csv");

disp("File Number = " + file_num)


%Input_list = ["Thr"	"Speed"	"Accel"	"Bk_Stat"	"traffic"	"distance"	"v_dif"];
%Input_list = ["Thr","Speed","Accel","Thr_dif_pre_1000","Thr_dif_pre_500","Thr_dif_pre_200","distance_C"];
Input_list = ["Time"	"Road_num"	"Include"	"Station"	"Thr"	"Steer_SW"	"Speed"	"Accel"	"Bk_Stat"	"X"	"Y"	"Thr_dif_pre_1000"	"Thr_dif_pre_500"	"Thr_dif_pre_200"	"Thr_dif_pre_100"	"Thr_dif_future_1000"	"Thr_dif_future_500"	"Thr_dif_future_200"	"Thr_dif_future_100"	"distance_C"	"RoadType"	"ExistPrecar"	"ExistO1"	"ExistO2"	"Speed_lim"	"Speed_O1"	"Speed_O2"	"distance_P"	"Speed_P"	"state"	"Stay_1000"	"Action_1000"	"Stay_500"	"Action_500"	"Stay_200"	"Action_200"	"Stay_100"	"Action_100"	"va"	"v2"	"vthr"	"difvlim"	"difvp"	"v2dc"	"v2dp"	"distance"	"difv"	"Change_1000"	"Change_500"	"Change_200"	"Change_100"];
lavel_0 = readtable('./function/lavel_0.csv');
lavel_a = readtable('./function/lavel_a.csv');
lavel_r = readtable('./function/lavel_r.csv');

%Target_list_0 = ["Stay_1000","Action_1000","Stay_500","Action_500","Stay_200","Action_200","Stay_100","Action_100"];
Target_list_0 = ["Change_1000","Change_500","Change_200","Change_100"];
Target_list_ar = ["Thr_dif_future_1000","Thr_dif_future_500","Thr_dif_future_200","Thr_dif_future_100"];


disp(" ---------- Start Processing Data ---------- ")
for condition = 1:9
    Input_list = ["Time"	"Road_num"	"Include"	"Station"	"Thr"	"Steer_SW"	"Speed"	"Accel"	"Bk_Stat"	"X"	"Y"	"Thr_dif_pre_1000"	"Thr_dif_pre_500"	"Thr_dif_pre_200"	"Thr_dif_pre_100"	"Thr_dif_future_1000"	"Thr_dif_future_500"	"Thr_dif_future_200"	"Thr_dif_future_100"	"distance_C"	"RoadType"	"ExistPrecar"	"ExistO1"	"ExistO2"	"Speed_lim"	"Speed_O1"	"Speed_O2"	"distance_P"	"Speed_P"	"state"	"Stay_1000"	"Action_1000"	"Stay_500"	"Action_500"	"Stay_200"	"Action_200"	"Stay_100"	"Action_100"	"va"	"v2"	"vthr"	"difvlim"	"difvp"	"v2dc"	"v2dp"	"distance"	"difv"	"Change_1000"	"Change_500"	"Change_200"	"Change_100"];


    Target_list_0 = ["Change_1000","Change_500","Change_200","Change_100"];
    Target_list_ar = ["Thr_dif_future_1000","Thr_dif_future_500","Thr_dif_future_200","Thr_dif_future_100"];

    B = cell(1,file_num);
    dev = cell(1,file_num);
    stats = cell(1,file_num);
    mdl_a = cell(1,file_num);
    mdl_r = cell(1,file_num);
    Error = cell(1,file_num);
    rsme_a = cell(1,file_num);
    rsme_r = cell(1,file_num);
    Error_test = cell(1,file_num);
    rsme_a_test = cell(1,file_num);
    rsme_r_test = cell(1,file_num);


    num_end = 8;
    i_end = 3;
    j_end = 4;


    disp("%%%%%%%%%%%%%%%%%%%%% Condition : " +condition +" %%%%%%%%%%%%%%%%%")
    for num = 1  : num_end
        B{1,num} = cell(3,4);
        dev{1,num} = cell(3,4);
        stats{1,num} = cell(3,4);
        mdl_a{1,num} = cell(3,4);
        mdl_r{1,num} = cell(3,4);
        Error{1,num} = zeros(3,4);
        rsme_a{1,num} = zeros(3,4);
        rsme_r{1,num} = zeros(3,4);
        Error_test{1,num} = zeros(3,4);
        rsme_a_test{1,num} = zeros(3,4);
        rsme_r_test{1,num} = zeros(3,4);

        input_file_name = input_file_names(num);
        output_dir_name = extractBetween(input_file_name, "classified_",".csv");

        %% import drv_table timestep:0.05 ms and Decide Driving State for each timestep
        disp("read " + input_file_name)

        drv_data_classified = readtable("./03_drv_table_combined_classified/UE1/" + input_file_name);
        drv_data_classified = drv_data_classified(drv_data_classified.Include==1,:);


        drv_data_classified.va = drv_data_classified.Speed.*drv_data_classified.Accel;
        drv_data_classified.v2 = drv_data_classified.Speed.*drv_data_classified.Speed;
        drv_data_classified.vthr = drv_data_classified.Speed.*drv_data_classified.Thr;
        drv_data_classified.difvlim = drv_data_classified.Speed_lim - drv_data_classified.Speed;
        drv_data_classified.difvp = ( drv_data_classified.Speed_P - drv_data_classified.Speed ).*drv_data_classified.ExistPrecar;
        drv_data_classified.v2dc = drv_data_classified.v2./ max(drv_data_classified.distance_C,1);
        drv_data_classified.v2dp = drv_data_classified.v2./ max(drv_data_classified.distance_P,1);

        drv_data_classified.distance = drv_data_classified.distance_P.*drv_data_classified.ExistPrecar + drv_data_classified.distance_C.*( 1 - drv_data_classified.ExistPrecar);
        drv_data_classified.difv = drv_data_classified.difvp.*drv_data_classified.ExistPrecar + drv_data_classified.difvlim.*( 1 - drv_data_classified.ExistPrecar);

        drv_data_classified.Change_1000 = 2 * drv_data_classified.Stay_1000 + drv_data_classified.Action_1000;
        drv_data_classified.Change_500 = 2 * drv_data_classified.Stay_500 + drv_data_classified.Action_500;
        drv_data_classified.Change_200 = 2 * drv_data_classified.Stay_200 + drv_data_classified.Action_200;
        drv_data_classified.Change_100 = 2 * drv_data_classified.Stay_100 + drv_data_classified.Action_100;


        drv_data_test = readtable("./03_drv_table_combined_classified/UE2/" + input_file_name);
        drv_data_test = drv_data_test(drv_data_test.Include==1,:);


        drv_data_test.va = drv_data_test.Speed.*drv_data_test.Accel;
        drv_data_test.v2 = drv_data_test.Speed.*drv_data_test.Speed;
        drv_data_test.vthr = drv_data_test.Speed.*drv_data_test.Thr;
        drv_data_test.difvlim = drv_data_test.Speed_lim - drv_data_test.Speed;
        drv_data_test.difvp = drv_data_test.Speed_P - drv_data_test.Speed;
        drv_data_test.v2dc = drv_data_test.v2./ max(drv_data_test.distance_C,1);
        drv_data_test.v2dp = drv_data_test.v2./ max(drv_data_test.distance_P,1);

        drv_data_test.distance = drv_data_test.distance_P.*drv_data_test.ExistPrecar + drv_data_test.distance_C.*( 1 - drv_data_test.ExistPrecar);
        drv_data_test.difv = drv_data_test.difvp.*drv_data_test.ExistPrecar + drv_data_test.difvlim.*( 1 - drv_data_test.ExistPrecar);


        drv_data_test.Change_1000 = 2 * drv_data_test.Stay_1000 + drv_data_test.Action_1000;
        drv_data_test.Change_500 = 2 * drv_data_test.Stay_500 + drv_data_test.Action_500;
        drv_data_test.Change_200 = 2 * drv_data_test.Stay_200 + drv_data_test.Action_200;
        drv_data_test.Change_100 = 2 * drv_data_test.Stay_100 + drv_data_test.Action_100;

        drv_states = ["Accelerate","Cruise","Braking","Stop"];
        
        for i = 1:i_end
            drv_data_train = drv_data_classified(drv_data_classified.state == drv_states(i),:);
            drv_data_test_state = drv_data_test(drv_data_test.state == drv_states(i),:);

            %%% Set parameter list %%%%%%%%%%%%

            Input_param_0 = Input_list(lavel_0{condition,:}==1);
            Input_param_a = Input_list(lavel_a{i,:}==1);
            Input_param_r = Input_list(lavel_r{i,:}==1);

            len_param_0 = length(Input_param_0);
            len_param_a = length(Input_param_a);
            len_param_r = length(Input_param_r);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            % [Action_Classifier, Action_Accuracy] = trainClassifier(drv_data_train, predictorNames, Target_list_0(j));

            for j = 1:j_end
                
                predictor_0 = drv_data_train{:,Input_param_0};
                target = categorical(drv_data_train{:, Target_list_0(j)});

                predictor_0_test = drv_data_test_state{:,Input_param_0};
                target_test = categorical(drv_data_test_state{:, Target_list_0(j)});

                %% Train Classifier %%

                [B{1,num}{i,j}, dev{1,num}{i,j}, stats{1,num}{i,j}] = mnrfit(predictor_0,target);

                pihat = mnrval(B{1,num}{i,j},predictor_0);
                Error{1,num}(i,j) = MULTICrossEntropyError(pihat, target);

                %% test %%
                pihat_test = mnrval(B{1,num}{i,j},predictor_0_test);
                Error_test{1,num}(i,j) = MULTICrossEntropyError(pihat_test, target_test);

                % Z1= B{1,num}{i,j}(1,1) + predictor_0 * B{1,1}{i,j}(2:len_param_0+1,1);
                % Z2= B{1,num}{i,j}(1,1) + predictor_0 * B{1,1}{i,j}(2:len_param_0+1,2);
                % figure
                % plot_logistic_regression(Z1, pihat(:,1), target=="0", 50, "Driver : " + num + " , State : " + drv_states(i) + " , Target : " + Target_list_0(j), height(drv_data_train), Error{1,num}(i,j))
                % figure
                % plot_logistic_regression(Z2, pihat(:,2), target=="1", 50, "Driver : " + num + " , State : " + drv_states(i) + " , Target : " + Target_list_0(j), height(drv_data_train), Error{1,num}(i,j))
                
                %% Train Lenear Model %%

                drv_data_train_a = drv_data_train(drv_data_train{:,Target_list_0(j)}==1,:);
                drv_data_train_r = drv_data_train(drv_data_train{:,Target_list_0(j)}==0,:);
                predictor_a = drv_data_train_a{:,Input_param_a};
                predictor_r = drv_data_train_r{:,Input_param_r};
                
                mdl_a{1,num}{i,j} = fitlm(predictor_a, drv_data_train_a{:, Target_list_ar(j)});
                mdl_r{1,num}{i,j} = fitlm(predictor_r, drv_data_train_r{:, Target_list_ar(j)});

                pred_a = predict(mdl_a{1,num}{i,j},predictor_a);
                pred_r = predict(mdl_r{1,num}{i,j},predictor_r);

                rsme_a{1,num}(i,j) = RMSE(pred_a, drv_data_train_a{:, Target_list_ar(j)});
                rsme_r{1,num}(i,j) = RMSE(pred_r, drv_data_train_r{:, Target_list_ar(j)});


                %% test %%
                drv_data_test_state_a = drv_data_test_state(drv_data_test_state{:,Target_list_0(j)}==1,:);
                drv_data_test_state_r = drv_data_test_state(drv_data_test_state{:,Target_list_0(j)}==0,:);
                predictor_a_test = drv_data_test_state_a{:,Input_param_a};
                predictor_r_test = drv_data_test_state_r{:,Input_param_r};

                pred_a_test = predict(mdl_a{1,num}{i,j},predictor_a_test);
                pred_r_test = predict(mdl_r{1,num}{i,j},predictor_r_test);

                rsme_a_test{1,num}(i,j) = RMSE(pred_a_test, drv_data_test_state_a{:, Target_list_ar(j)});
                rsme_r_test{1,num}(i,j) = RMSE(pred_r_test, drv_data_test_state_r{:, Target_list_ar(j)});
            
                % figure
                % plot_multiple_regression(pred_a, drv_data_train_a{:, Target_list_ar(j)}, "Driver : " + num + " , State : " + drv_states(i) + " , Target : " + Target_list_ar(j), height(drv_data_train_a), rsme_a{1,num}(i,j))
                % figure
                % plot_multiple_regression(pred_r, drv_data_train_r{:, Target_list_ar(j)}, "Driver : " + num + " , State : " + drv_states(i) + " , Target : " + Target_list_ar(j), height(drv_data_train_r), rsme_r{1,num}(i,j))
                disp("Driver : " + num + " , State : " + drv_states(i) + " , Target : " + Target_list_0(j))

            end

        end

    end


    disp(" ----------- All Files Finished  ----------- ")
    % for num = 1  : num_end
    %     for i = 1 : i_end
    %         for j = 1 : j_end
    %             a = find(stats{1,num}{i,j}.p(:,1)>0.05 |stats{1,num}{i,j}.p(:,2)>0.05);
    %             disp(a.')
    %         end
    %     end
    % end

    a = readtable("Error.xlsx");
    for num = 1  : num_end
        row_num=height(a)+1;
        disp(reshape(Error{1,num},1,12))
        disp(reshape(rsme_a{1,num},1,12))
        disp(reshape(rsme_r{1,num},1,12))
        a{row_num,:}=[num, 0, reshape(Error{1,num},1,12), reshape(rsme_a{1,num},1,12),reshape(rsme_r{1,num},1,12), lavel_0{condition,[12, 13, 14,15,22,23,24,5,7,8,9,46,47]}];
        a{row_num+1,:}=[num, 1, reshape(Error_test{1,num},1,12), reshape(rsme_a_test{1,num},1,12),reshape(rsme_r_test{1,num},1,12), lavel_0{condition,[12, 13, 14,15,22,23,24,5,7,8,9,46,47]}];
    end
    writetable(a,"Error.xlsx");

    clearvars -except B dev stats mdl_a mdl_r Error rsme_a rsme_r Error_test rsme_a_test rsme_r_test lavel_0 lavel_a lavel_r condition input_file_names file_num

    filename = "./04_pedal_predictor/predictor_d40_v3_dthr_00"+string(condition)+".mat"

    save(filename)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function plot_logistic_regression(pred_z, pred_prob, exp_value, quantile_num, title_string, num, err)
    z_quantile = quantile(pred_z, quantile_num-1);

    rate_z=zeros(1, quantile_num);
    for k = 1: quantile_num
        if k==1
            z_tmp = pred_z( pred_z < z_quantile(1));
            value_tmp = exp_value( pred_z < z_quantile(1));
        elseif k == quantile_num
            z_tmp = pred_z( pred_z > z_quantile(quantile_num-1));
            value_tmp = exp_value( pred_z > z_quantile(quantile_num-1));
        else
            z_tmp = pred_z( pred_z > z_quantile(k-1) & pred_z < z_quantile(k));
            value_tmp = exp_value( pred_z > z_quantile(k-1) & pred_z < z_quantile(k));
        end
        z(k) = mean(z_tmp);
        rate_z(k)=sum(value_tmp)/length(value_tmp);
    end
    hold on
    %title({ drv_states(i) + ', ' + d(j) + ' ms'},'FontSize',15)  % result of Logistic regression
    p1=scatter(pred_z, pred_prob, 5,'MarkerEdgeColor','#D95319','MarkerFaceColor','#D95319');
    p3=plot(z,rate_z,'-o','Color',	'#77AC30','LineWidth',1,'MarkerSize',3,'MarkerEdgeColor','#77AC30','MarkerFaceColor','#77AC30');
    %p2=scatter(pred_z, exp_value, 5,'MarkerEdgeColor','#0072BD','MarkerFaceColor','#0072BD');
    hold off
    legend([p1 p3 ],{ 'Model Probability','Actual Probability'},'FontSize',10,'Location','southeast')
    % xticks([-5:1:5])
    % xlim([-5 5])
    box on
    xlabel('z [-]','FontSize',15)
    title(title_string,'FontSize',15)
    text(1,0.3,{"Data : "+num+" points";"CE Error = "+err;},'FontSize',10)
end

function plot_multiple_regression(pred, exp_value, title_string, num, err)
    hold on
    scatter(exp_value, pred, 5,'MarkerEdgeColor','#D95319','MarkerFaceColor','#D95319');
    fplot(@(x) x,'-')
    hold off

    xlim([-0.4 0.4])
    ylim([-0.4 0.4])
    % xticks([-0.4 :0.1: 0.4])
    % yticks([-0.4 :0.1: 0.4])
    box on
    axis equal
    xlabel('Experiment','FontSize',15)
    ylabel('Prediction','FontSize',15)
    title(title_string,'FontSize',15)
    text(0,-0.35,{"Data : "+num+" points";"RMSE = "+err;},'FontSize',10)
end