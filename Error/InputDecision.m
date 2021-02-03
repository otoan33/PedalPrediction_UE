clear
close all

Error = readtable("Error_001.xlsx");

Input = ["Thr_dif_pre_100","Thr_dif_pre_200","Thr_dif_pre_500","Thr_dif_pre_1000"];
Input_num = [0 1];
Target1 = ["Err_A100","Err_A200","Err_A500","Err_A1000"];
Target1 = ["Err_C100","Err_C200","Err_C500","Err_C1000"];
Target2 = ["RSME_a_A100","RSME_a_A200","RSME_a_A500","RSME_a_A1000"];
Output_num = [100, 200, 500, 1000];

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

FontSize = 14;
ax_FontSize = 10;
figure
for j = 1:4
    subplot(2,2,j)
    hold on
    for num=1:8
        Error_num = Error(Error.Driver==num&Error.isTest==0,:);
        plot(Input_num,Error_num{:,Target2(j)}(1:5),'-o')
        % scatter(0,Error_num{:,Target(j)}(5),30,'filled')
    end
    hold off
    ylim([0 0.05])
    xlim([-100 1100])
    xticks([100 200 500 1000])
    ax = gca;
    ax.FontSize = ax_FontSize;
    ylabel("RSME [-]",'FontSize',FontSize)
    xlabel('\Deltat [ms]','FontSize',FontSize)
    legend('off')
    box on
    title("t_s = "+Output_num(j)+" [ms]",'FontSize',FontSize)
end