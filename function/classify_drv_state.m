function [drv_state] = classify_drv_state(drv_data, d_thres, v_thres)
    % add variables
    drv_data.ExistPrecar = drv_data.ExistPrecar==1 & drv_data.distance_P<100;
    drv_data.distance = drv_data.distance_P - 1000*(1-drv_data.ExistPrecar);
    drv_data.v_dif_lim = - drv_data.Speed + drv_data.Speed_lim;
    drv_data.v_dif_pre = - drv_data.Speed + drv_data.Speed_P + 100*(1-drv_data.ExistPrecar);
    drv_data.v_dif = min(drv_data.v_dif_lim, drv_data.v_dif_pre);

    drv_state = strings(height(drv_data), 1);
    for i = 1 : height(drv_data)
        if (drv_data.Bk_Stat(i) == 1 & abs(drv_data.Speed(i) < 5))
            drv_state(i) = "Stop";
        elseif(drv_data.Bk_Stat(i) == 1 | drv_data.distance_C(i)<100)
            drv_state(i) = "Braking";
        elseif (drv_data.distance(i) > d_thres | drv_data.v_dif(i) > v_thres)
            drv_state(i) = "Accelerate";
        else
            drv_state(i) = "Cruise";
        end
    end
end
