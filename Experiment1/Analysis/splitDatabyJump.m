function data = splitDatabyJump(data)
frameSize = 260; % max number of samples to keep around perturbation. 260 samples = 2s
% align all data to perturbation time
% figure out how many repetitions
Nblocks = data.Ntrials/60; % number of blocks (60 trials per block)

post = data.end - data.ipertonset;
pre = data.ipertonset - data.init;
maxPost = max(max(post),frameSize);
maxPre = max(max(pre),frameSize);

oo = ones(1,maxPost);
% Pre-allocate for speed
CrX_post = NaN*ones(data.Ntrials,maxPost);
CrY_post = CrX_post;
NrX_post = CrX_post;
NrY_post = CrX_post;

CrX_pre = NaN*ones(data.Ntrials,maxPre+1);
CrY_pre = CrX_pre;
NrX_pre = CrX_pre;
NrY_pre = CrX_pre;

for i=1:data.Ntrials
    % cursor
    %CrX_post(i,:) = [data.Cr{i}(data.ipertonset(i)+1:data.end(i),1)' NaN*oo(1:maxPost-post(i))];%ones(1,maxPost-post(i))];  
    CrX_post(i,1:post(i)) = data.Cr{i}(data.ipertonset(i)+1:data.end(i),1)';%ones(1,maxPost-post(i))]; 
    CrY_post(i,1:post(i)) = data.Cr{i}(data.ipertonset(i)+1:data.end(i),2)';%ones(1,maxPost-post(i))];
    CrX_pre(i,maxPre-pre(i)+1:end) = data.Cr{i}(data.init(i):data.ipertonset(i),1)';
    CrY_pre(i,maxPre-pre(i)+1:end) = data.Cr{i}(data.init(i):data.ipertonset(i),2)';
    
    % null-space
    NrX_post(i,1:(data.end(i)-data.ipertonset(i))) = data.Nr{i}(data.ipertonset(i)+1:data.end(i),1)';%ones(1,maxPost-post(i))];
    NrY_post(i,1:(data.end(i)-data.ipertonset(i))) = data.Nr{i}(data.ipertonset(i)+1:data.end(i),2)';%ones(1,maxPost-post(i))];
    NrX_pre(i,maxPre-pre(i)+1:end) = data.Nr{i}(data.init(i):data.ipertonset(i),1)';
    NrX_pre(i,maxPre-pre(i)+1:end) = data.Nr{i}(data.init(i):data.ipertonset(i),2)';

    
    pert_time(i,:) = data.time{i}(data.ipertonset(i));
    %time_pre(i,:) = [NaN*ones(1,maxPre-pre(i)) (data.time{i}(data.init(i):data.ipertonset(i),1)'-data.time{i}(data.ipertonset(i)))];
    
end

CrX_post = CrX_post(:,1:frameSize);
CrY_post = CrY_post(:,1:frameSize);
CrX_pre = CrX_pre(:,end-frameSize+1:end);
CrY_pre = CrY_pre(:,end-frameSize+1:end);

NrX_post = NrX_post(:,1:frameSize);
NrY_post = NrY_post(:,1:frameSize);
NrX_pre = NrX_pre(:,end-frameSize+1:end);
NrY_pre = NrY_pre(:,end-frameSize+1:end);

% split data into subsets organized by jump type
psize = [-.03 -.015 0 .015 .03 NaN];

% figure out which targets NEVER jumped
pertAll = reshape(data.tFile(:,4),60,Nblocks); % align all similar trials across blocks
nopert = sum(abs(pertAll),2)==0; % index of trials which never jumped
nopert = repmat(nopert,Nblocks,1); % figure out overall trial number for each no perturbation trial
inopert = find(nopert); % trials that were not perturbed
data.pert(inopert)=NaN; % NaN out trials that are never perturbed

for p=1:length(psize)
    
    if(~isnan(psize(p)))
        ip = find(data.pert==psize(p)); % trials with perturbation size i
    else
        ip = find(isnan(data.pert)); % trials with no perturbation
    end
    
    % get cursor trajectory on these trials
    dd{p}.CrX_pre = CrX_pre(ip,:);
    dd{p}.CrX_post = CrX_post(ip,:);
    dd{p}.CrY_pre = CrY_pre(ip,:);
    dd{p}.CrY_post = CrY_post(ip,:);
    %dd{i}.CrX = [CrX_pre(ip,:) CrX_post(ip,:)];
    %dd{i}.CrY = [CrY_pre(ip,:) CrY_post(ip,:)];
    
    % null-space trajectory
    dd{p}.NrX_pre = NrX_pre(ip,:);
    dd{p}.NrX_post = NrX_post(ip,:);
    dd{p}.NrY_pre = NrY_pre(ip,:);
    dd{p}.NrY_post = NrY_post(ip,:);
    %dd{i}.NrX = [NrX_pre(ip,:) NrX_post(ip,:)];
    %dd{i}.NrY = [NrY_pre(ip,:) NrY_post(ip,:)];
    
    % event times for alignment
    dd{p}.pert_time = pert_time(ip);
    %dd{i}.time_post = meanNaN(time_post);
    %dd{i}.time_pre = meanNaN(time_pre);
    %dd{i}.time = meanNaN([time_pre time_post]);
    
    % additional data
    dd{p}.RT = data.RT(ip);
    dd{p}.pathlength = data.pathlength(ip);
    dd{p}.pathlength_null = data.pathlength_null(ip);
    dd{p}.movtime = data.movtime(ip);
    dd{p}.pkVel = data.pkVel(ip);
    dd{p}.pkVel_1s = data.pkVel_1s(ip);
    dd{p}.initDir = data.initDir(ip);
end

data = dd;