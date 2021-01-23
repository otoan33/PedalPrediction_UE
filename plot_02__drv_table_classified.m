%% Plot drv_table grouping driving_state
close all

[ input_file_names , file_num ]= dir_FileNames("02_drv_table_classified/*.csv");

disp(" ---------- Start Plot Classified Data ---------- ")

drv_states = ["Accelerate","Cruise","Follow","Braking","Stop"];
color_states = ["r", "b", "k", "g", "c"];

for num = 1:1%file_num

    input_file_name = input_file_names(num);
    disp("read " + input_file_name)
    classified_drv_table = readtable("./02_drv_table_classified/" + input_file_name);
    
    drv_table_Lap_1 = classified_drv_table(classified_drv_table.Lap==1,:);

    %% %%%%%%%%%%%%%%% plot ( x : Station ) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xlim_max = 5500;
    FontSize = 14;
    ax_FontSize = 10;
        

    figure
    subplot(4,1,1);
    h = gscatter(drv_table_Lap_1.Station, drv_table_Lap_1.Thr, drv_table_Lap_1.state,'rbg','',8);
    for i = 1:length(h)
        state_num = find(strcmp(h(i).DisplayName,drv_states));
        h(i).Color = color_states(state_num);
    end
    xlim([0 xlim_max])
    ylabel('Throttle [-]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('FontSize',10)
    %legend('off')
    title("\fontsize{16}Classified Driving Data")

    subplot(4,1,2);
    hold on
    h = gscatter(drv_table_Lap_1.Station, drv_table_Lap_1.Speed, drv_table_Lap_1.state,'rbg');
    for i = 1:length(h)
        state_num = find(strcmp(h(i).DisplayName,drv_states));
        h(i).Color = color_states(state_num);
    end
    xlim([0 xlim_max])
    legend('off')
    %plot
    p1 = plot(drv_table_Lap_1.Station, drv_table_Lap_1.Speed_lim,'-.r','LineWidth',1);
    p2 = plot(drv_table_Lap_1.Station, drv_table_Lap_1.Speed_P,'-.k','LineWidth',1);
    ylabel('Speed [m/s]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend([p1 p2],{ 'Speed Limit','Preceding Car'},'FontSize',10)
    % legend('Speed of Preceding Car','FontSize',10)

    box on
    hold off

    subplot(4,1,3);
    h = gscatter(drv_table_Lap_1.Station, drv_table_Lap_1.distance_C, drv_table_Lap_1.state,'rbg','',8);
    ylabel({'Distance to';'Turn [m]'},'FontSize',FontSize)
    for i = 1:length(h)
        state_num = find(strcmp(h(i).DisplayName,drv_states));
        h(i).Color = color_states(state_num);
    end
    xlim([0 xlim_max])
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')

    subplot(4,1,4);
    h = gscatter(drv_table_Lap_1.Station, drv_table_Lap_1.distance_P, drv_table_Lap_1.state,'rbg');
    ylabel({'Distance to';'Preceding Car [m]'},'FontSize',FontSize)
    xlabel('Station [m]','FontSize',FontSize)
    for i = 1:length(h)
        state_num = find(strcmp(h(i).DisplayName,drv_states));
        h(i).Color = color_states(state_num);
    end
    xlim([0 xlim_max])
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')

    clearvars -except num color_states drv_states input_file_names file_num
    
    % plot(drv_table_Lap_1(drv_table_Lap_1.state == drv_states(1),:).Station, drv_table_Lap_1(drv_table_Lap_1.state == drv_states(1),:).Thr);


    % figure
    % gscatter(drv_table.Speed, drv_table.Accel, drv_table.state)


    % figure
    % h = gscatter(drv_table.Speed, drv_table.Thr, drv_table.state);
    % for i = 1:length(h)
    %     state_num = find(strcmp(h(i).DisplayName,drv_states));
    %     h(i).Color = color_states(state_num);
    % end


    % figure
    % gscatter(drv_table.Time, drv_table.distance, drv_table.state)

    % figure
    % %%gscatter(drv_table.Time, drv_table.Thr, drv_table.state)
    % plot(drv_table.Time, drv_table.Thr, drv_table.Time, drv_table.Accel, drv_table.Time, drv_table.Bk_Stat)
    % legend("Thr","Accel","Bk Stat")

    % figure
    % h = gscatter(drv_table.Station, drv_table.Thr, drv_table.state,'rbg','',10);
    % for i = 1:length(h)
    %     state_num = find(strcmp(h(i).DisplayName,drv_states));
    %     h(i).Color = color_states(state_num);
    % end



    % figure
    % h = gscatter(drv_table.Station, drv_table.Speed, drv_table.state,'rbg');
    % for i = 1:length(h)
    %     state_num = find(strcmp(h(i).DisplayName,drv_states));
    %     h(i).Color = color_states(state_num);
    % end

    % clearvars i h state_num 
    % figure
    % i = 1;
    % T = cell(1,4);
    % for n = [1 5 10 20]
    %     idx = join(['Thr_dif_rough_', num2str(n)]);
    %     table_name = join(['T_', num2str(n)]);
    %     T{1,i} = drv_table(isnan(drv_table{:,idx}) == 0, {'Time',idx,'state'});
    %     i = i + 1;
    % end

    % hold on
    % % gscatter(T{1,1}.Time,T{1,1}.Thr_dif_rough_1, T{1,1}.state)
    % % gscatter(T{1,2}.Time,T{1,2}.Thr_dif_rough_5, T{1,2}.state)
    % % gscatter(T{1,3}.Time,T{1,3}.Thr_dif_rough_10, T{1,3}.state)
    % plot(T{1,4}.Time,T{1,4}.Thr_dif_rough_20)
    % hold off
end


clearvars num color_states drv_states input_file_names file_num


%% Plot results of logistic regression for Action/no Action
% for i = 1%:2
%     for j = 1:5
%         figure
%         hold on
%         title({'result of logistic regression for Action/no Action'; drv_states(i) + ', ' + d(j) + ' ms'},'FontSize',15)  %result of Logistic regression 
%         scatter(pred_training_action_z{i,j},pred_training_action{i,j},5)
%         scatter(pred_training_action_z{i,j},training_data{i,j}.action,5)
%         hold off
%     end
% end

% clearvars i j


% %% Plot results of logistic regression for Release/Other
% for i = 1
%     for j = 1:5
%         figure
%         hold on
%         title({'result of logistic regression for Release/Other'; drv_states(i) + ', ' + d(j) + ' ms'},'FontSize',15)  %result of Logistic regression 
%         scatter(pred_training_release_z{i,j},pred_training_release{i,j},5)
%         scatter(pred_training_release_z{i,j},training_data_release{i,j}.release,5)
%         hold off
%     end
% end

% clearvars i j


% %% Plot results of "Amount" predict model by multiple regression
% for i = 1%:2
%     for j = 1:5
%         idx = join(['Thr_dif_', num2str(d(j))]);
%         figure
%         axis equal
%         hold on
%         title({'result of l"Amount" predict model by multiple regression'; drv_states(i) + ', ' + d(j) + ' ms'},'FontSize',15)
%         scatter(training_data_amount{i,j}{:,idx},pred_training_amount{i,j},5)
%         hline = refline([1 0]);
%         hline.Color = 'k';
%         hline.LineStyle = ':';
%         hline.HandleVisibility = 'off';
%         hold off
%     end
% end

% clearvars i j idx