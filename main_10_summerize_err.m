clear
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
d = {'t_1000', 't_500', 't_200', 't_100'};

%% test %%%%%%%%%%%%%%%%%%%%%

isTest = false;
plotAction = true;
plotRelease = true;
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
    err_Action.training = table(zeros(driver_num,timestep_num),zeros(driver_num,timestep_num),zeros(driver_num,timestep_num));
    err_Action.training.Properties.VariableNames={'Accel', 'Cruise', 'All'};
    err_Action.test = table(zeros(driver_num,timestep_num),zeros(driver_num,timestep_num),zeros(driver_num,timestep_num));
    err_Action.test.Properties.VariableNames={'Accel', 'Cruise', 'All'};

    nnn=0;
    for num = 1:driver_num
        load("./03_pedal_predictor/"+input_file_names(num)+"/predict_result.mat")
        nnn=nnn+1;
        for j = 1:timestep_num
            for i = 1:3
                err_Action.training{:,i}(nnn,j)=err_training{1,j}(i,1);
                err_Action.test{:,i}(nnn,j)=err_test{1,j}(i,1);
            end
        end
    end
    
    figure('visible',visible)
    setFigureSize(maxW, maxH, 1.2, 3)
    sgtitle("Cross Entropy Error for Action Predict (Accelerate Mode)",'FontSize',15)
    plot_error(err_Action);
    
    saveas(gcf,"./24_figure_Error/CEError_Action_Acc.fig")
    saveas(gcf,"./24_figure_Error/CEError_Action_Acc.png")
    disp("save action error plot")
end


%% release predict %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plotRelease == true
    disp("%% Plot Release")
    err_Release.training = table(zeros(driver_num,timestep_num),zeros(driver_num,timestep_num),zeros(driver_num,timestep_num));
    err_Release.training.Properties.VariableNames={'Accel', 'Cruise', 'All'};
    err_Release.test = table(zeros(driver_num,timestep_num),zeros(driver_num,timestep_num),zeros(driver_num,timestep_num));
    err_Release.test.Properties.VariableNames={'Accel', 'Cruise', 'All'};

    nnn=0;
    for num = 1:driver_num
        load("./03_pedal_predictor/"+input_file_names(num)+"/predict_result.mat")
        nnn=nnn+1;
        for j = 1:timestep_num
            for i = 1:3
                err_Release.training{:,i}(nnn,j)=err_training{1,j}(i,2);
                err_Release.test{:,i}(nnn,j)=err_test{1,j}(i,2);
            end
        end
    end
    figure('visible',visible)
    setFigureSize(maxW, maxH, 1.2, 3)
    sgtitle("Cross Entropy Error for Release Predict (Accelerate Mode)",'FontSize',15)
    plot_error(err_Release);
    saveas(gcf,"./24_figure_Error/CEError_Release_Acc.fig")
    saveas(gcf,"./24_figure_Error/CEError_Release_Acc.png")
    disp("save release error plot")
end

%% amount predict %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plotAmount == true
    disp("%% Plot Amount")
    err_Amount.training = table(zeros(driver_num,timestep_num),zeros(driver_num,timestep_num),zeros(driver_num,timestep_num));
    err_Amount.training.Properties.VariableNames={'Accel', 'Cruise', 'All'};
    err_Amount.test = table(zeros(driver_num,timestep_num),zeros(driver_num,timestep_num),zeros(driver_num,timestep_num));
    err_Amount.test.Properties.VariableNames={'Accel', 'Cruise', 'All'};

    nnn=0;
    for num = 1:driver_num
        load("./03_pedal_predictor/"+input_file_names(num)+"/predict_result.mat")
        nnn=nnn+1;
        for j = 1:timestep_num
            for i = 1:3
                err_Amount.training{:,i}(nnn,j)=err_training{1,j}(i,3);
                err_Amount.test{:,i}(nnn,j)=err_test{1,j}(i,3);
            end
        end
    end
    figure('visible',visible)
    setFigureSize(maxW, maxH, 1.2, 3)
    sgtitle("RSME for Amount Predict (Accelerate Mode)",'FontSize',15)
    plot_error(err_Amount);
    saveas(gcf,"./24_figure_Error/RSME_Amount_Acc.fig")
    saveas(gcf,"./24_figure_Error/RSME_Amount_Acc.png")
    disp("save amount error plot")
end

clearvars -except input_file_names file_num err_Action err_Release err_Amount isTest plotAction plotRelease plotAmount

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_error(err)
    for num = 1 : 7
        subplot(7,1,num)
        hold on
        plot([1000,500,200,100],err.training{:,"Accel"}(num,:),'-o')
        plot([1000,500,200,100],err.test{:,"Accel"}(num,:),'-o')
        hold off
        xlim([0 1000])
        % ylim([0 2])
        % yticks([0:0.5:2])
        legend(["training","test"],'FontSize',10)
        box on
        if num ==7
            xlabel('Time Width [ms]','FontSize',15)
        end
        ylabel( "Driver :"+num,'FontSize',15)
    end
end
