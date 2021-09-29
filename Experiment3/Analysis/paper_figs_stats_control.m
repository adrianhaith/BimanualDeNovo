% makes figures for peak velocity/latency analysis
clear all
clc
addpath ../../functions
load ../../Experiment2/Analysis/Bimanual_speed_compact
dAll_speed = dAll;

load Bimanual_control_compact

%% Velocity profiles
% make plots
col = [100 220 100
       70 110 255
       255 160 10
       255 110 255
       160 120 80]./255;
hands = {'L','Bi','R'};

fhandle = figure(1); clf
set(fhandle,'Position',[250 250 400 150])
set(fhandle,'Color','w')

% small target jump
subplot(1,2,1); hold on;
time = dAll.time(1:end-1);
plot([0 2000],[0 0],'k')
for i = 1:length(hands)
    shadedErrorBar(time,mean(dAll.(hands{i}).response_small.vel),seNaN(dAll.(hands{i}).response_small.vel),{'-','color',col(i,:)},1);
end
axis([0 1000 -.02 .12])
xlabel('Time post-perturbation')
ylabel('Cursor velocity parallel to target jump')

% large target jump
subplot(1,2,2); hold on;
plot([0 2000],[0 0],'k')
for i = 1:length(hands)
    shadedErrorBar(time,mean(dAll.(hands{i}).response_large.vel),seNaN(dAll.(hands{i}).response_large.vel),{'-','color',col(i,:)},1);
end
axis([0 1000 -.02 .12])
xlabel('Time post-perturbation')

% print('C:/Users/Chris/Documents/Papers/bimanual/velocity','-dpdf','-painters')

%% peak velocity/latency
fhandle = figure(2); clf; 
set(fhandle,'Position',[250 250 250 300])
set(fhandle,'Color','w')

dt = 1000/130; % ms per timestep
hands2 = {'Uni','Bi'};

subplot(2,1,1); hold on
for i = 1:3
    plot(1+(0.5*i),dAll.(hands{i}).peakResponse_small,'.','Color',col(i,:),'MarkerSize',12,'HandleVisibility','off')
    plot(5+(0.5*i),dAll.(hands{i}).peakResponse_large,'.','Color',col(i,:),'MarkerSize',12,'HandleVisibility','off')
    plot(1+(0.5*i),mean(dAll.(hands{i}).peakResponse_small),'ok','MarkerFaceColor',col(i,:),'MarkerSize',6)
    plot(5+(0.5*i),mean(dAll.(hands{i}).peakResponse_large),'ok','MarkerFaceColor',col(i,:),'MarkerSize',6,'HandleVisibility','off')
end

plot(3.5,dAll_speed.Bi.peakResponse_small(:,end),'<','Color','none','MarkerFaceColor',col(2,:),'MarkerSize',5,'HandleVisibility','off')
plot(7.5,dAll_speed.Bi.peakResponse_large(:,end),'<','Color','none','MarkerFaceColor',col(2,:),'MarkerSize',5,'HandleVisibility','off')
plot(3.5,mean(dAll_speed.Bi.peakResponse_small(:,end)),'<k','MarkerFaceColor',col(2,:),'MarkerSize',8)
plot(7.5,mean(dAll_speed.Bi.peakResponse_large(:,end)),'<k','MarkerFaceColor',col(2,:),'MarkerSize',8,'HandleVisibility','off')

plot(4,dAll_speed.Uni.peakResponse_small,'<','Color','none','MarkerFaceColor',col(3,:),'MarkerSize',5,'HandleVisibility','off')
plot(8,dAll_speed.Uni.peakResponse_large,'<','Color','none','MarkerFaceColor',col(3,:),'MarkerSize',5,'HandleVisibility','off')
plot(4,mean(dAll_speed.Uni.peakResponse_small),'<k','MarkerFaceColor',col(3,:),'MarkerSize',8)
plot(8,mean(dAll_speed.Uni.peakResponse_large),'<k','MarkerFaceColor',col(3,:),'MarkerSize',8,'HandleVisibility','off')

axis([1 8.5 0 0.15])
xticks([])
yticks(0:0.05:0.15)
ylabel('Peak velocity (m/s)')

subplot(2,1,2); hold on
for i = 1:3
    plot(1+(0.5*i),dt*dAll.(hands{i}).peakResponse_lat_small,'.','Color',col(i,:),'MarkerSize',12,'HandleVisibility','off')
    plot(5+(0.5*i),dt*dAll.(hands{i}).peakResponse_lat_large,'.','Color',col(i,:),'MarkerSize',12,'HandleVisibility','off')
    plot(1+(0.5*i),mean(dt*dAll.(hands{i}).peakResponse_lat_small),'ok','MarkerFaceColor',col(i,:),'MarkerSize',6)
    plot(5+(0.5*i),mean(dt*dAll.(hands{i}).peakResponse_lat_large),'ok','MarkerFaceColor',col(i,:),'MarkerSize',6,'HandleVisibility','off')
end

plot(3.5,dt*dAll_speed.Bi.peakResponse_lat_small(:,end),'<','Color','none','MarkerFaceColor',col(2,:),'MarkerSize',5,'HandleVisibility','off')
plot(7.5,dt*dAll_speed.Bi.peakResponse_lat_large(:,end),'<','Color','none','MarkerFaceColor',col(2,:),'MarkerSize',5,'HandleVisibility','off')
plot(3.5,mean(dt*dAll_speed.Bi.peakResponse_lat_small(:,end)),'<k','MarkerFaceColor',col(2,:),'MarkerSize',8)
plot(7.5,mean(dt*dAll_speed.Bi.peakResponse_lat_large(:,end)),'<k','MarkerFaceColor',col(2,:),'MarkerSize',8,'HandleVisibility','off')

plot(4,dt*dAll_speed.Uni.peakResponse_lat_small,'<','Color','none','MarkerFaceColor',col(3,:),'MarkerSize',5,'HandleVisibility','off')
plot(8,dt*dAll_speed.Uni.peakResponse_lat_large,'<','Color','none','MarkerFaceColor',col(3,:),'MarkerSize',5,'HandleVisibility','off')
plot(4,mean(dt*dAll_speed.Uni.peakResponse_lat_small),'<k','MarkerFaceColor',col(3,:),'MarkerSize',8)
plot(8,mean(dt*dAll_speed.Uni.peakResponse_lat_large),'<k','MarkerFaceColor',col(3,:),'MarkerSize',8,'HandleVisibility','off')

axis([1 8.5 350 700])
xticks([])
xlabel('Jump size')
ylabel('Peak latency (ms)')

print('C:/Users/Chris/Documents/Papers/bimanual/comparisons','-dpdf','-painters')

%% statistics

% analysis for peak response
exp2_small = dAll_speed.Uni.peakResponse_small' - dAll_speed.Bi.peakResponse_small(:,end);
exp2_large = dAll_speed.Uni.peakResponse_large' - dAll_speed.Bi.peakResponse_large(:,end);
exp3_small = dAll.R.peakResponse_small' - dAll.Bi.peakResponse_small';
exp3_large = dAll.R.peakResponse_large' - dAll.Bi.peakResponse_large';
y = [exp2_small; exp2_large; exp3_small; exp3_large];

exp = repmat(2:3,[18 1]);
exp = exp(:);
jumpSize = [repelem("small",8) repelem("large",8) repelem("small",10) repelem("large",10)]';

[~, tbl, stats] = anovan(y, {exp,jumpSize}, 'model', 'full', 'varnames', {'experiment','jump size'}, 'display', 'off');
disp('Two-way ANOVA for peak response')
disp(['   experiment: F(' num2str(tbl{2,3}), ',' num2str(tbl{5,3}) ') = ' num2str(tbl{2,6}) '; p = ' num2str(tbl{2,7})])
disp(['   jump size: F(' num2str(tbl{3,3}), ',' num2str(tbl{5,3}) ') = ' num2str(tbl{3,6}) '; p = ' num2str(tbl{3,7})])
disp(['   experiment * jump size: F(' num2str(tbl{4,3}), ',' num2str(tbl{5,3}) ') = ' num2str(tbl{4,6}) '; p = ' num2str(tbl{4,7})])

figure(3); clf;
multcompare(stats, 'Dimension', [1 2]);

% analysis for peak latency
exp2_small = dAll_speed.Bi.peakResponse_lat_small(:,end) - dAll_speed.Uni.peakResponse_lat_small';
exp2_large = dAll_speed.Bi.peakResponse_lat_large(:,end) - dAll_speed.Uni.peakResponse_lat_large';
exp3_small = dAll.Bi.peakResponse_lat_small' - dAll.R.peakResponse_lat_small';
exp3_large = dAll.Bi.peakResponse_lat_large' - dAll.R.peakResponse_lat_large';
y = [exp2_small; exp2_large; exp3_small; exp3_large];

[~, tbl, stats] = anovan(y, {exp,jumpSize}, 'model', 'full', 'varnames', {'experiment','jump size'}, 'display', 'off');
disp('Two-way ANOVA for peak latency')
disp(['   experiment: F(' num2str(tbl{2,3}), ',' num2str(tbl{5,3}) ') = ' num2str(tbl{2,6}) '; p = ' num2str(tbl{2,7})])
disp(['   jump size: F(' num2str(tbl{3,3}), ',' num2str(tbl{5,3}) ') = ' num2str(tbl{3,6}) '; p = ' num2str(tbl{3,7})])
disp(['   experiment * jump size: F(' num2str(tbl{4,3}), ',' num2str(tbl{5,3}) ') = ' num2str(tbl{4,6}) '; p = ' num2str(tbl{4,7})])

figure(4); clf;
multcompare(stats, 'Dimension', [1 2]);
