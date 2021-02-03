clear
close all

addpath("../tools","../function")

%% Get Window Information
scrsz = get(groot,'ScreenSize');
maxW = scrsz(3);
maxH = scrsz(4);


Error = readtable("Error_thr.xlsx");

Input = ["Thr_dif_pre_100","Thr_dif_pre_200","Thr_dif_pre_500","Thr_dif_pre_1000"];
Input_num = [0 1];
Target1 = ["Err_A100","Err_A200","Err_A500","Err_A1000"];
Target2 = ["Err_B100","Err_B200","Err_B500","Err_B1000"];
Target3 = ["Err_C100","Err_C200","Err_C500","Err_C1000"];
Target4 = ["RSME_a_A100","RSME_a_A200","RSME_a_A500","RSME_a_A1000"];
Target5 = ["RSME_r_A100","RSME_r_A200","RSME_r_A500","RSME_r_A1000"];
Target6 = ["RSME_a_B100","RSME_a_B200","RSME_a_B500","RSME_a_B1000"];
Target7 = ["RSME_r_B100","RSME_r_B200","RSME_r_B500","RSME_r_B1000"];
Target8 = ["RSME_a_C100","RSME_a_C200","RSME_a_C500","RSME_a_C1000"];
Target9 = ["RSME_r_C100","RSME_r_C200","RSME_r_C500","RSME_r_C1000"];

Target = [Target1; Target2; Target3; Target4; Target5; Target6; Target7; Target8; Target9;];

% Target2 = ["RSME_a_A100","RSME_a_A200","RSME_a_A500","RSME_a_A1000"];

% % Target2 = ["RSME_a_A100","RSME_a_A200","RSME_a_A500","RSME_a_A1000"];
Output_num = [100, 200, 500, 1000];
Input = ["Thr"	"Speed"	"Accel"	"ExistPrecar"	"ExistO1"	"ExistO2"	"distance"	"difv"];

% FontSize = 14;
% ax_FontSize = 10;
% figure
% for j = 1:4
%     subplot(2,2,j)
%     hold on
%     for num=1:8
%         Error_num = Error(Error.Driver==num&Error.isTest==0,:);
%         plot(Input_num,Error_num{:,Target1(j)}(1:5),'-o')
%         % scatter(0,Error_num{:,Target(j)}(5),30,'filled')
%     end
%     hold off
%     ylim([0 1.2])
%     xlim([-100 1100])
%     xticks([100 200 500 1000])
%     ax = gca;
%     ax.FontSize = ax_FontSize;
%     ylabel("Cross Entropy Error [-]",'FontSize',FontSize)
%     xlabel('\Deltat [ms]','FontSize',FontSize)
%     legend('off')
%     box on
%     title("t_s = "+Output_num(j)+" [ms]",'FontSize',FontSize)
% end

FontSize = 18;
ax_FontSize = 10;

states = ["Accelerate","Cruise","Brake"];

for k = 1:3

    for j = 1:4
        figure

        
        for i = 1:8
            subplot(3,3,i)
            hold on
            for num=1:8
                Error_num = Error(Error.Driver==num & Error.isTest==1,:);
                plot(Input_num,Error_num{:,Target(k,j)}([1,i+1]),'-o')
                % scatter(0,Error_num{:,Target(j)}(5),30,'filled')
            end
            hold off
            ax = gca;
            ax.FontSize = ax_FontSize;
            xlim([-0.5 1.5])
            xticks([0 1])
            ylim([0.5 1.5])
            if i ==4
                ylabel("Cross Entropy Error [-]",'FontSize',FontSize)
            end
            % xlabel('\Deltat [ms]','FontSize',FontSize)
            legend('off')
            box on
            title(Input(i))
            sgtitle(states(k)+" Mode, t_s = "+Output_num(j)+" [ms]",'FontSize',FontSize)
        end
        setFigureSize(maxW, maxH, 1.5, 1.5)
    end

end

function setFigureSize(maxW, maxH, nw, nh)
    p = get(gcf,'Position');
    dw = p(3)-min(nw*p(3),maxW);
    dh = p(4)-min(nh*p(4),maxH);
    set(gcf,'Position',[p(1)+dw/2  p(2)+dh  min(nw*p(3),maxW)  min(nh*p(4),maxH)])
end