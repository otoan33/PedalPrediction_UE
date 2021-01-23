%% Plot drv_table grouping driving_state
% close all


% Plot results of logistic regression for Action/no Action
% for i = 2%:2
%     for j = 1:4
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
% for i = 2
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


%% Plot results of "Amount" predict model by multiple regression
for i = 2%:2
    for j = 1:4
        idx = join(['Thr_dif_', num2str(d(j))]);
        figure
        axis equal
        hold on
        title({'result of l"Amount" predict model by multiple regression'; drv_states(i) + ', ' + d(j) + ' ms'},'FontSize',15)
        scatter(training_data_amount{i,j}{:,idx},pred_training_amount{i,j},5)
        hline = refline([1 0]);
        hline.Color = 'k';
        hline.LineStyle = ':';
        hline.HandleVisibility = 'off';
        hold off
    end
end

clearvars i j idx