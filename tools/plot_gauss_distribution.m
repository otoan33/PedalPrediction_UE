function [plot_result] = plot_gauss_distribution(P0, Pr, Pa, Amount, Thr)
    FontSize = 30;
    ax_FontSize = 30;

    figure 
    x = [-100:.5:100];
    y0 = P0 * normpdf(x, 0, sqrt(1/(2*pi)));
    yr = Pr * normpdf(x, -100 * Thr, sqrt(1/(2*pi)));
    ya = Pa * normpdf(x, 100 * Amount, 3);
    y = y0 + yr + ya;
    plot_tmp = plot(x,y,'LineWidth',2);
    ylabel({'Probability [-]'},'FontSize',FontSize)
    xlabel('Action [%]','FontSize',FontSize)
    xticks([-100 -50 0 50 100])
    ylim([0 max(y)*1.1])
    %ylim([0 1])
    ax = gca;
    ax.FontSize = ax_FontSize;

    plot_result = plot_tmp;
