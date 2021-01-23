function [ Error ] = RMSE(predict, label)
    index = ~isnan(label);
    Error = sqrt(mean((predict(index) - label(index)).^2));  % Root Mean Squared Error
end