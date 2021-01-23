%% Plot drv_table
close all;

addpath("tools","function")

[ input_file_names , file_num ]= dir_FileNames("01_drv_table/*.csv");

disp(" ---------- Start Plot Table Data ---------- ")

for num = 2:2
    input_file_name = input_file_names(num);
    disp("read " + input_file_name)
    drv_table = readtable("./01_drv_table/" + input_file_name);
    
    drv_table_Lap_1 = drv_table(drv_table.Lap==1,:);

    %% %%%%%%%%%%%%%%% plot ( x : Station ) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    xlim_max = 5500;
    FontSize = 14;
    ax_FontSize = 10;

    figure
    subplot(6,1,1);
    plot(drv_table_Lap_1.Station, drv_table_Lap_1.Thr);
    xlim([0 xlim_max])
    ylim([0 0.5])
    ylabel('Throttle [-]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')
    title("\fontsize{16}Driving Data")

    subplot(6,1,2);
    hold on
    plot(drv_table_Lap_1.Station, drv_table_Lap_1.Speed)
    plot(drv_table_Lap_1.Station, drv_table_Lap_1.Speed_P,'-.k')
    plot(drv_table_Lap_1.Station, drv_table_Lap_1.Speed_lim,'-.r')
    box on
    hold off
    xlim([0 xlim_max])
    ylabel('Speed [m/s]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('Own Car','Preceding Car','Limit')
    legend('FontSize',9)
    
    subplot(6,1,3);
    plot(drv_table_Lap_1.Station, drv_table_Lap_1.distance_C);
    xlim([0 xlim_max])
    ylabel({'Distance to';'Turn [m]'},'FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')

    subplot(6,1,4);
    plot(drv_table_Lap_1.Station, drv_table_Lap_1.distance_P);
    xlim([0 xlim_max])
    ylim([0 150])
    ylabel({'Distance to';'PreCar [m]'},'FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')

    subplot(6,1,5);
    scatter(drv_table_Lap_1.Station, drv_table_Lap_1.traffic,1);
    xlim([0 xlim_max])
    ylim([-0.1 1.1])
    ylabel('Traffic [-]','FontSize',FontSize)
    xlabel('Station [m]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')
    box on

    subplot(6,1,6);
    scatter(drv_table_Lap_1.Station, drv_table_Lap_1.Include,1);
    xlim([0 xlim_max])
    ylim([-0.1 1.1])
    ylabel('Include [-]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')
    box on

    %% %%%%%%%%%%%%%% plot ( x : time ) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xlim_max = 1050;

    figure
    subplot(6,1,1);
    plot(drv_table.Time, drv_table.Thr);
    xlim([0 xlim_max])
    ylim([0 0.5])
    ylabel('Throttle [-]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')
    title("\fontsize{16}Driving Data")

    subplot(6,1,2);
    hold on
    plot(drv_table.Time, drv_table.Speed)
    plot(drv_table.Time, drv_table.Speed_P,'-.k')
    plot(drv_table.Time, drv_table.Speed_lim,'-.r')
    box on
    hold off
    xlim([0 xlim_max])
    ylabel('Speed [m/s]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('Speed','PreCar','Limit')
    legend('FontSize',10)

    subplot(6,1,3);
    plot(drv_table.Time, drv_table.distance_C);
    xlim([0 xlim_max])
    ylabel({'Distance to';'Turn [m]'},'FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')

    subplot(6,1,4);
    plot(drv_table.Time, drv_table.distance_P);
    xlim([0 xlim_max])
    ylim([0 150])
    ylabel({'Distance to';'PreCar [m]'},'FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')

    subplot(6,1,6);
    scatter(drv_table.Time, drv_table.Include,1);
    xlim([0 xlim_max])
    ylim([-0.1 1.1])
    yticks([0 1])
    ylabel('Include [-]','FontSize',FontSize)
    xlabel('Time [s]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')
    box on

    subplot(6,1,5);
    scatter(drv_table.Time, drv_table.traffic,1);
    xlim([0 xlim_max])
    ylim([-0.1 1.1])
    yticks([0 1])
    ylabel('Traffic [-]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')
    box on

end

clearvars num color_states drv_states

