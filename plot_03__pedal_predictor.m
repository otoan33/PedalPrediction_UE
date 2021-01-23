%% Plot drv_table grouping driving_state
close all
addpath("tools","function")

%% Get Window Information
scrsz = get(groot,'ScreenSize');
maxW = scrsz(3);
maxH = scrsz(4);

%% Get File Information

[ input_file_names , file_num ]= dir_FileNames("03_pedal_predictor/combined*");

disp(" ---------- Start Plot Result ---------- ")

drv_states = ["Accelerate", "Cruise", "Braking", "Stop"];
d = [1000, 500, 200, 100];

%% test %%%%%%%%%%%%%%%%%%%%%

isTest = false;
plotAction = false;
plotRelease = false;
plotAmount = true;


%% for debug %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
driver_num = file_num;
timestep_num = 4;
visible='off';
if isTest == true
    driver_num =1;
    timestep_num = 1;
    visible='on';
end

%% action predict %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plotAction == true
    disp("%% Plot Action")
    nnn=0;
    for num = 1:driver_num
        load("./03_pedal_predictor/"+input_file_names(num)+"/predict_result.mat")
        nnn=nnn+1;
        quantile_num = 10;
        
        for j = 1:timestep_num
            h = figure('visible',visible);
            setFigureSize(maxW, maxH, 2.5, 2)
            for i = 1:2
                train_table = training_data{1,j}(training_data{1,j}.state == drv_states(i),:);
                err = err_training{1,j}(i,1);
                subplot(2,3,i)
                plot_logistic_regression(train_table.pred_action_z,train_table.pred_action, train_table.action, quantile_num, "Training Data ( "+drv_states(i)+" )", height(train_table), err)
                if i == 1
                    ylabel('Action Probability [-]','FontSize',15)
                end

                test_table = test_data{1,j}(test_data{1,j}.state == drv_states(i),:);
                err = err_test{1,j}(i,1);
                subplot(2,3,i+3)
                plot_logistic_regression(test_table.pred_action_z, test_table.pred_action, test_table.action, quantile_num, "Test Data ( "+drv_states(i)+" )", height(test_table),err)
                if i == 1
                    ylabel('Action Probability [-]','FontSize',15)
                end
            end
            
            err = err_training{1,j}(3,1);
            subplot(2,3,3)
            plot_logistic_regression(training_data{1,j}.pred_action_z, training_data{1,j}.pred_action, training_data{1,j}.action, quantile_num, "Training Data ( all )", height(training_data{1,j}), err)
            
            err = err_test{1,j}(3,1);
            subplot(2,3,6)
            plot_logistic_regression(test_data{1,j}.pred_action_z, test_data{1,j}.pred_action, test_data{1,j}.action, quantile_num, "Test Data ( all )", height(test_data{1,j}), err)

            sgtitle("Driver : " + nnn + ", Time Width : " + d(j) + " ms",'FontSize',15)
            saveas(gcf,"./23_figure_pedal_predictor/Action/Driver_00" + num + "_" + d(j) + "ms_" + "Action.fig")
            saveas(gcf,"./23_figure_pedal_predictor/Action/Driver_00" + num + "_" + d(j) + "ms_" + "Action.png")

            disp("Driver_00" + num + "_" + d(j) + "ms_" + "Action.png")
        end
    end
end

%% release predict %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plotRelease == true
    disp("%% Plot Release")
    nnn=0;
    for num = 1:driver_num
        load("./03_pedal_predictor/"+input_file_names(num)+"/predict_result.mat")
        nnn=nnn+1;
        quantile_num = 6;
        
        for j = 1:timestep_num
            h = figure('visible',visible);
            setFigureSize(maxW, maxH, 2.5, 2)
            for i = 1:2
                train_table = training_data{1,j}(training_data{1,j}.state == drv_states(i),:);
                err = err_training{1,j}(i,2);
                subplot(2,3,i)
                plot_logistic_regression(train_table.pred_release_z, train_table.pred_release, train_table.release, quantile_num, "Training Data ( "+drv_states(i)+" )", height(train_table), err)
                if i == 1
                    ylabel('Release Probability [-]','FontSize',15)
                end

                test_table = test_data{1,j}(test_data{1,j}.state == drv_states(i),:);
                err = err_test{1,j}(i,2);
                subplot(2,3,i+3)
                plot_logistic_regression(test_table.pred_release_z, test_table.pred_release, test_table.release, quantile_num, "Test Data ( "+drv_states(i)+" )", height(test_table),err)
                if i == 1
                    ylabel('Release Probability [-]','FontSize',15)
                end
            end
            err = err_training{1,j}(3,2);
            subplot(2,3,3)
            plot_logistic_regression(training_data{1,j}.pred_release_z, training_data{1,j}.pred_release, training_data{1,j}.release, quantile_num, "Training Data ( all )", height(training_data{1,j}), err)
            err = err_test{1,j}(3,2);
            subplot(2,3,6)
            plot_logistic_regression(test_data{1,j}.pred_release_z, test_data{1,j}.pred_release, test_data{1,j}.release, quantile_num, "Test Data ( all )", height(test_data{1,j}), err)

            sgtitle("Driver : " + nnn + ", Time Width : " + d(j) + " ms",'FontSize',15)
            saveas(gcf,"./23_figure_pedal_predictor/Release/Driver_00" + num + "_" + d(j) + "ms_" + "Release.fig")
            saveas(gcf,"./23_figure_pedal_predictor/Release/Driver_00" + num + "_" + d(j) + "ms_" + "Release.png")

            disp("Driver_00" + num + "_" + d(j) + "ms_" + "Release.png")
        end    
    end
end

%% amount predict %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plotAmount == true
    disp("%% Plot Amount")

    for num = 4:driver_num
        load("./03_pedal_predictor/"+input_file_names(num)+"/predict_result.mat")
        
        for j = 1:timestep_num
            idx = join(['Thr_dif_', num2str(d(j))]);
            h = figure('visible',visible);
            setFigureSize(maxW, maxH, 2, 2)
            for i = 1:2
                train_table = training_data{1,j}(training_data{1,j}.state == drv_states(i),:);
                err = err_training{1,j}(i,3);
                subplot(2,3,i)
                plot_multiple_regression(train_table.pred_amount, train_table{:,idx}, "Train ( "+drv_states(i)+" )", height(train_table), err)
                % disp("i"+i+" :training")
                test_table = test_data{1,j}(test_data{1,j}.state == drv_states(i),:);
                err = err_test{1,j}(i,3);
                subplot(2,3,i+3)
                plot_multiple_regression(test_table.pred_amount, test_table{:,idx}, "Test ( "+drv_states(i)+" )", height(test_table),err)
                % disp("i"+i+" :test")
            end
            err = err_training{1,j}(3,3);
            subplot(2,3,3)
            plot_multiple_regression(training_data{1,j}.pred_amount, training_data{1,j}{:,idx}, "Train ( all )", height(training_data{1,j}), err)
            err = err_test{1,j}(3,3);
            % disp("all :training")
            subplot(2,3,6)
            plot_multiple_regression(test_data{1,j}.pred_amount, test_data{1,j}{:,idx}, "Test ( all )", height(test_data{1,j}), err)
            % disp("all :test")

            sgtitle("Driver : " + num + ", Time Width : " + d(j) + " ms",'FontSize',15)
            saveas(gcf,"./23_figure_pedal_predictor/Amount/Driver_00" + num + "_" + d(j) + "ms_" + "Amount.fig")
            saveas(gcf,"./23_figure_pedal_predictor/Amount/Driver_00" + num + "_" + d(j) + "ms_" + "Amount.png")
            
            disp("Driver_00" + num + "_" + d(j) + "ms_" + "Amount.png")
        end
    end
end


%%%   function   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function setFigureSize(maxW, maxH, nw, nh)
    p = get(gcf,'Position');
    dw = p(3)-min(nw*p(3),maxW);
    dh = p(4)-min(nh*p(4),maxH);
    set(gcf,'Position',[p(1)+dw/2  p(2)+dh  min(nw*p(3),maxW)  min(nh*p(4),maxH)])
end


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
    p2=scatter(pred_z, exp_value, 5,'MarkerEdgeColor','#0072BD','MarkerFaceColor','#0072BD');
    hold off
    legend([p1 p3 p2 ],{ 'Model Probability','Actual Probability','Actual Behavior'},'FontSize',10,'Location','southeast')
    xticks([-5:1:5])
    xlim([-5 5])
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
    xticks([-0.4 :0.1: 0.4])
    yticks([-0.4 :0.1: 0.4])
    box on
    axis equal
    xlabel('Experiment','FontSize',15)
    ylabel('Prediction','FontSize',15)
    title(title_string,'FontSize',15)
    text(0,-0.35,{"Data : "+num+" points";"RMSE = "+err;},'FontSize',10)
end
