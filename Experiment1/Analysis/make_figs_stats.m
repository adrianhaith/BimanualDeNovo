% Bimanual Skill Paper - Make all figures and run all stats
clear all
clc
load Bimanual_compact

%% Initial performance stats

%eliminate outliers
dAll.BiInit.all_dur = reshape(dAll.BiInit.movDur,1,[]);
dAll.BiInit.meanDur_all = nanmean(dAll.BiInit.all_dur);
dAll.BiInit.stdDur_all = nanstd(dAll.BiInit.all_dur);

% omit trials more than 3 SDs away from the mean
cutoff = dAll.BiInit.meanDur_all + 3*dAll.BiInit.stdDur_all;
allDur = dAll.BiInit.movDur;
tooLong = allDur>cutoff;
allDur(tooLong) = NaN; 

dAll.BiInit.meanDur = nanmean(allDur);
dAll.BiInit.meanDur_av = mean(dAll.BiInit.meanDur);
dAll.BiInit.meanDur_std = std(dAll.BiInit.meanDur);


% same analysis for unimanual baseline
dAll.UniNoJmp.all_dur = reshape(dAll.UniNoJmp.movDur(:,1:60),1,[]);
dAll.UniNoJmp.meanDur_all = nanmean(dAll.UniNoJmp.all_dur);
dAll.UniNoJmp.stdDur_all = nanstd(dAll.UniNoJmp.all_dur);

% omit trials more than 3 SDs away from the mean
cutoff_Uni = dAll.UniNoJmp.meanDur_all + 3*dAll.UniNoJmp.stdDur_all;
allDur_Uni = dAll.UniNoJmp.movDur;
tooLong_Uni = allDur_Uni>cutoff_Uni;
allDur_Uni(tooLong_Uni) = NaN; 

dAll.UniNoJmp.meanDur = nanmean(allDur_Uni);
dAll.UniNoJmp.meanDur_av = mean(dAll.UniNoJmp.meanDur);
dAll.UniNoJmp.meanDur_std = std(dAll.UniNoJmp.meanDur);



%--- path length ---
% Bimanual
pathlength_all_Bi = dAll.BiInit.pathLength;
pathlength_all_Bi(tooLong) = NaN; % exclude outlier trials
dAll.BiInit.mean_pathLength = nanmean(pathlength_all_Bi);
dAll.BiInit.mean_pathLength_av = mean(dAll.BiInit.mean_pathLength);
dAll.BiInit.mean_pathLength_std = std(dAll.BiInit.mean_pathLength);

% Unimanaul
pathlength_all_Uni = dAll.UniNoJmp.pathLength(:,1:60);
pathlength_all_Uni(tooLong) = NaN; % exclude outlier trials
dAll.UniNoJmp.mean_pathLength = nanmean(pathlength_all_Uni);
dAll.UniNoJmp.mean_pathLength_av = mean(dAll.UniNoJmp.mean_pathLength);
dAll.UniNoJmp.mean_pathLength_std = std(dAll.UniNoJmp.mean_pathLength);


% --- print output
disp(['Baseline performance:'])
disp(['    adjusted mean movement duration = ',num2str(dAll.UniNoJmp.meanDur_av),' +/- ',num2str(dAll.UniNoJmp.meanDur_std),' ms'])
disp(['    proportion of trials above cutoff = ',num2str(100*sum(sum(tooLong_Uni))/prod(size(tooLong_Uni))),'%'])
disp(['    path length = ',num2str(dAll.UniNoJmp.mean_pathLength_av),' +/- ',num2str(dAll.UniNoJmp.mean_pathLength_std)])
disp(['    tortuosity = ',num2str(dAll.UniNoJmp.mean_pathLength_av/.12),' +/- ',num2str(dAll.UniNoJmp.mean_pathLength_std/.12)])

disp(['First block performance:'])
disp(['    adjusted mean movement duration = ',num2str(dAll.BiInit.meanDur_av),' +/- ',num2str(dAll.BiInit.meanDur_std),' ms'])
disp(['    proportion of trials above cutoff = ',num2str(100*sum(sum(tooLong))/prod(size(tooLong))),'%'])
disp(['    path length = ',num2str(dAll.BiInit.mean_pathLength_av),' +/- ',num2str(dAll.BiInit.mean_pathLength_std)])
disp(['    tortuosity = ',num2str(dAll.BiInit.mean_pathLength_av/.12),' +/- ',num2str(dAll.BiInit.mean_pathLength_std/.12)])

%% performance after first practice chunk
disp(['End of Day 1 performance:'])
disp(['    movement duration: ',num2str(mean(dAll.Bi.movDur(:,5))),' +/- ',num2str(std(dAll.Bi.movDur(:,5)))])
disp(['    path length: ',num2str(mean(dAll.Bi.pathLength(:,5))),' +/- ',num2str(std(dAll.Bi.pathLength(:,5)))])
disp(['    tortuosity: ',num2str(mean(dAll.Bi.pathLength(:,5))/.12),' +/- ',num2str(std(dAll.Bi.pathLength(:,5))/.12)])

%% aftereffects analysis
disp([])
disp(['Aftereffects: tortuosity'])
disp(['    tortuosity, Uni1 = ',num2str(nanmean(nanmean(dAll.UniNoJmp.pathLength(:,1:60),2))),' +/- ',num2str(seNaN(nanmean(dAll.UniNoJmp.pathLength(:,1:60),2)))]);
disp(['    tortuosity, Uni2 = ',num2str(nanmean(nanmean(dAll.UniNoJmp.pathLength(:,61:120),2))),' +/- ',num2str(seNaN(nanmean(dAll.UniNoJmp.pathLength(:,61:120),2)))]);

    

%% Early learning
% path length, tortuosity, etc in final 
%{
fhandle = figure(1); clf; hold
set(fhandle,'Position',[200 200 800 500]);
set(fhandle,'Color','w');
set(fhandle,'Renderer','Painters');

subplot(2,2,1); hold on;
shadedErrorBar([1:size(dAll.Bi.pathLength,2)]+10,mean(dAll.Bi.pathLength)/.12,seNaN(dAll.Bi.pathLength)/.12,'b.-',1);
shadedErrorBar([1:size(dAll.Uni.pathLength,2)],mean(dAll.Uni.pathLength)/.12,seNaN(dAll.Uni.pathLength)/.12,'k.-',1);
plot([0 45],mean(mean(dAll.Uni.pathLength))*[1 1]/.12,'k')
plot([0 45],[1 1],'-','color',.5*[1 1 1])
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 2]/.12,'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 2]/.12,'k:')
axis([0 45 0 5])
xlabel('Block')
ylabel('Tortuosity')

subplot(2,2,2); hold on;
shadedErrorBar([1:size(dAll.Bi.RT,2)]+10,mean(dAll.Bi.RT),seNaN(dAll.Bi.RT),'b.-',1);
shadedErrorBar(1:size(dAll.Uni.RT,2),mean(dAll.Uni.RT),seNaN(dAll.Uni.RT),'k.-',1);
%plot(dAll.RT(s,:),'.-','linewidth',2)
%plot(dAll.Uni.RT(s,:),'k.-','linewidth',2)
plot([0 45],mean(mean(dAll.Uni.RT))*[1 1],'k')
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 1000],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 1000],'k:')
axis([0 45 0 600])
xlabel('Block')
ylabel('Reaction Time (ms)')

subplot(2,2,3); hold on;
shadedErrorBar([1:size(dAll.Bi.pkVel_1s,2)]+10,mean(dAll.Bi.pkVel_1s),seNaN(dAll.Bi.pkVel_1s),'b.-',1);
shadedErrorBar(1:size(dAll.Uni.pkVel_1s,2),mean(dAll.Uni.pkVel_1s),seNaN(dAll.Uni.pkVel_1s),'k.-',1);
%plot(dAll.pkVel(s,:),'.-','linewidth',2)
%plot(dAll.Uni.pkVel(s,:),'k.-','linewidth',2)
plot([0 45],mean(mean(dAll.Uni.pkVel_1s))*[1 1],'k')
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 1000],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 1000],'k:')
axis([0 45 0 .5])
xlabel('Block')
ylabel('Peak Velocity (m/s)')

subplot(2,2,4); hold on
shadedErrorBar([1:size(dAll.Bi.movDur,2)]+10,mean(dAll.Bi.movDur)/1000,seNaN(dAll.Bi.movDur)/1000,'b.-',1);
shadedErrorBar(1:size(dAll.Uni.movDur,2),mean(dAll.Uni.movDur)/1000,seNaN(dAll.Uni.movDur)/1000,'k.-',1);
plot([0 45],mean(mean(dAll.Uni.movDur))*[1 1]/1000,'k')
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 6],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 6],'k:')
axis([0 45 0 5])
xlabel('Block')
ylabel('Movement Duration (s)')
%}
%%
%% Early learning - alternative including inital block
% path length, tortuosity, etc in final 
%
fhandle = figure(11); clf; hold
set(fhandle,'Position',[200 200 900 565]);
set(fhandle,'Color','w');
set(fhandle,'Renderer','Painters');

rng1 = [1 8];
rng2 = [2:7];
rng3 = [8 8.2];
rng4 = [1:30]+8;
rng5 = [1:10]+38;

subplot(2,2,1); hold on;
shadedErrorBar(rng1,[mean(nanmean(dAll.UniNoJmp.pathLength(:,1:60),2)) mean(nanmean(dAll.UniNoJmp.pathLength(:,61:120),2))]/.12,seNaN([nanmean(dAll.UniNoJmp.pathLength(:,1:60),2) nanmean(dAll.UniNoJmp.pathLength(:,61:120),2)])/.12,'k.-',1);
shadedErrorBar(rng2,[mean(mean(dAll.BiInit.pathLength)) mean(dAll.Bi.pathLength(:,1:5))]/.12,[seNaN(mean(dAll.BiInit.pathLength,2)) seNaN(dAll.Bi.pathLength(:,1:5))]/.12,'b.-',1);
%shadedErrorBar(rng3,mean(nanmean(dAll.UniNoJmp.pathLength(:,61:120),2))/.12,[1 1]*seNaN(nanmean(dAll.UniNoJmp.pathLength(:,61:120),2))/.12,'k.-',1);
shadedErrorBar(rng4,mean(dAll.Bi.pathLength(:,6:end))/.12,seNaN(dAll.Bi.pathLength(:,6:end))/.12,'b.-',1);

shadedErrorBar(rng5,mean(dAll.Uni.pathLength)/.12,seNaN(dAll.Uni.pathLength)/.12,'k.-',1);

plot([0 48],mean(mean(dAll.Uni.pathLength))*[1 1]/.12,'k')
plot([0 48],[1 1],'-','color',.5*[1 1 1])
plot(repmat([8.5 18.5 28.5 38.5]',1,2),[0 1000],'k')
plot(repmat([13.5 23.5 33.5]',1,2),[0 1000],'k:')
axis([0 48 0 5.5])
xlabel('Block')
ylabel('Tortuosity')

subplot(2,2,2); hold on;
shadedErrorBar(rng1,mean([nanmean(dAll.UniNoJmp.RT(:,1:60),2) nanmean(dAll.UniNoJmp.RT(:,61:120),2)]),seNaN([nanmean(dAll.UniNoJmp.RT(:,1:60),2) nanmean(dAll.UniNoJmp.RT(:,61:120),2)]),'k.-',1);
shadedErrorBar(rng2,[mean(mean(dAll.BiInit.RT)) mean(dAll.Bi.RT(:,1:5))],[seNaN(mean(dAll.BiInit.RT,2)) seNaN(dAll.Bi.RT(:,1:5))],'b.-',1);
%shadedErrorBar(rng3,[1 1]*mean(nanmean(dAll.UniNoJmp.RT(:,61:120),2)),[1 1]*seNaN(nanmean(dAll.UniNoJmp.RT(:,61:120),2)),'k.-',1);
shadedErrorBar(rng4,mean(dAll.Bi.RT(:,6:end)),seNaN(dAll.Bi.RT(:,6:end)),'b.-',1);
shadedErrorBar(rng5,mean(dAll.Uni.RT),seNaN(dAll.Uni.RT),'k.-',1);
plot([0 48],mean(mean(dAll.Uni.RT))*[1 1],'k')
plot(repmat([8.5 18.5 28.5 38.5]',1,2),[0 1000],'k')
plot(repmat([13.5 23.5 33.5]',1,2),[0 1000],'k:')
axis([0 48 0 800])
xlabel('Block')
ylabel('Reaction Time (ms)')

subplot(2,2,3); hold on;
shadedErrorBar(rng1,mean([nanmean(dAll.UniNoJmp.pkVel_1s(:,1:60),2) nanmean(dAll.UniNoJmp.pkVel_1s(:,61:120),2)]),seNaN([nanmean(dAll.UniNoJmp.pkVel_1s(:,1:60),2) nanmean(dAll.UniNoJmp.pkVel_1s(:,61:120),2)]),'k.-',1);
shadedErrorBar(rng2,[mean(mean(dAll.BiInit.pkVel_1s)) mean(dAll.Bi.pkVel_1s(:,1:5))],[seNaN(mean(dAll.BiInit.pkVel_1s,2)) seNaN(dAll.Bi.pkVel_1s(:,1:5))],'b.-',1);
%shadedErrorBar(rng3,[1 1]*mean(nanmean(dAll.UniNoJmp.pkVel_1s(:,61:120),2)),[1 1]*seNaN(nanmean(dAll.UniNoJmp.pkVel_1s(:,61:120),2)),'k.-',1);
shadedErrorBar(rng4,mean(dAll.Bi.pkVel_1s(:,6:end)),seNaN(dAll.Bi.pkVel_1s(:,6:end)),'b.-',1);
shadedErrorBar(rng5,mean(dAll.Uni.pkVel_1s),seNaN(dAll.Uni.pkVel_1s),'k.-',1);
plot([0 48],mean(mean(dAll.Uni.pkVel_1s))*[1 1],'k')
plot(repmat([8.5 18.5 28.5 38.5]',1,2),[0 1000],'k')
plot(repmat([13.5 23.5 33.5]',1,2),[0 1000],'k:')
axis([0 48 0 .4])
xlabel('Block')
ylabel('Peak Velocity (m/s)')

subplot(2,2,4); hold on
shadedErrorBar(rng1,mean([nanmean(dAll.UniNoJmp.movDur(:,1:60),2) nanmean(dAll.UniNoJmp.movDur(:,61:120),2)])/1000,seNaN([nanmean(dAll.UniNoJmp.movDur(:,1:60),2) nanmean(dAll.UniNoJmp.movDur(:,61:120),2)])/1000,'k.-',1);
shadedErrorBar(rng2,[mean(mean(dAll.BiInit.movDur)) mean(dAll.Bi.movDur(:,1:5))]/1000,[seNaN(mean(dAll.BiInit.movDur,2)) seNaN(dAll.Bi.movDur(:,1:5))]/1000,'b.-',1);
%shadedErrorBar(rng3,[1 1]*mean(nanmean(dAll.UniNoJmp.movDur(:,61:120),2))/1000,[1 1]*seNaN(nanmean(dAll.UniNoJmp.movDur(:,61:120),2))/1000,'k.-',1);
shadedErrorBar(rng4,mean(dAll.Bi.movDur(:,6:end))/1000,seNaN(dAll.Bi.movDur(:,6:end))/1000,'b.-',1);
shadedErrorBar(rng5,mean(dAll.Uni.movDur)/1000,seNaN(dAll.Uni.movDur)/1000,'k.-',1);
plot([0 48],mean(mean(dAll.Uni.movDur))*[1 1]/1000,'k')
plot(repmat([8.5 18.5 28.5 38.5]',1,2),[0 1000],'k')
plot(repmat([13.5 23.5 33.5]',1,2),[0 1000],'k:')
axis([0 48 0 10])
xlabel('Block')
ylabel('Movement Duration (s)')
%}

%% Early learning
% path length, tortuosity, etc in final

% eliminate bad trial
dAll.UniNoJmp.pathLength(11,21) = NaN;
%{
fhandle = figure(1); clf; hold
set(fhandle,'Position',[200 200 800 500]);
set(fhandle,'Color','w');
set(fhandle,'Renderer','Painters');

subplot(2,2,1); hold on;
shadedErrorBar([1:size(dAll.Bi.pathLength,2)]+10,mean(dAll.Bi.pathLength)/.12,seNaN(dAll.Bi.pathLength)/.12,'b.-',1);
shadedErrorBar([1:size(dAll.Uni.pathLength,2)],mean(dAll.Uni.pathLength)/.12,seNaN(dAll.Uni.pathLength)/.12,'k.-',1);



plot([0 45],mean(mean(dAll.Uni.pathLength))*[1 1]/.12,'k')
plot([0 45],[1 1],'-','color',.5*[1 1 1])
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 2]/.12,'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 2]/.12,'k:')
axis([0 45 0 5])
xlabel('Block')
ylabel('Tortuosity')

subplot(2,2,2); hold on;
shadedErrorBar([1:size(dAll.Bi.RT,2)]+10,mean(dAll.Bi.RT),seNaN(dAll.Bi.RT),'b.-',1);
shadedErrorBar(1:size(dAll.Uni.RT,2),mean(dAll.Uni.RT),seNaN(dAll.Uni.RT),'k.-',1);
%plot(dAll.RT(s,:),'.-','linewidth',2)
%plot(dAll.Uni.RT(s,:),'k.-','linewidth',2)
plot([0 45],mean(mean(dAll.Uni.RT))*[1 1],'k')
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 1000],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 1000],'k:')
axis([0 45 0 600])
xlabel('Block')
ylabel('Reaction Time (ms)')

subplot(2,2,3); hold on;
shadedErrorBar([1:size(dAll.Bi.pkVel_1s,2)]+10,mean(dAll.Bi.pkVel_1s),seNaN(dAll.Bi.pkVel_1s),'b.-',1);
shadedErrorBar(1:size(dAll.Uni.pkVel_1s,2),mean(dAll.Uni.pkVel_1s),seNaN(dAll.Uni.pkVel_1s),'k.-',1);
%plot(dAll.pkVel(s,:),'.-','linewidth',2)
%plot(dAll.Uni.pkVel(s,:),'k.-','linewidth',2)
plot([0 45],mean(mean(dAll.Uni.pkVel_1s))*[1 1],'k')
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 1000],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 1000],'k:')
axis([0 45 0 .5])
xlabel('Block')
ylabel('Peak Velocity (m/s)')

subplot(2,2,4); hold on
shadedErrorBar([1:size(dAll.Bi.movDur,2)]+10,mean(dAll.Bi.movDur)/1000,seNaN(dAll.Bi.movDur)/1000,'b.-',1);
shadedErrorBar(1:size(dAll.Uni.movDur,2),mean(dAll.Uni.movDur)/1000,seNaN(dAll.Uni.movDur)/1000,'k.-',1);
plot([0 45],mean(mean(dAll.Uni.movDur))*[1 1]/1000,'k')
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 6],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 6],'k:')
axis([0 45 0 5])
xlabel('Block')
ylabel('Movement Duration (s)')
%}
%% stats on performance curves
disp('---- Basic Performance Metrics ----')
rng = 6:10;
rng2 = 31:35;
path_pre = mean(dAll.Bi.pathLength(:,rng)')';
path_post = mean(dAll.Bi.pathLength(:,rng2)')';
path_bsl = mean(dAll.Uni.pathLength(:,rng)')';
[t_path p_path] = ttest(path_pre,path_post,2,'paired');
[t_path_bsl p_path_bsl] = ttest(path_post,path_bsl,2,'paired');

% welch version for unequal variance
[t_path_W p_path_W] = ttest2(path_pre, path_post,'VarType','Unequal');
[t_path_bslW p_path_bsl] = ttest2(path_post,path_bsl,'VarType','Unequal');

disp(['Path Length Day 2-1 vs Day 4-2: p=',num2str(p_path),'; t=',num2str(t_path)]);
disp(['Path Length Day 4-2 vs Baseline: p=',num2str(p_path_bsl),'; t=',num2str(t_path_bsl)]);
disp(' ');

RT_pre = mean(dAll.Bi.RT(:,rng)')';
RT_post = mean(dAll.Bi.RT(:,rng2)')';
RT_bsl = mean(dAll.Uni.RT(:,rng)')';
[t_RT p_RT] = ttest(RT_pre,RT_post,2,'paired');
[t_RT_bsl p_RT_bsl] = ttest(RT_post,RT_bsl,2,'paired');
disp(['RT Day 2-1 vs Day 4-2, p=',num2str(p_RT),'; t=',num2str(t_RT)]);
disp(['RT Day 4-2 vs Baseline: p=',num2str(p_RT_bsl),'; t=',num2str(t_RT_bsl)]);
disp(' ');

vel_pre = mean(dAll.Bi.pkVel_1s(:,rng)')';
vel_post = mean(dAll.Bi.pkVel_1s(:,rng2)')';
vel_bsl = mean(dAll.Uni.pkVel_1s(:,rng)')';
[t_vel p_vel] = ttest(vel_pre,vel_post,2,'paired');
[t_vel_bsl p_vel_bsl] = ttest(vel_bsl,vel_post,2,'paired');
disp(['peak Vel Day 2-1 vs Day 4-2, p=',num2str(p_vel),'; t=',num2str(t_vel)]);
disp(['peak Vel Day 4-2 vs Baseline: p=',num2str(p_vel_bsl),'; t=',num2str(t_vel_bsl)]);
disp(' ');

movDur_pre = mean(dAll.Bi.movDur(:,rng)')';
movDur_post = mean(dAll.Bi.movDur(:,rng2)')';
movDur_bsl = mean(dAll.Uni.movDur(:,rng)')';
[t_movDur p_movDur] = ttest(movDur_pre,movDur_post,2,'paired');
[t_movDur_bsl p_movDur_bsl] = ttest(movDur_bsl,movDur_post,2,'paired');
disp(['movDur Day 2-1 vs Day 4-2, p=',num2str(p_movDur),'; t=',num2str(t_movDur)]);
disp(['movDur Day 4-2 vs Baseline: p=',num2str(p_movDur),'; t=',num2str(t_movDur)]);
disp(' ');

%% Aftereffects
pathLength_Uni1 = mean(dAll.UniNoJmp.pathLength(:,1:60),2);
pathLength_Uni2 = mean(dAll.UniNoJmp.pathLength(:,61:120),2);
[t_PL_AE p_PL_AE] = ttest(pathLength_Uni1,pathLength_Uni2,2,'paired');
disp(['Unimanual Path Length, pre vs post, p=',num2str(p_PL_AE),'; t=',num2str(t_PL_AE)]);
disp(['   difference = ',num2str(nanmean(pathLength_Uni1-pathLength_Uni2))])
disp(' ');

RT_Uni1 = mean(dAll.UniNoJmp.RT(:,1:60),2);
RT_Uni2 = mean(dAll.UniNoJmp.RT(:,61:120),2);
[t_RT_AE p_RT_AE] = ttest(RT_Uni1,RT_Uni2,2,'paired');
disp(['Unimanual Reaction Time, pre vs post, p=',num2str(p_RT_AE),'; t=',num2str(t_RT_AE)]);
disp(' ');

movDur_Uni1 = mean(dAll.UniNoJmp.movDur(:,1:60),2);
movDur_Uni2 = mean(dAll.UniNoJmp.movDur(:,61:120),2);
[t_movDur_AE p_movDur_AE] = ttest(movDur_Uni1,movDur_Uni2,2,'paired');
disp(['Unimanual Movement Duration, pre vs post, p=',num2str(p_movDur_AE),'; t=',num2str(t_movDur_AE)]);
disp(['   difference = ',num2str(nanmean(movDur_Uni1-movDur_Uni2))])
disp(' ');

%% plot binned timecourse for individual subjects
fhandle = figure(4); clf; hold
set(fhandle,'Position',[200 200 400 200]);
set(fhandle,'Color','w');
set(fhandle,'Renderer','Painters');

plot([1:12]*5,binData(dAll.UniNoJmp.pathLength(:,1:60),5)'/.12,'b-')
plot([13:24]*5+5,binData(dAll.UniNoJmp.pathLength(:,61:120),5)'/.12,'k-')

plot([1:12]*5,mean((binData(dAll.UniNoJmp.pathLength(:,1:60),5)))/.12,'b-','linewidth',3)
plot([13:24]*5+5,mean((binData(dAll.UniNoJmp.pathLength(:,61:120),5)))/.12,'k-','linewidth',3)
%plot([0 120],[.3 .3],'k')
%axis([0 120 0 .7])
ylabel('path length')

%% Feedback responses
% make plots
cc = linspace(0,1,7)';
cu = linspace(1,0,7)';
col = [cc 0*cc 0*cu];

fhandle = figure(3); clf; hold on
set(fhandle,'Position',[250 250 1200 300]);
set(fhandle,'Color','w');
subplot(1,2,1); hold on;
time = dAll.time(1:end-1);
for c=[1 3 5 7]
    %plot(time,mean(dAll.Bi.response_small.vel(:,:,c)),'color',col(c,:),'linewidth',2)
    shadedErrorBar(time,mean(dAll.Bi.response_small.vel(:,:,c)),seNaN(dAll.Bi.response_small.vel(:,:,c)),{'-','color',col(c,:)},1);
end
%plot(time,mean(dAll.Uni.response_small.vel(:,:,1)),'b','linewidth',2)
shadedErrorBar(time,mean(dAll.Uni.response_small.vel(:,:,1)),seNaN(dAll.Uni.response_small.vel(:,:,1)),'b-',1);
axis([0 2000 -.02 .12])
xlabel('Time post-perturbation')
ylabel('Cursor velocity parallel to target jump')

subplot(1,2,2); hold on;
plot([0 2000],[0 0],'k')
for c=[1 3 5 7]
    %plot(time,mean(dAll.Bi.response_large.vel(:,:,c)),'color',col(c,:),'linewidth',2)
    shadedErrorBar(time,mean(dAll.Bi.response_large.vel(:,:,c)),seNaN(dAll.Bi.response_large.vel(:,:,c)),{'-','color',col(c,:)},1);
end
%plot(time,nanmean(dAll.Uni.response_large.vel(:,:,1)),'b','linewidth',2)
shadedErrorBar(time,nanmean(dAll.Uni.response_large.vel(:,:,1)),seNaN(dAll.Uni.response_large.vel(:,:,1)),'b-',1);
axis([0 2000 -.02 .12])
xlabel('Time post-perturbation')
ylabel('Cursor velocity parallel to target jump')

%% plot peak/latency to peak
fhandle = figure(4); clf; 
set(fhandle,'Position',[250 250 1000 250])
set(fhandle,'Color','w')
subplot(1,2,1); hold on

plot(repmat([1.5 3.5 5.5]',1,2),[0 .1],'k:') % day boundaries
shadedErrorBar([],mean(dAll.Bi.peakResponse_large),seNaN(dAll.Bi.peakResponse_large),'b.-');
shadedErrorBar([],mean(dAll.Bi.peakResponse_small),seNaN(dAll.Bi.peakResponse_small),'g.-');

shadedErrorBar([8 9],mean(dAll.Uni.peakResponse_large),seNaN(dAll.Uni.peakResponse_large),'k.-');
shadedErrorBar([8 9],mean(dAll.Uni.peakResponse_small),seNaN(dAll.Uni.peakResponse_small),'m.-');
%axis([0.5 9.5 0 .00011])
xlim([0.5 9.5])
xlabel('chunk')
ylabel('strength of fb response')

subplot(1,2,2); hold on
dt = 1000/130; % ms per timestep
plot(repmat([1.5 3.5 5.5]',1,2),[0 1200],'k:') % day boundaries
shadedErrorBar([],dt*mean(dAll.Bi.peakResponse_lat_large),dt*seNaN(dAll.Bi.peakResponse_lat_large),'b.-');
shadedErrorBar([],dt*mean(dAll.Bi.peakResponse_lat_small),dt*seNaN(dAll.Bi.peakResponse_lat_small),'g.-');

shadedErrorBar([8 9],dt*mean(dAll.Uni.peakResponse_lat_large),dt*seNaN(dAll.Uni.peakResponse_lat_large),'k.-');
shadedErrorBar([8 9],dt*mean(dAll.Uni.peakResponse_lat_small),dt*seNaN(dAll.Uni.peakResponse_lat_small),'m.-');
%plot(dAll.Bi.peakResponse_lat_large,'.-')
axis([0.5 9.5 0 1200])
xlabel('chunk')
ylabel('latency to peak fb response')

% stats on feedback responses
disp('---- Feedback Responses ----')
peak_response_large_pre = dAll.Bi.peakResponse_large(:,1);
peak_response_large_post = dAll.Bi.peakResponse_large(:,7);
peak_response_small_pre = dAll.Bi.peakResponse_small(:,1);
peak_response_small_post = dAll.Bi.peakResponse_small(:,7);

% stats on feedback responses

peak_response_large_bsl = dAll.Uni.peakResponse_large(:,2);
peak_response_small_bsl = dAll.Uni.peakResponse_small(:,2);

% stats on feedback responses
[t_large p_large] = ttest(peak_response_large_bsl, peak_response_large_post,2,'paired');
[t_small p_small] = ttest(peak_response_small_bsl, peak_response_small_post,2,'paired');

[t_large_pre_post p_large_pre_post] = ttest(peak_response_large_pre, peak_response_large_post,2,'paired');
[t_small_pre_post p_small_pre_post] = ttest(peak_response_small_pre, peak_response_small_post,2,'paired');


disp('Peak Feedback Response')
disp(['   Day 3 vs Baseline'])
disp(['       large: p = ',num2str(p_large),'; t = ',num2str(t_large)])
disp(['       small: p = ',num2str(p_small),'; t = ',num2str(t_small)])
disp(['   Day 1 vs Day 3'])
disp(['       large: p = ',num2str(p_large_pre_post),'; t = ',num2str(t_large_pre_post)])
disp(['       small: p = ',num2str(p_small_pre_post),'; t = ',num2str(t_small_pre_post)])




