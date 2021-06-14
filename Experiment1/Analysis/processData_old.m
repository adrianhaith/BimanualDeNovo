function data = processCursorData(data)
% analyze cursor data for path length, RT, etc

Lall = [];
Rall = [];
for i=1:data.Ntrials
    data.Cr{i} = savgolayFilt(data.Cr{i}',3,7)';
    data.Nr{i} = savgolayFilt(data.Nr{i}',3,7)';
    
    yvel = diff(data.Cr{i});
    data.pkVel(i) = max(sum(yvel.^2,2))^.5;
    data.pkVel_1s(i) = max(sum(yvel(1:130,:).^2,2))^.5;
    
    data.go(i) = min(find(data.state{i}==3));
    data.init(i) = min(find(data.state{i}==4));
    data.end(i) = max(find(data.state{i}==4));
    
    data.RT(i) = data.time{i}(data.init(i))-data.time{i}(data.go(i));
    data.movtime(i) = data.time{i}(data.end(i))-data.time{i}(data.init(i));
    
    dpath = diff(data.Cr{i}(1:data.end(i),:));
    dL = sqrt(sum(dpath.^2,2));
    data.pathlength(i) = sum(dL);
    
    dpath_null = diff(data.Nr{i}(1:data.end(i),:));
    dL = sqrt(sum(dpath_null.^2,2));
    data.pathlength_null(i) = sum(dL);
    
    data.iDir(i) = data.init(i)+13; % 100 ms after initiation
    data.initDir(i) = atan2(vel(data.iDir(i),2),vel(data.iDir(i),1));
    
    
    Lall = [Lall; data.L{i}];
    Rall = [Rall; data.R{i}];
end

data.yoking = corr(Lall,Rall);