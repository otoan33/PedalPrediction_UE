function [ Error ] = MULTICrossEntropyError(predict, label)
    % predict_true = predict(~isnan(predict)&~isnan(label));
    % label_true = label(~isnan(predict)&~isnan(label));
    tmp = 0;
    for i = 1: size(predict, 1)
        tmp = tmp - log_min(predict(i,label(i)));
    end
    Error = tmp / size(predict, 1);
end

function [ value ] = log_min(x)
    value = log(max(x, 1.0e-10));
end


