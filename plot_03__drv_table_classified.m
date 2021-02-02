%% Plot drv_table grouping driving_state
close all

[ input_file_names , file_num ]= dir_FileNames("03_drv_table_combined_classified/UE1/*.csv");

disp(" ---------- Start Plot Classified Data ---------- ")

drv_states = ["Accelerate","Cruise","Follow","Braking","Stop"];
color_states = ["r", "b", "k", "g", "c"];

for num = 3:3%file_num

    input_file_name = input_file_names(num);
    disp("read " + input_file_name)
    drv_table_classified = readtable("./03_drv_table_combined_classified/UE1/" + input_file_name);
    drv_table_classified=drv_table_classified(1:200*40,:);

    output_file_name = extractBefore(input_file_name,".csv");

    %% %%%%%%%%%%%%%%% plot ( x : Time ) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xlim_max = 200;
    FontSize = 20;
    ax_FontSize = 10;

    figure
    sgtitle("\fontsize{16}Classified Driving Data")
    subplot(4,1,1);
    h = gscatter(drv_table_classified.Time, drv_table_classified.Thr, drv_table_classified.state,'rbg','',8);
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
    

    subplot(4,1,2);
    hold on
    h = gscatter(drv_table_classified.Time, drv_table_classified.Speed, drv_table_classified.state,'rbg');
    for i = 1:length(h)
        state_num = find(strcmp(h(i).DisplayName,drv_states));
        h(i).Color = color_states(state_num);
    end
    xlim([0 xlim_max])
    legend('off')
    %plot
    p1 = plot(drv_table_classified.Time, drv_table_classified.Speed_lim,'-.r','LineWidth',1);
    p2 = plot(drv_table_classified.Time, drv_table_classified.Speed_P,'-.k','LineWidth',1);
    ylabel('Speed [m/s]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend([p1 p2],{ 'Speed Limit','Preceding Car'},'FontSize',10)
    % legend('Speed of Preceding Car','FontSize',10)

    box on
    hold off

    subplot(4,1,3);
    h = gscatter(drv_table_classified.Time, drv_table_classified.distance_C, drv_table_classified.state,'rbg','',8);
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
    h = gscatter(drv_table_classified.Time, drv_table_classified.distance_P, drv_table_classified.state,'rbg');
    ylabel({'Distance to';'Preceding Car [m]'},'FontSize',FontSize)
    xlabel('Time [s]','FontSize',FontSize)
    for i = 1:length(h)
        state_num = find(strcmp(h(i).DisplayName,drv_states));
        h(i).Color = color_states(state_num);
    end
    xlim([0 xlim_max])
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')

    saveas(gcf,"./23_figure_drv_classified/UE1/" + output_file_name + ".fig")
    saveas(gcf,"./23_figure_drv_classified/UE1/" + output_file_name + ".png")


    clearvars -except num color_states drv_states input_file_names file_num

end


clearvars num color_states drv_states input_file_names file_num
