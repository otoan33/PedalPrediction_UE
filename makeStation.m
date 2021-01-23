clear
close all

v1 = 40/3.6;
v2 = 30/3.6;
v3 = 45/3.6;

s1 = 400;
s2 = 600;
s3 = 1000;

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
