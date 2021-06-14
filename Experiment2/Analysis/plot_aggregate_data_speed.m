% plot aggregate data across subjects
clear all
load Bimanual_speed_compact

cc = linspace(0,1,7)';
cu = linspace(1,0,7)';
col = [cc 0*cc 0*cu];

%% mean perturbation response across subjects - position
figure(1); clf; hold on
subplot(1,2,1); hold on;
time = dAll.time;
for c=[1 3 5]
    plot(time,mean(dAll.Bi.response_small.pos(:,:,c)),'color',col(c,:),'linewidth',2)
    shadedErrorBar(time,mean(dAll.Bi.response_small.pos(:,:,c)),seNaN(dAll.Bi.response_small.pos(:,:,c)),{'-','color',col(c,:)},1);
end
plot(time,mean(dAll.Uni.response_small.pos(:,:,1)),'b','linewidth',2)
shadedErrorBar(time,mean(dAll.Uni.response_small.pos(:,:,1)),seNaN(dAll.Uni.response_small.pos(:,:,1)),'b-',1);
plot(time,.015*ones(size(time)),'k:')
axis([-100 2000 -.005 .04])
xlabel('Time post-perturbation')
ylabel('Cursor velocity parallel to target jump')

subplot(1,2,2); hold on
for c=[1 3 5]
    plot(time,mean(dAll.Bi.response_large.pos(:,:,c)),'color',col(c,:),'linewidth',2)
    shadedErrorBar(time,mean(dAll.Bi.response_large.pos(:,:,c)),seNaN(dAll.Bi.response_large.pos(:,:,c)),{'-','color',col(c,:)},1);
end
plot(time,nanmean(dAll.Uni.response_large.pos(:,:,1)),'b','linewidth',2)
shadedErrorBar(time,nanmean(dAll.Uni.response_large.pos(:,:,1)),seNaN(dAll.Uni.response_large.pos(:,:,1)),'b-',1);
plot(time,.03*ones(size(time)),'k:')
axis([-100 2000 -.005 .04])
xlabel('Time post-perturbation')
ylabel('Cursor position parallel to target jump')

%% mean perturbation response across subjects - velocity
f = figure(2); clf; hold on
set(f,'Position',[700 800 1200 300])
set(f,'Color','w')
set(f,'Renderer','painters')
subplot(1,2,1); hold on;
plot([0 2000],[0 0],'k')

subplot(1,2,1); hold on;
%freq = 130; % sampling frequency for scaling velocity after differentiation
time = dAll.time(1:end-1);
for c=[1 3 5]
    %plot(time,mean(dAll.Bi.response_small.vel(:,:,c)),'color',col(c,:),'linewidth',2)
    shadedErrorBar(time,mean(dAll.Bi.response_small.vel(:,:,c)),seNaN(dAll.Bi.response_small.vel(:,:,c)),{'-','color',col(c,:)},1);
end
%plot(time,mean(dAll.Uni.response_small.vel(:,:,1)),'b','linewidth',2)
shadedErrorBar(time,mean(dAll.Uni.response_small.vel(:,:,1)),seNaN(dAll.Uni.response_small.vel(:,:,1)),'b-',1);
axis([0 2000 -.02 .12])
xlabel('Time post-perturbation')
ylabel('Cursor velocity parallel to target jump')

subplot(1,2,2); hold on
plot([0 2000],[0 0],'k')
for c=[1 3 5]
    %plot(time,mean(dAll.Bi.response_large.vel(:,:,c)),'color',col(c,:),'linewidth',2)
    shadedErrorBar(time,mean(dAll.Bi.response_large.vel(:,:,c)),seNaN(dAll.Bi.response_large.vel(:,:,c)),{'-','color',col(c,:)},1);
end
%plot(time,nanmean(dAll.Uni.response_large.vel(:,:,1)),'b','linewidth',2)
shadedErrorBar(time,nanmean(dAll.Uni.response_large.vel(:,:,1)),seNaN(dAll.Uni.response_large.vel(:,:,1)),'b-',1);
axis([0 2000 -.02 .12])
xlabel('Time post-perturbation')
ylabel('Cursor velocity parallel to target jump')


%%
figure(3); clf; hold on
subplot(2,2,1); hold on
shadedErrorBar([1:size(dAll.Bi.pathLength,2)]+10,mean(dAll.Bi.pathLength),seNaN(dAll.Bi.pathLength),'b.-',1);
shadedErrorBar([1:size(dAll.Uni.pathLength,2)],mean(dAll.Uni.pathLength),seNaN(dAll.Uni.pathLength),'k.-',1);
plot([0 45],mean(mean(dAll.Uni.pathLength))*[1 1],'k')
plot([0 45],[.12 .12],'-','color',.5*[1 1 1])
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 2],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 2],'k:')
axis([0 45 0 .7])
xlabel('block')
ylabel('path length')

subplot(2,2,2); hold on
shadedErrorBar([1:size(dAll.Bi.pathLength_null,2)]+10,mean(dAll.Bi.pathLength_null),seNaN(dAll.Bi.pathLength_null),'b.-',1);
%shadedErrorBar(1:size(dAll.Uni.pathLength_null,2),mean(dAll.Uni.pathLength_null),seNaN(dAll.Uni.pathLength_null),'k.-',1)
%plot(dAll.pathLength_null(s,:),'.-','linewidth',2)
%plot(dAll.Uni.pathLength_null(s,:),'k.-','linewidth',2)
%plot([0 35],mean(mean(dAll.Uni.pathLength_null))*[1 1],'k')
plot([0 45],[.12 .12],'-','color',.5*[1 1 1])
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 3],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 3],'k:')
axis([0 45 0 .7])
xlabel('block')
ylabel('path length null')

subplot(2,2,3); hold on
shadedErrorBar([1:size(dAll.Bi.RT,2)]+10,mean(dAll.Bi.RT),seNaN(dAll.Bi.RT),'b.-',1);
shadedErrorBar(1:size(dAll.Uni.RT,2),mean(dAll.Uni.RT),seNaN(dAll.Uni.RT),'k.-',1);
%plot(dAll.RT(s,:),'.-','linewidth',2)
%plot(dAll.Uni.RT(s,:),'k.-','linewidth',2)
plot([0 45],mean(mean(dAll.Uni.RT))*[1 1],'k')
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 1000],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 1000],'k:')
axis([0 45 0 600])
xlabel('block')
ylabel('RT')

subplot(2,2,4); hold on
shadedErrorBar([1:size(dAll.Bi.pkVel_1s,2)]+10,mean(dAll.Bi.pkVel_1s),seNaN(dAll.Bi.pkVel_1s),'b.-',1);
shadedErrorBar(1:size(dAll.Uni.pkVel_1s,2),mean(dAll.Uni.pkVel_1s),seNaN(dAll.Uni.pkVel_1s),'k.-',1);
%plot(dAll.pkVel(s,:),'.-','linewidth',2)
%plot(dAll.Uni.pkVel(s,:),'k.-','linewidth',2)
plot([0 45],mean(mean(dAll.Uni.pkVel_1s))*[1 1],'k')
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 1000],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 1000],'k:')
%axis([0 45 0 .005])
xlabel('block')
ylabel('peak Vel')

%% plot aftereffects - all subjects
%{
dAll.UniNoJmp.pathLength(11,21) = NaN;
figure(22); clf; hold on
subplot(2,2,1); hold on
plot([1:60],dAll.UniNoJmp.pathLength(:,1:60)','b.-')
plot([61:120],dAll.UniNoJmp.pathLength(:,61:120)','k.-')
plot([0 120],[.3 .3],'k')
axis([0 120 0 .7])
ylabel('path length')

subplot(2,2,2); hold on
plot([1:60],dAll.UniNoJmp.RT(:,1:60)','b.-')
plot([61:120],dAll.UniNoJmp.RT(:,61:120)','k.-')
ylabel('RT')

subplot(2,2,3); hold on
plot([1:60],dAll.UniNoJmp.movDur(:,1:60)','b.-')
plot([61:120],dAll.UniNoJmp.movDur(:,61:120)','k.-')
ylabel('movement duration')

subplot(2,2,4); hold on
plot([1:60],dAll.UniNoJmp.pkVel(:,1:60)','b.-')
plot([61:120],dAll.UniNoJmp.pkVel(:,61:120)','k.-')
ylabel('peak velocity')
%}
%% plot aftereffects - mean
%{
figure(23); clf; hold on
subplot(2,2,1); hold on
shadedErrorBar([1:60],nanmean(dAll.UniNoJmp.pathLength(:,1:60)),seNaN(dAll.UniNoJmp.pathLength(:,1:60)),'b.-')
shadedErrorBar([61:120],nanmean(dAll.UniNoJmp.pathLength(:,61:end)),seNaN(dAll.UniNoJmp.pathLength(:,61:end)),'k.-')
axis([0 120 0 .3])
ylabel('path length')

subplot(2,2,2); hold on
%plot(dAll.UniNoJmp.RT(:,1:60)','b.-')
%plot(dAll.UniNoJmp.RT(:,61:120)','k.-')
shadedErrorBar([1:60],nanmean(dAll.UniNoJmp.RT(:,1:60)),seNaN(dAll.UniNoJmp.RT(:,1:60)),'b.-')
shadedErrorBar([61:120],nanmean(dAll.UniNoJmp.RT(:,61:120)),seNaN(dAll.UniNoJmp.RT(:,61:120)),'b.-')
ylabel('RT')

subplot(2,2,3); hold on
%plot(dAll.UniNoJmp.movDur(:,1:60)','b.-')
%plot(dAll.UniNoJmp.movDur(:,61:120)','k.-')
%shadedErrorBar([1:60],nanmean(dAll.UniNoJmp.movDur(:,1:60)),seNaN(dAll.UniNoJmp.movDur(:,1:60)),'b.-')
%shadedErrorBar([61:120],nanmean(dAll.UniNoJmp.movDur(:,61:120)),seNaN(dAll.UniNoJmp.movDur(:,61:120)),'b.-')
shadedErrorBar([1:60],nanmean(dAll.UniNoJmp.initDir(:,1:60)),seNaN(dAll.UniNoJmp.initDir(:,1:60)),'b.-')
shadedErrorBar([61:120],nanmean(dAll.UniNoJmp.initDir(:,61:120)),seNaN(dAll.UniNoJmp.initDir(:,61:120)),'b.-')

%shadedErrorBar([1:60],circmean(dAll.UniNoJmp.initDir(:,1:60)*pi/180)*180/pi,circvar(dAll.UniNoJmp.initDir(:,1:60)'*pi/180)'*180/pi,'b.-')
%shadedErrorBar([61:120],nanmean(dAll.UniNoJmp.initDir(:,61:120)'*pi/180)'*180/pi,seNaN(dAll.UniNoJmp.initDir(:,61:120)'*pi/180)'*180/pi,'b.-')


ylabel('initial directional error')

subplot(2,2,4); hold on
shadedErrorBar([1:60],nanmean(dAll.UniNoJmp.pkVel(:,1:60)),seNaN(dAll.UniNoJmp.pkVel(:,1:60)),'b.-')
shadedErrorBar([61:120],nanmean(dAll.UniNoJmp.pkVel(:,61:120)),seNaN(dAll.UniNoJmp.pkVel(:,61:120)),'b.-')
%plot(freq*dAll.UniNoJmp.pkVel(:,1:60)','b.-')
%plot(freq*dAll.UniNoJmp.pkVel(:,61:120)','k.-')
ylabel('peak velocity')
%}
%% aftereffects comparison across subjects
%{
figure(24); clf; hold on
xjit = linspace(-.05,.05,13);

plot([xjit' 1+xjit' 2+xjit']',[mean(dAll.UniNoJmp.pathLength(:,56:60)')' mean(dAll.UniNoJmp.pathLength(:,61:65)')'  mean(dAll.UniNoJmp.pathLength(:,81:85)')']','k.-')
axis([-.2 2.2 0 .45])
%}
%% plot peak/latency over sessions
figure(41); clf; hold on
subplot(1,2,1); hold on
plot(repmat([1.5 3.5 5.5]',1,2),[0 .00009],'k:') % day boundaries
shadedErrorBar([],mean(dAll.Bi.peakResponse_large),seNaN(dAll.Bi.peakResponse_large),'b.-')
shadedErrorBar([],mean(dAll.Bi.peakResponse_small),seNaN(dAll.Bi.peakResponse_small),'g.-')

shadedErrorBar([8 9],mean(dAll.Uni.peakResponse_large)*[1 1],seNaN(dAll.Uni.peakResponse_large')'*[1 1],'k.-')
shadedErrorBar([8 9],mean(dAll.Uni.peakResponse_small)*[1 1],seNaN(dAll.Uni.peakResponse_small')'*[1 1],'m.-')
%axis([0.5 9.5 0 .00011])
xlabel('chunk')
ylabel('strength of fb response')

subplot(1,2,2); hold on
dt = 1000/130; % ms per timestep
plot(repmat([1.5 3.5 5.5]',1,2),[0 1200],'k:') % day boundaries
shadedErrorBar([],dt*mean(dAll.Bi.peakResponse_lat_large),dt*seNaN(dAll.Bi.peakResponse_lat_large),'b.-')
shadedErrorBar([],dt*mean(dAll.Bi.peakResponse_lat_small),dt*seNaN(dAll.Bi.peakResponse_lat_small),'g.-')

shadedErrorBar([8 9],dt*mean(dAll.Uni.peakResponse_lat_large)*[1 1],dt*seNaN(dAll.Uni.peakResponse_lat_large')'*[1 1],'k.-')
shadedErrorBar([8 9],dt*mean(dAll.Uni.peakResponse_lat_small)*[1 1],dt*seNaN(dAll.Uni.peakResponse_lat_small')'*[1 1],'m.-')
%plot(dAll.Bi.peakResponse_lat_large,'.-')
%axis([0.5 9.5 0 1200])
xlabel('chunk')
ylabel('latency to peak fb response')

%% plot response variability
figure(42); clf; hold on
subplot(1,3,1); hold on
for c=[1 3 5]
    plot(time,mean(dAll.Bi.response_small.vel_var(:,:,c)),'color',col(c,:),'linewidth',2)
    shadedErrorBar(time,mean(dAll.Bi.response_small.vel_var(:,:,c)),seNaN(dAll.Bi.response_small.vel_var(:,:,c)),{'-','color',col(c,:)},1);
end
plot(time,mean(dAll.Uni.response_small.vel_var(:,:,1)),'b','linewidth',2)
shadedErrorBar(time,mean(dAll.Uni.response_small.vel_var(:,:,1)),seNaN(dAll.Uni.response_small.vel_var(:,:,1)),'b-',1);
axis([0 2000 0 .1])
xlabel('Time post-perturbation')
ylabel('Variability in cursor velocity parallel to target jump')

subplot(1,3,2); hold on
for c=[1 3 5]
    plot(time,mean(dAll.Bi.response_large.vel_var(:,:,c)),'color',col(c,:),'linewidth',2)
    shadedErrorBar(time,mean(dAll.Bi.response_large.vel_var(:,:,c)),seNaN(dAll.Bi.response_large.vel_var(:,:,c)),{'-','color',col(c,:)},1);
end
plot(time,nanmean(dAll.Uni.response_large.vel_var(:,:,1)),'b','linewidth',2)
shadedErrorBar(time,nanmean(dAll.Uni.response_large.vel_var(:,:,1)),seNaN(dAll.Uni.response_large.vel_var(:,:,1)),'b-',1);
axis([0 2000 0 .1])
xlabel('Time post-perturbation')
ylabel('Variability in cursor velocity parallel to target jump')

subplot(1,3,3); hold on
for c=[1 3 5]
    plot(time,mean(dAll.Bi.response_nojmp.vel_var(:,:,c)),'color',col(c,:),'linewidth',2)
    shadedErrorBar(time,mean(dAll.Bi.response_nojmp.vel_var(:,:,c)),seNaN(dAll.Bi.response_nojmp.vel_var(:,:,c)),{'-','color',col(c,:)},1);
end
plot(time,nanmean(dAll.Uni.response_nojmp.vel_var(:,:,1)),'b','linewidth',2)
shadedErrorBar(time,nanmean(dAll.Uni.response_nojmp.vel_var(:,:,1)),seNaN(dAll.Uni.response_nojmp.vel_var(:,:,1)),'b-',1);
axis([0 2000 0 .1])
xlabel('Time post-perturbation')
ylabel('Variability in cursor velocity parallel to target jump')

%% plot difference in variability relative to no-jump
figure(43); clf; hold on
c = [1 3 5];

for ic=1:length(c)
    subplot(1,4,ic); hold on
    plot(time,mean(dAll.Bi.response_small.vel_var(:,:,c(ic))),'color',col(c(ic),:),'linewidth',2)
    plot(time,mean(dAll.Bi.response_nojmp.vel_var(:,:,c(ic))),'color',col(c(ic),:),'linewidth',1)
end






