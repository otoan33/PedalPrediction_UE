%% Plot drv_table
close all;
clear

addpath("tools","function")

%% Get Window Information
scrsz = get(groot,'ScreenSize');
maxW = scrsz(3);
maxH = scrsz(4);

[ input_file_names , file_num ]= dir_FileNames("01_drv_table/UE1/Driver_0*/*.csv");

disp(" ---------- Start Plot Table Data ---------- ")

for num = 1:file_num
    input_file_name = input_file_names(num);
    disp("read " + input_file_name)
    tmp = dir("./01_drv_table/UE*/Driver_0*/"+input_file_name);
    input_dir = tmp.folder;
    drv_table = readtable(input_dir+"/" + input_file_name);


    clearvars tmp    

    %% %%%%%%%%%%%%%% plot ( x : time ) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xlim_max = max(drv_table.Time);
    FontSize = 14;
    ax_FontSize = 10;
    

    h = figure('visible',true);

    setFigureSize(maxW, maxH, 1.5, 2.4)

    subplot(7,1,1);
    plot(drv_table.Time, drv_table.Thr);
    xlim([0 xlim_max])
    ylim([0 0.5])
    ylabel('Throttle [-]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')
    title("\fontsize{16}Driving Data")

    subplot(7,1,2);
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
    legend('Speed','Preceding Vehivle','Limit')
    legend('FontSize',10)

    subplot(7,1,4);
    plot(drv_table.Time, drv_table.distance_C);
    xlim([0 xlim_max])
    ylabel({'Distance to';'Turn [m]'},'FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')

    subplot(7,1,5);
    plot(drv_table.Time, drv_table.distance_P);
    xlim([0 xlim_max])
    ylim([0 200])
    ylabel({'Distance to';'Preceding Vehivle [m]'},'FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')

    % subplot(6,1,5);
    % scatter(drv_table.Time, drv_table.ExistPrecar,1);
    % xlim([0 xlim_max])
    % ylim([-0.1 1.1])
    % yticks([0 1])
    % ylabel('ExistPrecar [-]','FontSize',FontSize)
    % ax = gca;
    % ax.FontSize = ax_FontSize;
    % legend('off')
    % box on

    % subplot(6,1,6);
    % scatter(drv_table.Time, drv_table.Include,1);
    % xlim([0 xlim_max])
    % ylim([-0.1 1.1])
    % yticks([0 1])
    % ylabel('Include [-]','FontSize',FontSize)
    % xlabel('Time [s]','FontSize',FontSize)
    % ax = gca;
    % ax.FontSize = ax_FontSize;
    % legend('off')
    % box on

    subplot(7,1,6);
    scatter(drv_table.Time, drv_table.ExistO1,1);
    xlim([0 xlim_max])
    ylim([-0.1 1.1])
    yticks([0 1])
    ylabel({'Parallel Running';'Vehivle';' Exist [-]'},'FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')
    box on

    subplot(7,1,7);
    scatter(drv_table.Time, drv_table.ExistO2,1);
    xlim([0 xlim_max])
    ylim([-0.1 1.1])
    yticks([0 1])
    ylabel({'Oncomming';'Vehivle';' Exist[-]'},'FontSize',FontSize)
    xlabel('Time [s]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')
    box on

    subplot(7,1,3);
    plot(drv_table.Time, drv_table.Steer_SW);
    xlim([0 xlim_max])
    ylim([-400 400])
    yticks([-400:200:400])
    ylabel({'Steering Wheel';'Angle [deg]'},'FontSize',FontSize)
    xlabel('Time [s]','FontSize',FontSize)
    ax = gca;
    ax.FontSize = ax_FontSize;
    legend('off')
    box on

    % saveas(gcf,"./21_figure_drv_table/UE1/Driving_0" + num + ".fig")
    % saveas(gcf,"./21_figure_drv_table/UE1/Driving_0" + num + ".png")


end

clearvars num color_states drv_states



function setFigureSize(maxW, maxH, nw, nh)
    p = get(gcf,'Position');
    dw = p(3)-min(nw*p(3),maxW);
    dh = p(4)-min(nh*p(4),maxH);
    set(gcf,'Position',[p(1)+dw/2  p(2)+dh  min(nw*p(3),maxW)  min(nh*p(4),maxH)])
end