function [drv_state] = classify_drv_state(drv_data, d_thres, v_thres, thr_thres)
drv_state = strings(height(drv_data), 1);
for i = 1 : height(drv_data)
    if (drv_data.Bk_Stat(i) == 1 & abs(drv_data.Speed(i) < 5))
        drv_state(i) = "Stop";
    elseif(drv_data.Bk_Stat(i) == 1)
        drv_state(i) = "Braking";
    elseif (drv_data.Thr(i) > thr_thres)
        drv_state(i) = "Cruise";
    elseif (drv_data.distance(i) > d_thres)
        drv_state(i) = "Accelerate";
    elseif (drv_data.v_dif(i) < v_thres)
        drv_state(i) = "Accelerate";
    else
        drv_state(i) = "Cruise";
    end
end
