function [ Error ] = CrossEntropyError(predict, label)
    predict_true = predict(~isnan(predict)&~isnan(label));
    label_true = label(~isnan(predict)&~isnan(label));
    tmp = 0;
    for i = 1: size(predict_true, 2)
        tmp = tmp - ( label_true(i)*log_min(predict_true(i)) + (1-label_true(i)) * log_min(1-predict_true(i)) );
    end
    Error = tmp / size(predict_true, 2);
end


function [ Error ] = MultiCrossEntropyError(predict, label)
    % predict_true = predict(~isnan(predict)&~isnan(label));
    % label_true = label(~isnan(predict)&~isnan(label));
    tmp = 0;
    for i = 1: size(predict, 1)
        tmp = tmp - log_min(pihat(i,label(i)));
    end
    Error = tmp / size(predict, 1);
end

function [ value ] = log_min(x)
    value = log(max(x, 1.0e-10));
end


