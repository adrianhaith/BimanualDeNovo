% makes figures for peak velocity/latency analysis
clear all
clc
addpath ../../functions
load ../../Experiment2/Analysis/Bimanual_speed_compact
dAll_speed = dAll;

load Bimanual_control_compact

%% Velocity profiles
% make plots
col = lines;
col = col(1:7,:);
hands = {'L','R','Bi'};
size = {'small','large'};

fhandle = figure(1); clf
set(fhandle,'Position',[250 250 1200 300])
set(fhandle,'Color','w')

% small target jump
subplot(1,2,1); hold on;
time = dAll.time(1:end-1);
plot([0 2000],[0 0],'k')
for i = 1:length(hands)
    shadedErrorBar(time,mean(dAll.(hands{i}).response_small.vel),seNaN(dAll.(hands{i}).response_small.vel),{'-','color',col(i,:)},1);
end
axis([0 2000 -.02 .12])
xlabel('Time post-perturbation')
ylabel('Cursor velocity parallel to target jump')

% large target jump
subplot(1,2,2); hold on;
plot([0 2000],[0 0],'k')
for i = 1:length(hands)
    shadedErrorBar(time,mean(dAll.(hands{i}).response_large.vel),seNaN(dAll.(hands{i}).response_large.vel),{'-','color',col(i,:)},1);
end
axis([0 2000 -.02 .12])
xlabel('Time post-perturbation')
ylabel('Cursor velocity parallel to target jump')

%% peak velocity/latency
fhandle = figure(2); clf; 
set(fhandle,'Position',[250 250 600 500])
set(fhandle,'Color','w')

dt = 1000/130; % ms per timestep

subplot(2,2,1); hold on
for i = 1:3
    plot(1+(0.5*i),mean(dt*dAll.(hands{i}).peakResponse_small),'.','Color',col(i,:),'MarkerSize',30)
    plot(3.5+(0.5*i),mean(dt*dAll.(hands{i}).peakResponse_large),'.','Color',col(i,:),'MarkerSize',30,'HandleVisibility','off')

    plot(1+(0.5*i),dt*dAll.(hands{i}).peakResponse_small,'.','Color',col(i,:),'MarkerSize',10,'HandleVisibility','off')
    plot(3.5+(0.5*i),dt*dAll.(hands{i}).peakResponse_large,'.','Color',col(i,:),'MarkerSize',10,'HandleVisibility','off')
end
xlim([1 5.5])
xticks([2 4.5])
xticklabels({'1.5 cm','3 cm'})
xlabel('Jump size')
ylabel('Peak velocity (m/s)')
legend({'Left','Right','Bimanual'},'Location','Northwest')
legend box off

subplot(2,2,2); hold on
for i = 1:3
    plot(1+(0.5*i),mean(dt*dAll.(hands{i}).peakResponse_lat_small),'.','Color',col(i,:),'MarkerSize',30)
    plot(3.5+(0.5*i),mean(dt*dAll.(hands{i}).peakResponse_lat_large),'.','Color',col(i,:),'MarkerSize',30,'HandleVisibility','off')

    plot(1+(0.5*i),dt*dAll.(hands{i}).peakResponse_lat_small,'.','Color',col(i,:),'MarkerSize',10,'HandleVisibility','off')
    plot(3.5+(0.5*i),dt*dAll.(hands{i}).peakResponse_lat_large,'.','Color',col(i,:),'MarkerSize',10,'HandleVisibility','off')
end
xlim([1 5.5])
xticks([2 4.5])
xticklabels({'1.5 cm','3 cm'})
xlabel('Jump size')
ylabel('Peak latency (ms)')

% compute difference between bimanual and right hand movements
exp2.latency.large = dt*(dAll_speed.Bi.peakResponse_lat_large(:,end)' - dAll_speed.Uni.peakResponse_lat_large);
exp3.latency.large = dt*(dAll.Bi.peakResponse_lat_large - dAll.R.peakResponse_lat_large);
exp2.latency.small = dt*(dAll_speed.Bi.peakResponse_lat_small(:,end)' - dAll_speed.Uni.peakResponse_lat_small);
exp3.latency.small = dt*(dAll.Bi.peakResponse_lat_small - dAll.R.peakResponse_lat_small);

exp2.velocity.large = dt*(dAll_speed.Uni.peakResponse_large - dAll_speed.Bi.peakResponse_large(:,end)');
exp3.velocity.large = dt*(dAll.R.peakResponse_large - dAll.Bi.peakResponse_large);
exp2.velocity.small = dt*(dAll_speed.Uni.peakResponse_small - dAll_speed.Bi.peakResponse_small(:,end)');
exp3.velocity.small = dt*(dAll.R.peakResponse_small - dAll.Bi.peakResponse_small);

subplot(2,2,3); hold on
plot([0 5],[0 0],'k','HandleVisibility','off')
for i = 1:length(size)
    plot((i-1)*2 + 1,mean(exp2.velocity.(size{i})),'.','Color',col(4,:),'MarkerSize',30)
    plot((i-1)*2 + 1.5,mean(exp3.velocity.(size{i})),'.','Color',col(5,:),'MarkerSize',30)
    plot((i-1)*2 + 1,exp2.velocity.(size{i}),'.','Color',col(4,:),'MarkerSize',10)
    plot((i-1)*2 + 1.5,exp3.velocity.(size{i}),'.','Color',col(5,:),'MarkerSize',10)
end
xlim([0.5 4])
xticks([1.25 3.25])
xticklabels({'1.5 cm','3 cm'})
xlabel('Jump size')
ylabel('Difference in latency (bim - right)')
legend({'Exp 2','Exp 3'},'location','northwest')
legend box off

subplot(2,2,4); hold on
plot([0 5],[0 0],'k','HandleVisibility','off')
for i = 1:length(size)
    plot((i-1)*2 + 1,mean(exp2.latency.(size{i})),'.','Color',col(4,:),'MarkerSize',30)
    plot((i-1)*2 + 1.5,mean(exp3.latency.(size{i})),'.','Color',col(5,:),'MarkerSize',30)
    plot((i-1)*2 + 1,exp2.latency.(size{i}),'.','Color',col(4,:),'MarkerSize',10)
    plot((i-1)*2 + 1.5,exp3.latency.(size{i}),'.','Color',col(5,:),'MarkerSize',10)
end
xlim([0.5 4])
xticks([1.25 3.25])
xticklabels({'1.5 cm','3 cm'})
xlabel('Jump size')
ylabel('Difference in velocity (right - bim)')

%% statistics

% stats on peak velocity
y = [dAll.L.peakResponse_large'; dAll.R.peakResponse_large'; dAll.Bi.peakResponse_large'; ...
    dAll.L.peakResponse_small'; dAll.R.peakResponse_small'; dAll.Bi.peakResponse_small'];

jumpSize(1:24,1) = "large";
jumpSize(25:48,1) = "small";
hand(1:8,1) = "left";
hand(9:16,1) = "right";
hand(17:24,1) = "bimanual";
hand = [hand; hand];
subject = (1:8)';
subject = repmat(subject,[6 1]);

T = table(jumpSize, hand, subject, y, 'VariableNames', {'jump','hand','subject','velocity'});
writetable(T,'C:/Users/Chris/Documents/R/bimanual/data/velocity.csv')

% stats on peak velocity
y = [dAll.L.peakResponse_lat_large'; dAll.R.peakResponse_lat_large'; dAll.Bi.peakResponse_lat_large'; ...
    dAll.L.peakResponse_lat_small'; dAll.R.peakResponse_lat_small'; dAll.Bi.peakResponse_lat_small'];
y = y*dt;

T = table(jumpSize, hand, subject, y, 'VariableNames', {'jump','hand','subject','latency'});
writetable(T,'C:/Users/Chris/Documents/R/bimanual/data/latency.csv')


% compare 

exp2 = dAll_speed.Bi.peakResponse_large(:,end)' - dAll_speed.Uni.peakResponse_lat_large;
exp3 = dAll.Bi.peakResponse_lat_large - dAll.R.peakResponse_lat_large;


y = [dAll.L.peakResponse_large'; dAll.R.peakResponse_large'; dAll.Bi.peakResponse_large'; ...
    dAll.L.peakResponse_small'; dAll.R.peakResponse_small'; dAll.Bi.peakResponse_small'];

[t,p] = ttest(exp2,exp3,2,'independent');

disp('Difference in Latency b/w Experiments 2 and 3')
disp(['   t = ' num2str(t) '; p = ' num2str(p)])
