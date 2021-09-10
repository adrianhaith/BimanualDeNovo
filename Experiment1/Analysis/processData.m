function data = processCursorData(data)
% analyze cursor data for path length, RT, etc

Lall = [];
Rall = [];
for i=1:data.Ntrials
    data.Cr{i} = savgolayFilt(data.Cr{i}',3,7)';
    data.Nr{i} = savgolayFilt(data.Nr{i}',3,7)';
    
    data.vel{i} = diff(data.Cr{i})*130;
    data.tanVel{i} = sqrt(sum(data.vel{i}.^2,2));
    data.pkVel(i) = max(data.tanVel{i});
    data.pkVel_1s(i) = max(data.tanVel{i}(1:min(length(data.tanVel{i}),500)));
    
    if(~isempty(find(data.state{i}==3)))
        data.go(i) = min(find(data.state{i}==3));
    else
        data.go(i) = 10;
    end
        
    if(~isempty(find(data.state{i}==4)))
        data.init(i) = min(find(data.state{i}==4));
        data.end(i) = max(find(data.state{i}==4));
    else
        data.init(i) = 100;
        data.end(i) = 200;
    end
        
        
        data.RT(i) = data.time{i}(data.init(i))-data.time{i}(data.go(i));
        data.movtime(i) = data.time{i}(data.end(i))-data.time{i}(data.init(i));
        
        dpath = diff(data.Cr{i}(1:data.end(i),:));
        dL = sqrt(sum(dpath.^2,2));
        data.pathlength(i) = sum(dL);
        
        dpath_null = diff(data.Nr{i}(1:data.end(i),:));
        dL = sqrt(sum(dpath_null.^2,2));
        data.pathlength_null(i) = sum(dL);
        
        %vel = diff(data.Cr{i})*130;
        data.iDir(i) = data.init(i)+13; % 100 ms after initiation
        data.initDir(i) = atan2(data.vel{i}(data.iDir(i),2),data.vel{i}(data.iDir(i),1))*180/pi - 90;
        if(data.initDir(i)>180)
            data.initDir(i) = data.initDir(i)-180;
        elseif(data.initDir(i)<-180)
            data.initDir(i) = data.initDir(i)+180;
        end
        
    
%     else
%         data.go(i) = NaN;
%         data.initDir(i) = NaN;
%         data.iDir(i) = NaN;
%         data.pathlength_null(i) = NaN;
%         data.RT(i) = NaN;
%         data.movtime(i) = NaN;
%         data.init(i) = NaN;
%         data.end(i) = NaN;
%         data.pathlength(i) = NaN;
%     end
    %Lall = [Lall; data.L{i}];
    %Rall = [Rall; data.R{i}];
end

data.yoking = 0;%corr(Lall,Rall);