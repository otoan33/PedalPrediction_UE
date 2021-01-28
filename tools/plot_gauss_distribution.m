function [plot_result] = plot_gauss_distribution(P0, Pr, Pa, Amount, Thr)
    FontSize = 30;
    ax_FontSize = 30;

    figure 
    x = [-1:.005:1];
    y0 = P0 * normpdf(x, 0, sqrt(1/(2*pi))/100);
    yr = Pr * normpdf(x, -1 * Thr, sqrt(1/(2*pi))/100);
    ya = Pa * normpdf(x, 1 * Amount, 3/100);
    y = y0 + yr + ya;
    plot_tmp = plot(x,y,'LineWidth',2);
    ylabel({'Probability [%]'},'FontSize',FontSize)
    xlabel('\DeltaThr [-]','FontSize',FontSize)
    xticks([-1 -0.5 0 0.5 1])
    ylim([0 max(y)*1.1])
    %ylim([0 1])
    ax = gca;
    ax.FontSize = ax_FontSize;

    plot_result = plot_tmp;
