clear
close all
% Precar 1-1
% v1 = 40/3.6;
% v2 = 30/3.6;
% v3 = 45/3.6;

% s1 = 14.5;
% s2 = 600;
% s3 = 1000;

% Precar 1-2
% v1 = 20/3.6;
% v2 = 45/3.6;
% v3 = 60/3.6;

% s1 = 14.5;
% s2 = 314.5;
% s3 = 1114.5;

% % Precar 1-3
% v1 = 35/3.6;
% v2 = 40/3.6;
% v3 = 40/3.6;

% s1 = 247;
% s2 = 763;
% s3 = 800;

% Precar 1-4
% v1 = 20/3.6;
% v2 = 30/3.6;
% v3 = 45/3.6;

% s1 = 13.5;
% s2 = 313.5;
% s3 = 800;

% Precar 2-1
% v1 = 30/3.6;
% v2 = 30/3.6;
% v3 = 30/3.6;

% s1 = 10;
% s2 = 310;
% s3 = 550;

% % Precar 2-2
% v1 = 50/3.6;
% v2 = 50/3.6;
% v3 = 70/3.6;

% s1 = 363.5;
% s2 = 663.5;
% s3 = 800;

% % Precar 2-3
% v1 = 40/3.6;
% v2 = 40/3.6;
% v3 = 30/3.6;

% s1 = 11.4;
% s2 = 524.4;
% s3 = 824;

% % Precar 2-4
v1 = 60/3.6;
v2 = 50/3.6;
v3 = 65/3.6;

s1 = 11.6;
s2 = 509.8;
s3 = 1109.8;

Time = (0 : 0.025 : 100).';
dT = 0.025;

Station = array2table(Time);
Station.S = zeros(height(Station),1);


for i = 2 : height(Station)
    if Station.S(i-1) < s1 - 15
        v = v1;
    elseif Station.S(i-1) < s1 + 15
        v = 20/3.6;
    elseif Station.S(i-1) < s2 - 15
        v = v2;
    elseif Station.S(i-1) < s2 + 15
        v = 20/3.6;
    elseif Station.S(i-1) < s3
        v = v3;
    elseif Station.S(i-1) > s3
        break;
    end

    Station.S(i) = Station.S(i-1) + dT*v;
end

writetable(Station, "./map_data/map_UE_2_Precar4.xlsx");
