% find time of response onset for corrections
clear all
close all
% addpath ../Data/
addpath ../../functions
load BimanualSkillData_control
Nsubj = length(d);

%%
init_vel_thr = 0.2; % initial velocity threshold. Exclude trials which exceed this prior to target jump
init_pos_thr = 0.05; % initial position threshold.
dt = 1/130;

jumpSize = {'small','large'};
hands = {'L','Bi','R'};

for j = 1:2
    for i = 1:length(hands)
        t_init.(jumpSize{j}).(hands{i}) = NaN(Nsubj,1);
        for subj=1:Nsubj
            disp(['subject ',num2str(subj)])
            
            if(j == 1)
                % small jumps
                %r = getResponses([-d{subj}.Bi{blk}{2}.CrX_post; d{subj}.Bi{blk}{4}.CrX_post],.015,dt);
                % include an extra 100 ms before the target jump
                r = getResponses([-[d{subj}.(hands{i}){2}.CrX_pre(:,end-13:end) d{subj}.(hands{i}){2}.CrX_post]; [d{subj}.(hands{i}){4}.CrX_pre(:,end-13:end) d{subj}.(hands{i}){4}.CrX_post]],.015,dt);
            else
                % large jumps
                %r = getResponses([-d{subj}.Bi{blk}{1}.CrX_post; d{subj}.Bi{blk}{5}.CrX_post],.03,dt);
                % include an extra 100 ms before the target jump
                r = getResponses([-[d{subj}.(hands{i}){1}.CrX_pre(:,end-13:end) d{subj}.(hands{i}){1}.CrX_post]; [d{subj}.(hands{i}){5}.CrX_pre(:,end-13:end) d{subj}.(hands{i}){5}.CrX_post]],.03,dt);
            end
            
            pre_window = 13;
            
            init_vel = r.vel_all(:,1:pre_window); % first 260ms
            init_vel_bad = max(abs(init_vel)>init_vel_thr,[],2);
            
            init_pos = r.pos_all(:,1:pre_window);
            init_pos_bad = max(abs(init_pos)>init_pos_thr,[],2);
            
            vel_good = r.vel_all(~init_vel_bad,:);
            pos_good = r.pos_all(~init_pos_bad,:);
            vel_good_P = r.vel_all(~init_pos_bad,:);
            vel_good_P = r.vel_all((~init_pos_bad)&(~init_vel_bad),:);
            
            fit.(jumpSize{j}).(hands{i})(subj).Ngood = size(vel_good_P,1);
            disp(['Ngood = ',num2str(size(vel_good_P,1))]);
            
            figure(11); clf; hold on
            subplot(1,2,1); hold on
            plot(r.vel_all','r')
            plot(mean(r.vel_all),'r','linewidth',2)
            plot(vel_good','k')
            plot(mean(vel_good_P),'k','linewidth',2)
            plot([20 20],[-.2 .2],'k')
            
            subplot(1,2,2); hold on
            plot(r.pos_all','r')
            plot(mean(r.pos_all),'r','linewidth',2)
            plot(pos_good','k')
            plot(mean(pos_good),'k','linewidth',2)
            
            [pOpt y_fit y_mean] = get_response_onset(mean(vel_good_P,1)');
            
            % check if initiation time is less than 100 ms after
            % subtracting off 100 ms for analyzing 
            if pOpt(1) - 100 < 100
                t_init.(jumpSize{j}).(hands{i})(subj) = NaN;
                fit.(jumpSize{j}).(hands{i})(subj).pOpt = NaN(4,1);
            else
                t_init.(jumpSize{j}).(hands{i})(subj) = pOpt(1) - 100;
                fit.(jumpSize{j}).(hands{i})(subj).pOpt = pOpt;
            end
            
            fit.(jumpSize{j}).(hands{i})(subj).mean_vel = y_mean;
            fit.(jumpSize{j}).(hands{i})(subj).fitted_vel = y_fit;

            %keyboard
            
        end
    end
end
save Bimanual_init_fits t_init fit


%% plot results

col = [100 220 100
       70 110 255
       255 160 10]./255;

f = figure(3); clf; hold on
set(f,'Position',[200 200 200 150]);
for j = 1:length(jumpSize)
    for i = 1:length(hands)
        plot(2*(j-1)+0.5*i,t_init.(jumpSize{j}).(hands{i}),'.','Color',col(i,:),'MarkerSize',12,'HandleVisibility','off')
        plot(2*(j-1)+0.5*i,mean(t_init.(jumpSize{j}).(hands{i}),'omitnan'),'ok','MarkerFaceColor',col(i,:),'MarkerSize',6)
    end
end
axis([0 4 100 320])
xticks([1 3])
xticklabels([1.5 3])
xlabel('Jump size (cm)')
ylabel('Initiation time (ms)')
yticks(100:100:300)
% legend({'Left','Right','Bi'},'location','southeast')

print('C:/Users/Chris/Documents/Papers/bimanual/initation','-dpdf','-painters')

%% compare fits for unimanual and last bimanual block
%
for j= 1:2
    fhandle = figure(20+j); clf; hold
    set(fhandle,'Position',[200 200 1200 600]);
    set(fhandle,'Color','w');
    for subj = 1:Nsubj
        subplot(2,5,subj); hold on
        plot(fit.(jumpSize{j}).L(subj).mean_vel,'r','linewidth',2)
        plot(fit.(jumpSize{j}).R(subj).mean_vel,'g','linewidth',2)
        plot(fit.(jumpSize{j}).Bi(subj).mean_vel,'b','linewidth',2)
        
        plot(fit.(jumpSize{j}).L(subj).fitted_vel,'k','linewidth',1.5)
        plot(fit.(jumpSize{j}).L(subj).pOpt(1)*[1 1],[-.05 .15],'r')

        plot(fit.(jumpSize{j}).R(subj).fitted_vel,'k','linewidth',1.5)
        plot(fit.(jumpSize{j}).R(subj).pOpt(1)*[1 1],[-.05 .15],'g')
        
        plot(fit.(jumpSize{j}).Bi(subj).fitted_vel,'k','linewidth',1.5)
        plot(fit.(jumpSize{j}).Bi(subj).pOpt(1)*[1 1],[-.05 .15],'b')
        
        text(700,.1,['c = ',num2str(fit.(jumpSize{j}).L(subj).pOpt(4))],'color','r')
        text(700,.12,['c = ',num2str(fit.(jumpSize{j}).R(subj).pOpt(4))],'color','g')
        text(700,.14,['c = ',num2str(fit.(jumpSize{j}).Bi(subj).pOpt(4))],'color','b')
        
        if subj == 1
            legend('Left','Right','Bimanual','location','northwest')
            legend boxoff
        end
        xlim([0 1000])
        ylim([-.05 .15])
    end
end
