% plot improvement in initial direction over time
clear all

%load BimanualSkillData
subjNum = 5;
fname = fullfile('../../../','Expt1_data',['BimanualSkillData_S',num2str(subjNum)])
load(fname)
%
%Unimanual

targetDir = data.Uni{1}.targAng*180/pi;
reachDir = targetDir'+data.Uni{1}.initDir;
reachDir(reachDir>180) = reachDir(reachDir>180)-360;
reachDir(reachDir<-180) = reachDir(reachDir<-180)+360;

f = figure(51); clf; hold 
set(f,'Position',[200 200 1400 900])
set(f,'Color','w')

subplot(2,3,1); hold on
plot(targetDir,reachDir,'o')
plot([-180 180],[-180 180],'k')
axis equal
    xlabel('target angle')
ylabel('initial reach angle')
% colormap
bins = -180:10:180; % 5 degree bins
Nbins = length(bins);
P = zeros(Nbins-1,Nbins-1);
N = P;
for b=1:Nbins-1
    ibin = find((targetDir>bins(b)) & (targetDir<bins(b+1)));
    for bb = 1:Nbins-1
        ii = find(reachDir(ibin)>bins(bb) & reachDir(ibin)<bins(bb+1));
        P(b,bb) = length(ii)/length(ibin);
        N(b,bb) = length(ii);
    end
end
Pj = N/sum(sum(N)); % estimated joint probability distribution
subplot(2,3,4); hold on
imagesc(P')
axis equal
        xlabel('target angle')
ylabel('initial reach angle')

% Bimanual - Early
targetDir = data.Bi{1}.targAng*180/pi;
reachDir = targetDir'+data.Bi{1}.initDir;
reachDir(reachDir>180) = reachDir(reachDir>180)-360;
reachDir(reachDir<-180) = reachDir(reachDir<-180)+360;

%f = figure(3); clf; hold 
%set(f,'Position',[600 200 600 500])
%set(f,'Color','w')
subplot(2,3,2); hold on
plot(targetDir,reachDir,'o')
plot([-180 180],[-180 180],'k')
axis equal
xlabel('target angle')
ylabel('initial reach angle')

% colormap
bins = -180:10:180; % 5 degree bins
Nbins = length(bins);
P = zeros(Nbins-1,Nbins-1);
N = P;
for b=1:Nbins-1
    ibin = find((targetDir>bins(b)) & (targetDir<bins(b+1)));
    for bb = 1:Nbins-1
        ii = find(reachDir(ibin)>bins(bb) & reachDir(ibin)<bins(bb+1));
        P(b,bb) = length(ii)/length(ibin);
        N(b,bb) = length(ii);
    end
end
Pj = N/sum(sum(N)); % estimated joint probability distribution
subplot(2,3,5); hold on
imagesc(P')
axis equal
xlabel('target angle')
ylabel('initial reach angle')
% Bimanual - Late

targetDir = data.Bi{7}.targAng*180/pi;
reachDir = targetDir'+data.Bi{7}.initDir;
reachDir(reachDir>180) = reachDir(reachDir>180)-360;
reachDir(reachDir<-180) = reachDir(reachDir<-180)+360;

% f = figure(3); clf; hold 
% set(f,'Position',[600 200 600 500])
% set(f,'Color','w')
subplot(2,3,3); hold on
plot(targetDir,reachDir,'o')
plot([-180 180],[-180 180],'k')
axis equal
xlabel('target angle')
ylabel('initial reach angle')
% colormap
bins = -180:10:180; % 5 degree bins
Nbins = length(bins);
P = zeros(Nbins-1,Nbins-1);
N = P;
for b=1:Nbins-1
    ibin = find((targetDir>bins(b)) & (targetDir<bins(b+1)));
    for bb = 1:Nbins-1
        ii = find(reachDir(ibin)>bins(bb) & reachDir(ibin)<bins(bb+1));
        P(b,bb) = length(ii)/length(ibin);
        N(b,bb) = length(ii);
    end
end
Pj = N/sum(sum(N)); % estimated joint probability distribution
subplot(2,3,6); hold on
imagesc(P')
axis equal
xlabel('target angle')
ylabel('initial reach angle')
%% Estimate Mutual Information
bins = -180:10:180; % 5 degree bins

    
for subj = 1:13
    fname = fullfile('../../../','Expt1_data',['BimanualSkillData_S',num2str(subj)])
    load(fname)
    
    % de novo
    for i=1:7
        targetDir = data.Bi{i}.targAng*180/pi;
        reachDir = targetDir'+data.Bi{i}.initDir;
        [MI(subj,i) H_joint(subj,i) H_targ(subj,i) H_action(subj,i)] = get_MI(targetDir,reachDir,bins);
    end
    
    % baseline
    targetDir = data.Uni{1}.targAng*180/pi;
    reachDir = targetDir'+data.Uni{1}.initDir;
    [MI_BSL(subj) H_joint_BSL(subj) H_targ_BSL(subj) H_action_BSL(subj)] = get_MI(targetDir,reachDir,bins);
end

%% plot information metrics
f = figure(40); clf; hold on
    set(f,'Position',[200 600 1300 400])
    set(f,'Color','w')
    
for subj = 1:13
    subplot(2,7,subj); hold on
    title(['Subj ',num2str(subj)]);
    plot(MI(subj,:),'bo-','linewidth',2)
    plot([1 7],MI_BSL(subj)*[1 1],'k','linewidth',2)
    ylabel('MI')
    ylim([1 2.6])
end


f = figure(41); clf; hold on
    set(f,'Position',[200 0 1300 400])
    set(f,'Color','w')
for subj = 1:13
    subplot(2,7,subj); hold on
    title(['Subj ',num2str(subj)]);
    plot(H_joint(subj,:),'bo-','linewidth',2)
    plot(H_targ(subj,:),'go-','linewidth',2)
    plot(H_action(subj,:),'ro-','linewidth',2)
    plot([1 7],H_joint_BSL(subj)*[1 1],'b--','linewidth',2)
    plot([1 7],H_targ_BSL(subj)*[1 1],'g--','linewidth',2)
    plot([1 7],H_action_BSL(subj)*[1 1],'r--','linewidth',2)
    ylim([2 5.5])

end
    legend('joint','target','action')
%%
figure(42); clf; hold on
 set(f,'Position',[300 100 600 300])
    set(f,'Color','w')
set(f,'Color','w')

    plot(mean(MI),'bo-','linewidth',2)
    plot([1 7],mean(MI_BSL)*[1 1],'k','linewidth',2)
    xlabel('Block')
    ylabel('Target-Action MI')