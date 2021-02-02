%clc;
%clear;
close all;

addpath("tools","function")

%% Get Window Information
scrsz = get(groot,'ScreenSize');
maxW = scrsz(3);
maxH = scrsz(4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [ input_file_names , file_num ]= dir_FileNames("01_drv_table/*.csv");
[ input_file_names , file_num ]= dir_FileNames("03_drv_table_combined_classified/UE1/*.csv");
disp("File Number = " + file_num)

drv_states = ["Accelerate","Cruise","Braking","Stop"];
Flag_Object1 = ["Stay_1000","Stay_500","Stay_200","Stay_100"];
Flag_Object2 = ["Action_1000","Action_500","Action_200","Action_100"];
Amount_Object = ["Thr_dif_future_1000","Thr_dif_future_500","Thr_dif_future_200","Thr_dif_future_100"];
Input_Amount = ["Accel","Speed","Thr", "Thr_dif_pre_1000", "Thr_dif_pre_500", "Thr_dif_pre_200", "Thr_dif_pre_100","va","v2","vthr","difvlim","difvp","v2dc","v2dp"];
Input_Unit = [" [-]", " [m/s]"," [-]"," [-]"," [-]"," [-]"," [-]", " [m^2/s^3]", " [(m/s)^2]"," [m/s]"," [m/s]"," [m/s]", " [m/s^2]", " [m/s^2]"];
Input_Flag = ["ExistPrecar","ExistO1","ExistO2"];

d = ["1000","500","200","100"];

disp(" ---------- Start Analyze Coefficient ---------- ")
if false
    drv_data=cell(1,file_num);
    for num = 1 : file_num
        input_file_name = input_file_names(num);
        disp("read " + input_file_name)
        drv_data_0 = readtable("./03_drv_table_combined_classified/UE1/" + input_file_name);
        drv_data_0.va = drv_data_0.Speed.*drv_data_0.Accel;
        drv_data_0.v2 = drv_data_0.Speed.*drv_data_0.Speed;
        drv_data_0.vthr = drv_data_0.Speed.*drv_data_0.Thr;
        drv_data_0.difvlim = drv_data_0.Speed_lim - drv_data_0.Speed;
        drv_data_0.difvp = drv_data_0.Speed_P - drv_data_0.Speed;
        drv_data_0.v2dc = drv_data_0.v2./ max(drv_data_0.distance_C,1);
        drv_data_0.v2dp = drv_data_0.v2./ max(drv_data_0.distance_P,1);
        drv_data{num} = drv_data_0;
    end
end

drv_states = ["Accelerate","Cruise","Braking","Stop"];

for i = 1:2 %State
    
    drv_data_states = cell(1,4); 
    for num = 1 : file_num
        drv_data_states{num} = drv_data{num}(string(drv_data{num}.state)==drv_states(i),:);
    end

    % for j = 1:length(Input_Amount)
    %     AmountIn = Input_Amount(j);
    %     disp(AmountIn)
    %     if j == 12 | j == 14
    %         for num = 1 : file_num
    %             drv_data_state{num} = drv_data_states{num}(drv_data_states{num}.ExistPrecar==1,:);
    %         end
    %     else
    %         drv_data_state = drv_data_states;
    %     end

    %     figure
    %     setFigureSize(maxW, maxH, 1.5, 1.5)
    %     for obj_num = 1:4
    %         subplot(4,4,obj_num*4-3)

    %         hold on
    %         for num=1:file_num
    %             plot_probability(drv_data_state{num}{:,AmountIn}, drv_data_state{num}{:,Flag_Object1(obj_num)}, 10)
    %         end
    %         hold off
    %         ylabel("\Deltat = "+d(obj_num)+" ms",'FontSize',12)
    %         switch obj_num
    %             case 1
    %                 title("Probability of Stay",'FontSize',12)        
    %             case 4
    %                 xlabel(AmountIn + Input_Unit(j),'FontSize',12)
    %         end
    %     end
    %     for obj_num = 1:4
    %         subplot(4,4,obj_num*4-2)

    %         hold on
    %         for num=1:file_num
    %             plot_probability(drv_data_state{num}{:,AmountIn}, drv_data_state{num}{:,Flag_Object2(obj_num)}, 10)
    %         end
    %         hold off
    %         switch obj_num
    %             case 1
    %                 title("Probability of Action",'FontSize',12)        
    %             case 4
    %                 xlabel(AmountIn + Input_Unit(j),'FontSize',12)
    %         end
    %     end
    %     for obj_num = 1:4
    %         subplot(4,4,obj_num*4-1)

    %         hold on
    %         for num=1:file_num
    %             tmp = drv_data_state{num}{:,Flag_Object1(obj_num)}==0 & drv_data_state{num}{:,Flag_Object2(obj_num)}==1;
    %             plot_amount(drv_data_state{num}{tmp,AmountIn}, drv_data_state{num}{tmp,Amount_Object(obj_num)}, 10)
    %         end
    %         hold off
    %         switch obj_num
    %             case 1
    %                 title("Amount of Action",'FontSize',12)        
    %             case 4
    %                 xlabel(AmountIn + Input_Unit(j),'FontSize',12)
    %         end
    %     end
    %     for obj_num = 1:4
    %         subplot(4,4,obj_num*4)

    %         hold on
    %         for num=1:file_num
    %             tmp = drv_data_state{num}{:,Flag_Object1(obj_num)}==0 & drv_data_state{num}{:,Flag_Object2(obj_num)}==0;
    %             plot_amount(drv_data_state{num}{tmp,AmountIn}, drv_data_state{num}{tmp,Amount_Object(obj_num)}, 10)
    %         end
    %         hold off
    %         switch obj_num
    %             case 1
    %                 title("Amount of Release",'FontSize',12)        
    %             case 4
    %                 xlabel(AmountIn + Input_Unit(j),'FontSize',12)
    %         end
    %     end
    %     sgtitle("Effect of " + AmountIn + " at " + drv_states(i) + " Mode",'FontSize',15)
    % end

    for j = 1:3
        FlagIn = Input_Flag(j);
        disp(FlagIn)
        

        drv_data_state = drv_data_states;


        figure
        setFigureSize(maxW, maxH, 1.5, 1.5)
        for obj_num = 1:4
            subplot(4,4,obj_num*4-3)

            hold on
            for num=1:file_num
                plot_discrete_probability(drv_data_state{num}{:,FlagIn}, drv_data_state{num}{:,Flag_Object1(obj_num)})
            end
            hold off
            ylabel("\Deltat = "+d(obj_num)+" ms",'FontSize',12)
            switch obj_num
                case 1
                    title("Probability of Stay",'FontSize',12)        
                case 4
                    xlabel(FlagIn + " [-]",'FontSize',12)
            end
        end
        for obj_num = 1:4
            subplot(4,4,obj_num*4-2)

            hold on
            for num=1:file_num
                plot_discrete_probability(drv_data_state{num}{:,FlagIn}, drv_data_state{num}{:,Flag_Object2(obj_num)})
            end
            hold off
            switch obj_num
                case 1
                    title("Probability of Action",'FontSize',12)        
                case 4
                    xlabel(FlagIn + " [-]",'FontSize',12)
            end
        end
        for obj_num = 1:4
            subplot(4,4,obj_num*4-1)

            hold on
            for num=1:file_num
                tmp = drv_data_state{num}{:,Flag_Object1(obj_num)}==0 & drv_data_state{num}{:,Flag_Object2(obj_num)}==1;
                plot_discrete_amount(drv_data_state{num}{tmp,FlagIn}, drv_data_state{num}{tmp,Amount_Object(obj_num)})
            end
            hold off
            switch obj_num
                case 1
                    title("Amount of Action",'FontSize',12)        
                case 4
                    xlabel(FlagIn + " [-]",'FontSize',12)
            end
        end
        for obj_num = 1:4
            subplot(4,4,obj_num*4)

            hold on
            for num=1:file_num
                tmp = drv_data_state{num}{:,Flag_Object1(obj_num)}==0 & drv_data_state{num}{:,Flag_Object2(obj_num)}==0;
                plot_discrete_amount(drv_data_state{num}{tmp,FlagIn}, drv_data_state{num}{tmp,Amount_Object(obj_num)})
            end
            hold off
            switch obj_num
                case 1
                    title("Amount of Release",'FontSize',12)        
                case 4
                    xlabel(FlagIn + " [-]",'FontSize',12)
            end
        end

        % figure
        % setFigureSize(maxW, maxH, 1.5, 1.5)
        % for obj_num = 1:8
        %     subplot(4,2,obj_num)
        %     hold on
        %     for num=1:file_num
        %         plot_discrete_probability(drv_data_state{num}{:,FlagIn}, drv_data_state{num}{:,Flag_Object(obj_num)})
        %     end
        %     hold off
        %     switch obj_num
        %         case 1
        %             title("Probability of Stay",'FontSize',12)
        %             ylabel("\Deltat = 1000 ms",'FontSize',12)
        %         case 2
        %             title("Probability of Action",'FontSize',12)
        %             ylabel("\Deltat = 1000 ms",'FontSize',12)
        %         case {3,4}
        %             ylabel("\Deltat = 500 ms",'FontSize',12)
        %         case {5,6}
        %             ylabel("\Deltat = 200 ms",'FontSize',12)
        %         case 7
        %             ylabel("\Deltat = 100 ms",'FontSize',12)
        %             xlabel(FlagIn + " [-]",'FontSize',12)
        %         case 8
        %             ylabel("\Deltat = 100 ms",'FontSize',12)
        %             xlabel(FlagIn + " [-]",'FontSize',12)
        %     end
        % end
        sgtitle("Effect of " + FlagIn + " at " + drv_states(i) + " Mode",'FontSize',15)
    end

    % figure
    % hold on
    % plot_probability(drv_data_state{1}.Speed, drv_data_state{1}.Stay_1000, 10)
    % plot_probability(drv_data_state{2}.Speed, drv_data_state{2}.Stay_1000, 10)
    % hold off

    % figure
    % hold on
    % plot_discrete_probability(drv_data_state{1}.ExistO1, drv_data_state{1}.Stay_1000)
    % plot_discrete_probability(drv_data_state{2}.ExistO1, drv_data_state{2}.Stay_1000)
    % hold off

end


function plot_probability(x, exp_value, quantile_num)
    z_quantile = quantile(x, quantile_num-1);

    rate_z=zeros(1, quantile_num);
    for k = 1: quantile_num
        if k==1
            z_tmp = x( x < z_quantile(1));
            value_tmp = exp_value( x < z_quantile(1));
        elseif k == quantile_num
            z_tmp = x( x > z_quantile(quantile_num-1));
            value_tmp = exp_value( x > z_quantile(quantile_num-1));
        else
            z_tmp = x( x > z_quantile(k-1) & x < z_quantile(k));
            value_tmp = exp_value( x > z_quantile(k-1) & x < z_quantile(k));
        end
        z(k) = mean(z_tmp);
        rate_z(k)=sum(value_tmp)/length(value_tmp);
    end
    
    %title({ drv_states(i) + ', ' + d(j) + ' ms'},'FontSize',15)  % result of Logistic regression
    p=plot(z,rate_z,'-o','LineWidth',1,'MarkerSize',3);
    
    %legend([p1 p3 p2 ],{ 'Model Probability','Actual Probability','Actual Behavior'},'FontSize',10,'Location','southeast')
    % xticks([-5:1:5])
    % xlim([-5 5])
    ylim([0 1])
    box on
    %xlabel('z [-]','FontSize',15)
end

function plot_amount(x, exp_value, quantile_num)
    z_quantile = quantile(x, quantile_num-1);
    for k = 1: quantile_num
        if k==1
            z_tmp = x( x < z_quantile(1));
            value_tmp = exp_value( x < z_quantile(1));
        elseif k == quantile_num
            z_tmp = x( x > z_quantile(quantile_num-1));
            value_tmp = exp_value( x > z_quantile(quantile_num-1));
        else
            z_tmp = x( x > z_quantile(k-1) & x < z_quantile(k));
            value_tmp = exp_value( x > z_quantile(k-1) & x < z_quantile(k));
        end
        z(k) = mean(z_tmp);
        rate_z(k)=sum(value_tmp)/length(value_tmp);
    end

    
    %title({ drv_states(i) + ', ' + d(j) + ' ms'},'FontSize',15)  % result of Logistic regression
    p=plot(z,rate_z,'-o','LineWidth',1,'MarkerSize',3);

    %legend([p1 p3 p2 ],{ 'Model Probability','Actual Probability','Actual Behavior'},'FontSize',10,'Location','southeast')
    % xticks([0 1])
    % xlim([-0.5 1.5])
    % ylim([0 1])
    box on
    %xlabel('z [-]','FontSize',15)
end

function plot_discrete_probability(x, exp_value)

    prob = [ sum(exp_value(x==0))/length(exp_value(x==0)), sum(exp_value(x==1))/length(exp_value(x==1)) ];

    
    %title({ drv_states(i) + ', ' + d(j) + ' ms'},'FontSize',15)  % result of Logistic regression
    p=plot([ 0 1 ], prob,'-o','LineWidth',1,'MarkerSize',3);

    %legend([p1 p3 p2 ],{ 'Model Probability','Actual Probability','Actual Behavior'},'FontSize',10,'Location','southeast')
    xticks([0 1])
    xlim([-0.5 1.5])
    ylim([0 1])
    box on
    %xlabel('z [-]','FontSize',15)
end

function plot_discrete_amount(x, exp_value)

    prob = [ sum(exp_value(x==0))/length(exp_value(x==0)), sum(exp_value(x==1))/length(exp_value(x==1)) ];

    
    %title({ drv_states(i) + ', ' + d(j) + ' ms'},'FontSize',15)  % result of Logistic regression
    p=plot([ 0 1 ], prob,'-o','LineWidth',1,'MarkerSize',3);

    %legend([p1 p3 p2 ],{ 'Model Probability','Actual Probability','Actual Behavior'},'FontSize',10,'Location','southeast')
    xticks([0 1])
    xlim([-0.5 1.5])
    ylim([-0.15 0.15])
    box on
    %xlabel('z [-]','FontSize',15)
end



function setFigureSize(maxW, maxH, nw, nh)
    p = get(gcf,'Position');
    dw = p(3)-min(nw*p(3),maxW);
    dh = p(4)-min(nh*p(4),maxH);
    set(gcf,'Position',[p(1)+dw/2  p(2)+dh  min(nw*p(3),maxW)  min(nh*p(4),maxH)])
end