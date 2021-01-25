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
v1 = 35/3.6;
v2 = 40/3.6;
v3 = 40/3.6;

s1 = 247;
s2 = 763;
s3 = 800;

% Precar 1-4
% v1 = 20/3.6;
% v2 = 30/3.6;
% v3 = 45/3.6;

% s1 = 13.5;
% s2 = 313.5;
% s3 = 800;

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

writetable(Station, "./map_data/map_UE_1_Precar3.xlsx");
