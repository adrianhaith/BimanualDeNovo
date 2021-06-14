% plots for figures
%%
clear all

%load BimanualSkillData
subjNum = 9;
fname = fullfile('../../../','Expt1_data',['BimanualSkillData_S',num2str(subjNum)])
load(fname)
%data = dat;

%
% plot trajectories through learning
% good subjects: 5, 11, 13
f = figure(23); clf; hold on
set(f,'Position',[100 100 1600 400])



b = [1 3 5 7]
for j=1:4
    % figure out which trials were potential jump trials
    pert_all = data.Bi{b(j)}.pert;
    pert_mat = reshape(pert_all,60,5);
    pp = sum(abs(pert_mat),2)>0;
    jump_possible = repmat(pp',1,5);
    
    % figure out trials with no jump
    clean = jump_possible & (pert_all==0);
    
    subplot(1,5,j); hold on
    for i=1:300
        %plot(data.BiInit.Cr{i}(:,1),data.BiInit.Cr{i}(:,2),'b')
        if(clean(i))
            plot(data.Bi{b(j)}.Cr{i}(:,1),data.Bi{b(j)}.Cr{i}(:,2),'b')
        end
    end
    axis equal
    ylim([-.1 .2])
    xlim([-.08 .08])
end

subplot(1,5,5); hold on
% plot unimanual data
% figure out which trials were potential jump trials
    pert_all = data.Uni{1}.pert;
    pert_mat = reshape(pert_all,60,5);
    pp = sum(abs(pert_mat),2)>0;
    jump_possible = repmat(pp',1,5);
    
    % figure out trials with no jump
    clean = jump_possible & (pert_all==0);
    
    for i=1:300
        %plot(data.BiInit.Cr{i}(:,1),data.BiInit.Cr{i}(:,2),'b')
        if(clean(i))
            plot(data.Uni{1}.Cr{i}(:,1),data.Uni{1}.Cr{i}(:,2),'k')
        end
    end
    axis equal
    ylim([-.1 .2])
    xlim([-.08 .08])

%{
subplot(1,2,2); hold on
for i=1:60
    plot(data.Bi{7}.Cr{i}(:,1),data.Bi{7}.Cr{i}(:,2),'b')
end
axis equal
ylim([-.1 .2]) 
%}
%% Examine aftereffects
figure(21); clf; hold on
subplot(1,2,1); hold on
rng = 1:20;
%subplot(1,2,1); hold on
for i=rng
    plot(data.nojmp.Uni1.C{i}(:,1),data.nojmp.Uni1.C{i}(:,2),'k','linewidth',2)
end
%subplot(1,2,1); hold on
for i=rng
    plot(data.nojmp.Uni2.C{i}(:,1),data.nojmp.Uni2.C{i}(:,2),'g','linewidth',2)
end
axis equal

subplot(1,2,2); hold on
rng = 1:20;
%subplot(1,2,1); hold on
for i=rng
    plot(data.nojmp.Uni1.Cr{i}(:,1),data.nojmp.Uni1.Cr{i}(:,2),'k','linewidth',2)
end
%subplot(1,2,1); hold on
for i=rng
    plot(data.nojmp.Uni2.Cr{i}(:,1),data.nojmp.Uni2.Cr{i}(:,2),'g','linewidth',2)
end
axis equal
%% plot sample trajectories
figure(10); clf; hold on
%subplot(1,3,1); hold on
plot(data.BiInit.C{1}(1,1),data.BiInit.C{1}(1,2),'b.','linewidth',2,'markersize',40)
for i=1:20
    plot(data.BiInit.C{i}(1,1),data.BiInit.C{i}(1,2),'k.','linewidth',2,'markersize',20)
    plot(data.BiInit.C{i}(:,1),data.BiInit.C{i}(:,2),'b')
    plot(data.BiInit.L{i}(:,1),data.BiInit.L{i}(:,2),'g')
    plot(data.BiInit.R{i}(:,1),data.BiInit.R{i}(:,2),'r')
%plot(dataS1.BiInit.C{i}(1,1),dataS1.BiInit.C{i}(1,2),'y.','linewidth',2,'markersize',20)
end
axis equal

figure(11); clf; hold on
c = [1 3 5 7];
for j=1:length(c)
    subplot(2,2,j); hold on
    for i=1:20
        plot(data.Bi{c(j)}.C{i}(1,1),data.Bi{c(j)}.C{i}(1,2),'k.','linewidth',2,'markersize',20)
        plot(data.Bi{c(j)}.C{i}(:,1),data.Bi{c(j)}.C{i}(:,2),'b')
        plot(data.Bi{c(j)}.L{i}(:,1),data.Bi{c(j)}.L{i}(:,2),'g')
        plot(data.Bi{c(j)}.R{i}(:,1),data.Bi{c(j)}.R{i}(:,2),'r')
    end
    axis equal
    axis([.2 1 .2 .5])
end

figure(12); clf; hold on
c = [1 3 5 7];
for j=1:length(c)
    subplot(2,4,2*j-1); hold on
    for i=1:20
        plot(data.Bi{c(j)}.L{i}(:,1),data.Bi{c(j)}.L{i}(:,2),'g')
        plot(data.Bi{c(j)}.R{i}(:,1),data.Bi{c(j)}.R{i}(:,2),'r')
    end
    axis equal
    
    subplot(2,4,2*j); hold on
    for i=1:20
        plot(data.Bi{c(j)}.C{i}(:,1),data.Bi{c(j)}.C{i}(:,2),'b')
        plot(data.Bi{c(j)}.N{i}(:,1),data.Bi{c(j)}.N{i}(:,2),'k')
    end
    axis equal
end

%% velocity profiles
%{
figure(31); clf; hold on
c = [1 3 5 7];
rng = 31:60;
dt = 1000/130;
for j=1:length(c)
    subplot(4,2,2*j-1); hold on
    for i=rng+240
        Nx = length(data.Bi{c(j)}.tanVel{i}(data.Bi{c(j)}.init(i)-22:end));
        plot([1:Nx]*dt,savgolayFilt(data.Bi{c(j)}.tanVel{i}(data.Bi{c(j)}.init(i)-22:end)',3,11),'b')
        %plot(savgolayFilt(data.nojmp.Uni1.tanVel{i}(data.nojmp.Uni1.init(i)-22:end)',3,11),'k')
    end
    %axis([0 4000 0 .003])
end
subplot(4,2,2); hold on
for i=rng
    Nx = length(data.nojmp.Uni1.tanVel{i}(data.nojmp.Uni1.init(i)-22:end));
    plot([1:Nx]*dt,savgolayFilt(data.nojmp.Uni1.tanVel{i}(data.nojmp.Uni1.init(i)-22:end)',3,11),'k')
end
axis([0 4000 0 .003])
%}
%% performance metrics
load Bimanual_compact

cc = linspace(0,1,7)';
cu = linspace(1,0,7)';
col = [cc 0*cc 0*cu];
%%
figure(1); clf; hold on
subplot(1,2,1); hold on;
time = dAll.time;
for c=[1 3 5 7]
    plot(time,dAll.Bi.response_small.pos(subjNum,:,c),'color',col(c,:),'linewidth',2)
    %shadedErrorBar(time,dAll.Bi.response_small.pos(subj,:,c),seNaN(dAll.Bi.response_small.pos(subjNum,:,c)),{'-','color',col(c,:)},1);
end
plot(time,dAll.Uni.response_small.pos(subjNum,:,1),'b','linewidth',2)
%shadedErrorBar(time,mean(dAll.Uni.response_small.pos(:,:,1)),seNaN(dAll.Uni.response_small.pos(:,:,1)),'b-',1);
plot(time,.015*ones(size(time)),'k:')
axis([-100 2000 -.005 .04])
xlabel('Time post-perturbation')
ylabel('Cursor position parallel to target jump')

subplot(1,2,2); hold on
for c=[1 3 5 7]
    plot(time,dAll.Bi.response_large.pos(subjNum,:,c),'color',col(c,:),'linewidth',2)
    %shadedErrorBar(time,mean(dAll.Bi.response_large.pos(subjNum,:,c)),seNaN(dAll.Bi.response_large.pos(subjNum,:,c)),{'-','color',col(c,:)},1);
end
plot(time,dAll.Uni.response_large.pos(subjNum,:,1),'b','linewidth',2)
%shadedErrorBar(time,nanmean(dAll.Uni.response_large.pos(:,:,1)),seNaN(dAll.Uni.response_large.pos(:,:,1)),'b-',1);
plot(time,.03*ones(size(time)),'k:')
axis([-100 2000 -.005 .04])
xlabel('Time post-perturbation')
ylabel('Cursor position parallel to target jump')

%% mean perturbation response across subjects - velocity
figure(2); clf; hold on
subplot(1,2,1); hold on;
time = dAll.time(1:end-1);
for c=[1 3 5 7]
    plot(time,dAll.Bi.response_small.vel(subjNum,:,c),'color',col(c,:),'linewidth',2)
    %shadedErrorBar(time,mean(dAll.Bi.response_small.vel(subjNum,:,c)),seNaN(dAll.Bi.response_small.vel(subjNum,:,c)),{'-','color',col(c,:)},1);
end
plot(time,dAll.Uni.response_small.vel(subjNum,:,1),'b','linewidth',2)
%shadedErrorBar(time,mean(dAll.Uni.response_small.vel(:,:,1)),seNaN(dAll.Uni.response_small.vel(:,:,1)),'b-',1);
%axis([0 2000 -.00002 .00012])
xlabel('Time post-perturbation')
ylabel('Cursor velocity parallel to target jump')

subplot(1,2,2); hold on
for c=[1 3 5 7]
    plot(time,dAll.Bi.response_large.vel(subjNum,:,c),'color',col(c,:),'linewidth',2)
    %shadedErrorBar(time,mean(dAll.Bi.response_large.vel(subjNum,:,c)),seNaN(dAll.Bi.response_large.vel(subjNum,:,c)),{'-','color',col(c,:)},1);
end
plot(time,dAll.Uni.response_large.vel(subjNum,:,1),'b','linewidth',2)
%shadedErrorBar(time,nanmean(dAll.Uni.response_large.vel(:,:,1)),seNaN(dAll.Uni.response_large.vel(:,:,1)),'b-',1);
%axis([0 2000 -.00002 .00012])
xlabel('Time post-perturbation')
ylabel('Cursor velocity parallel to target jump')


%%
figure(3); clf; hold on
subplot(2,2,1); hold on
plot([1:size(dAll.Bi.pathLength,2)]+10,dAll.Bi.pathLength(subjNum,:),'.-');
plot([1:size(dAll.Uni.pathLength,2)],dAll.Uni.pathLength(subjNum,:),'k.-');

plot([0 45],mean(dAll.Uni.pathLength(subjNum,:))*[1 1],'k')
plot([0 45],[.12 .12],'-','color',.5*[1 1 1])
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 2],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 2],'k:')
axis([0 45 0 .4])
xlabel('block')
ylabel('path length')

subplot(2,2,2); hold on
plot([1:size(dAll.Bi.pathLength_null,2)]+10,dAll.Bi.pathLength_null(subjNum,:),'.-');
%shadedErrorBar(1:size(dAll.Uni.pathLength_null,2),mean(dAll.Uni.pathLength_null),seNaN(dAll.Uni.pathLength_null),'k.-',1)
%plot(dAll.pathLength_null(s,:),'.-','linewidth',2)
%plot(dAll.Uni.pathLength_null(s,:),'k.-','linewidth',2)
%plot([0 35],mean(mean(dAll.Uni.pathLength_null))*[1 1],'k')
plot([0 45],[.12 .12],'-','color',.5*[1 1 1])
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 3],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 3],'k:')
axis([0 45 0 .4])
xlabel('block')
ylabel('path length null')

subplot(2,2,3); hold on
plot([1:size(dAll.Bi.RT,2)]+10,dAll.Bi.RT(subjNum,:),'.-');
plot(1:size(dAll.Uni.RT,2),dAll.Uni.RT(subjNum,:),'k.-');
%plot(dAll.RT(s,:),'.-','linewidth',2)
%plot(dAll.Uni.RT(s,:),'k.-','linewidth',2)
plot([0 45],mean(dAll.Uni.RT(subjNum,:))*[1 1],'k')
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 1000],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 1000],'k:')
axis([0 45 0 800])
xlabel('block')
ylabel('RT')

subplot(2,2,4); hold on
plot([1:size(dAll.Bi.pkVel,2)]+10,dAll.Bi.pkVel(subjNum,:),'.-');
plot(1:size(dAll.Uni.pkVel,2),dAll.Uni.pkVel(subjNum,:),'k.-');
%plot(dAll.pkVel(s,:),'.-','linewidth',2)
%plot(dAll.Uni.pkVel(s,:),'k.-','linewidth',2)
plot([0 45],mean(dAll.Uni.pkVel(subjNum,:))*[1 1],'k')
plot(repmat([5.5 15.5 25.5]',1,2)+10,[0 1000],'k')
plot(repmat([10.5 20.5 30.5]',1,2)+10,[0 1000],'k:')
axis([0 45 0 .003])
xlabel('block')
ylabel('peak Vel')

%%
figure(22); clf; hold on
subplot(2,2,1); hold on
plot(dAll.UniNoJmp.pathLength(subjNum,1:60),'b.-')
plot(dAll.UniNoJmp.pathLength(subjNum,61:120),'k.-')
ylabel('path length')

subplot(2,2,2); hold on
plot(dAll.UniNoJmp.RT(subjNum,1:60),'b.-')
plot(dAll.UniNoJmp.RT(subjNum,61:120),'k.-')
ylabel('RT')

subplot(2,2,3); hold on
plot(dAll.UniNoJmp.movDur(subjNum,1:60),'b.-')
plot(dAll.UniNoJmp.movDur(subjNum,61:120),'k.-')
ylabel('movement duration')

subplot(2,2,4); hold on
plot(dAll.UniNoJmp.pkVel(subjNum,1:60),'b.-')
plot(dAll.UniNoJmp.pkVel(subjNum,61:120),'k.-')
ylabel('peak velocity')


    