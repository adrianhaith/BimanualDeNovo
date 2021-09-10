function [data] = loadSubjData_old(subjname,blocknames)
% load a single subject's timed response target jump data
%
% experiment states (d(:,7))
%   1. 
%   2. 
%   3. 
%   4.
%   5.
%   6.
%   7. 
%   8.
Pwidth = .94;
Pheight = Pwidth*1080/1920;
LX = .6128;
LY = .1811;
RX = .6462;
RY = .1617;
START_X = .6;
START_Y = .35;

Nblocks = length(blocknames);
trial = 1;
tFileFull = [];
for blk=1:Nblocks
    %disp(['Subject ',subjname,', ','Block: ',blocknames(blk)]);
    path = [subjname,'/',blocknames{blk}];
    %disp(path);
    tFile = dlmread([path,'/tFile.tgt'],' ',0,0);
    fnames = dir(path);
    Ntrials = size(tFile,1);
    for j=1:Ntrials
        disp([path,'/',fnames(j+2).name]);
        d = dlmread([path,'/',fnames(j+2).name],' ',6,0);
        % uncalibrated
        L{trial} = d(:,1:2); % left hand X
        %L{trial} = d(1:2:end,4); % left hand Y
        R{trial} = d(:,3:4); % right hand X
        %R{trial,2} = d(2:2:end,4); % right hand Y
        C{trial} = d(:,5:6);% - repmat([.5,.35],size(d,1),1);
        N{trial} = [L{trial}(:,1) R{trial}(:,2)]; % null space movements
        % calibrated
        %Lc{trial}(:,1) = (d(1:2:end,2)-LX)*Pwidth/(RX-LX); % left hand X
        %Lc{trial}(:,2) = (d(1:2:end,3)-LY)*Pheight/(RY-LY); % left hand Y
        %Rc{trial}(:,1) = (d(2:2:end,2)-LX)*Pwidth/(RX-LX); % right hand X
        %Rc{trial}(:,2) = (d(2:2:end,3)-LY)*Pheight/(RY-LY); % right hand Y
        
        %C{trial}(:,1) = Lc{trial}(:,2);
        %C{trial}(:,2) = Rc{trial}(:,1);
        
        targetAbs(trial,1) = tFile(j,2)+START_X;
        targetAbs(trial,2) = tFile(j,3)+START_Y;
        
        if(j>1)
            start(trial,:) = targetAbs(trial-1,:);    
        else
            start(trial,:) = [START_X START_Y];
        end
        targetRel(trial,:) = targetAbs(trial,:)-start(trial,:);
        pert(trial) = tFile(j,4);
        
        ip = find(d(:,8));
        if(isempty(ip))
            ipertonset(trial) = NaN;
        else
            ipertonset(trial) = min(ip);
        end
        imov = find(d(:,7)==4); % time points at which
        if(isempty(imov))
            imoveonset = 1;
        else
            imoveonset(trial) = min(imov);
        end        
        state{trial} = d(:,7);
        time{trial} = d(:,9);
        
        trial = trial+1;
    end
    tFileFull = [tFileFull; tFile(:,1:5)];
end
Lc = L;
Rc = R;
%keyboard
% compute target angle
data.targAng = atan2(targetRel(:,2),targetRel(:,1));
data.targDist = sqrt(sum(targetRel(:,1:2)'.^2));
%data.target = mod(ceil(targAng*4/pi - .01),8); % target number

%targAngPost = atan2(target_post(:,2)-start(:,2),target_post(:,1)-start(:,1));
%data.target2 = mod(ceil(targAngPost*4/pi - .01),8);
data.L = L;
data.R = R;
data.C = C;
data.N = N;
data.Lc = Lc;
data.Rc = Rc;

data.Ntrials = size(targetRel,1);
data.tFile = tFileFull;
data.pert = pert;

data.state = state;
data.time = time;
data.ipertonset = ipertonset;
data.imoveonset = imoveonset;

data.subjname = subjname;
data.blocknames = blocknames;

d0 = 0;
data.rPT = d0;
data.reachDir = d0;
data.d_dir = d0;
data.RT = d0;
data.iDir = d0;
data.iEnd = d0;

data.targetAbs = targetAbs;
data.targetRel = targetRel;
data.start = start;

% rotate data
%
for j=1:data.Ntrials % iterate through all trials
    theta(j) = atan2(data.targetRel(j,2),data.targetRel(j,1))-pi/2;
    R = [cos(theta(j)) sin(theta(j)); -sin(theta(j)) cos(theta(j))];
    %R = eye(2);
    
    data.Cr{j} = (R*(data.C{j}'-repmat(start(j,:),size(data.C{j},1),1)'))';
    data.Nr{j} = (R*(data.N{j}'))';
    
    % test rotation
    if(0)
     figure(1); clf; hold on
     %plot(data.C{j}(:,1),data.C{j}(:,2),'g')
     %plot(data.C{j}(1,1),data.C{j}(1,2),'g.','markersize',18)
     plot(data.Cr{j}(:,1),data.Cr{j}(:,2),'b')
     plot(data.Cr{j}(1,1),data.Cr{j}(1,2),'b.','markersize',18)
     plot(0,data.targDist(j),'ro')
     plot([0 pert(j)],data.targDist(j)*[1 1],'r')
     %plot(start(j,1),start(j,2),'mo')
     axis equal
     pause
    end
    

end
data.theta = theta;
%data = getErr_fixedT(data);
%}

