close all

% drv_origin = readtable("./02_drv_table_combined/UE1/drv_table_combined_Driver_03.csv");
% drv=drv_origin(1:40*500,:);
% drv=drv(abs(drv.Steer_SW)<50,:);
% drv=drv(drv.Road_num~=0,:);


% drv_brk = drv(drv.Bk_Stat==1,:);
% drv_notbrk = drv(drv.Bk_Stat==0,:);

% Bk_Stat=drv.Bk_Stat;

% Bk_Stat1 = (drv.Thr==0)&drv.Accel<-0.06;
% % Bk_Stat2 = drv.distance_C<50;
% % Bk_Stat1 = Bk_Stat1 | Bk_Stat2;

% figure
% scatter(drv(Bk_Stat==1,:).Speed,drv(Bk_Stat==1,:).Accel)

% figure
% hold on
% % scatter(drv(Bk_Stat1==1 & Bk_Stat==1,:).Speed,drv(Bk_Stat1==1 & Bk_Stat==1,:).Accel,'b')
% scatter(drv(Bk_Stat1==0 & Bk_Stat==1,:).Speed,drv(Bk_Stat1==0 & Bk_Stat==1,:).Accel,'r')
% scatter(drv(Bk_Stat1==1 & Bk_Stat==0,:).Speed,drv(Bk_Stat1==1 & Bk_Stat==0,:).Accel,'g')
% hold off

% figure
% hold on
% % scatter(drv(Bk_Stat1==1 & Bk_Stat==1,:).Time,drv(Bk_Stat1==1 & Bk_Stat==1,:).Speed,'b')
% scatter(drv(Bk_Stat1==0 & Bk_Stat==1,:).Time,drv(Bk_Stat1==0 & Bk_Stat==1,:).Speed,'r')
% scatter(drv(Bk_Stat1==1 & Bk_Stat==0,:).Time,drv(Bk_Stat1==1 & Bk_Stat==0,:).Speed,'g')
% hold off

% figure
% hold on
% % scatter(drv(Bk_Stat1==1 & Bk_Stat==1,:).Time,drv(Bk_Stat1==1 & Bk_Stat==1,:).Accel,'b')
% scatter(drv(Bk_Stat1==0 & Bk_Stat==1,:).Time,drv(Bk_Stat1==0 & Bk_Stat==1,:).Accel,'r')
% scatter(drv(Bk_Stat1==1 & Bk_Stat==0,:).Time,drv(Bk_Stat1==1 & Bk_Stat==0,:).Accel,'g')
% hold off

% figure
% hold on
% % scatter(drv(Bk_Stat1==1 & Bk_Stat==1,:).Time,drv(Bk_Stat1==1 & Bk_Stat==1,:).Steer_SW,'b')
% scatter(drv(Bk_Stat1==0 & Bk_Stat==1,:).Time,drv(Bk_Stat1==0 & Bk_Stat==1,:).Steer_SW,'r')
% scatter(drv(Bk_Stat1==1 & Bk_Stat==0,:).Time,drv(Bk_Stat1==1 & Bk_Stat==0,:).Steer_SW,'g')
% hold off

% figure
% hold on
% % scatter(drv(Bk_Stat1==1 & Bk_Stat==1,:).Time,drv(Bk_Stat1==1 & Bk_Stat==1,:).distance_C,'b')
% scatter(drv(Bk_Stat1==0 & Bk_Stat==1,:).Time,drv(Bk_Stat1==0 & Bk_Stat==1,:).distance_C,'r')
% scatter(drv(Bk_Stat1==1 & Bk_Stat==0,:).Time,drv(Bk_Stat1==1 & Bk_Stat==0,:).distance_C,'g')
% hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

drv_origin = readtable("./02_drv_table_combined/UE1/drv_table_combined_Driver_01.csv");
drv=drv_origin(1:40*500,:);

drv.Bk_Stat = (drv.Thr==0)&drv.Accel<-0.07;

figure
gscatter(drv.Time,drv.Speed,Bk_Stat1)


