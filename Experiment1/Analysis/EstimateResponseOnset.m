% find time of response onset for corrections
clear all
close all
addpath ../Data/
load BimanualSkillData.mat
Nblk = 7;
Nsubj = 13;

%%
init_vel_thr = 0.2; % initial velocity threshold. Exclude trials which exceed this prior to target jump
init_pos_thr = 0.05; % initial position threshold.
dt = 1/130;
t_init_Bi = NaN*ones(Nsubj,Nblk);

for subj=1:Nsubj
    for j = 1:2
        for blk = 3:7
         % jumpsize
            disp(['subject ',num2str(subj),', block ',num2str(blk)])
            
            % Bimanual, large jumps
            if(j == 1)
                % small jumps
                %r = getResponses([-d{subj}.Bi{blk}{2}.CrX_post; d{subj}.Bi{blk}{4}.CrX_post],.015,dt);
                % include an extra 100 ms before the target jump
                r = getResponses([-[d{subj}.Bi{blk}{2}.CrX_pre(:,end-13:end) d{subj}.Bi{blk}{2}.CrX_post]; [d{subj}.Bi{blk}{4}.CrX_pre(:,end-13:end) d{subj}.Bi{blk}{4}.CrX_post]],.015,dt);
            else
                % large jumps
                %r = getResponses([-d{subj}.Bi{blk}{1}.CrX_post; d{subj}.Bi{blk}{5}.CrX_post],.03,dt);
                % include an extra 100 ms before the target jump
                r = getResponses([-[d{subj}.Bi{blk}{1}.CrX_pre(:,end-13:end) d{subj}.Bi{blk}{1}.CrX_post]; [d{subj}.Bi{blk}{5}.CrX_pre(:,end-13:end) d{subj}.Bi{blk}{5}.CrX_post]],.03,dt);
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
            
            fit.Bi(subj,blk,j).Ngood = size(vel_good_P,1);
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
            t_init_Bi(subj,blk,j) = pOpt(1);
            fit.Bi(subj,blk,j).pOpt = pOpt;
            fit.Bi(subj,blk,j).mean_vel = y_mean;
            fit.Bi(subj,blk,j).fitted_vel = y_fit;

            %keyboard
            
        end
    end
end

%% same for Unimanual data

t_init_Uni = NaN*ones(Nsubj,2);
for subj=1:Nsubj
    for blk = 1:2
        for j=1:2
            disp(['subject ',num2str(subj),', block ',num2str(blk)])
            
            % Bimanual, large jumps
            if(j == 1)
                % small jumps
                %r = getResponses([-d{subj}.Uni{blk}{2}.CrX_post; d{subj}.Uni{blk}{4}.CrX_post],.015,dt);
                % include an extra 100 ms before the target jump
                r = getResponses([-[d{subj}.Uni{blk}{2}.CrX_pre(:,end-13:end) d{subj}.Uni{blk}{2}.CrX_post]; [d{subj}.Uni{blk}{4}.CrX_pre(:,end-13:end) d{subj}.Uni{blk}{4}.CrX_post]],.015,dt);
            else
                % large jumps
                %r = getResponses([-d{subj}.Uni{blk}{1}.CrX_post; d{subj}.Uni{blk}{5}.CrX_post],.03,dt);
                % include an extra 100 ms before the target jump
                r = getResponses([-[d{subj}.Uni{blk}{1}.CrX_pre(:,end-13:end) d{subj}.Uni{blk}{1}.CrX_post]; [d{subj}.Uni{blk}{5}.CrX_pre(:,end-13:end) d{subj}.Uni{blk}{5}.CrX_post]],.03,dt);
            end
            
            init_vel = r.vel_all(:,1:pre_window); % first 260ms
            init_vel_bad = max(abs(init_vel)>init_vel_thr,[],2);
            
            init_pos = r.pos_all(:,1:pre_window);
            init_pos_bad = max(abs(init_pos)>init_pos_thr,[],2);
            
            vel_good = r.vel_all(~init_vel_bad,:);
            pos_good = r.pos_all(~init_pos_bad,:);
            vel_good_P = r.vel_all(~init_pos_bad,:);
            vel_good_P = r.vel_all((~init_pos_bad)&(~init_vel_bad),:);
            
            fit.Uni(subj,blk,j).Ngood = size(vel_good_P,1);
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
            t_init_Uni(subj,blk,j) = pOpt(1);
            fit.Uni(subj,blk,j).pOpt = pOpt
            fit.Uni(subj,blk,j).mean_vel = y_mean;
            fit.Uni(subj,blk,j).fitted_vel = y_fit;
            
            %keyboard
        end
    end
end

% save fits
save Bimanual_init_fits t_init_Bi t_init_Uni fit


%% plot results

clear all
load Bimanual_init_fits
figure(3); clf; hold on

t_init_Bi(7,5,1) = NaN;

plot(nanmean(t_init_Bi(:,3:end,1)),'b.-','linewidth',2)
plot(nanmean(t_init_Bi(:,3:end,2)),'g.-','linewidth',2)
plot([6 7],nanmean(t_init_Uni(:,:,1)),'k.-','linewidth',2)
plot([6 7],nanmean(t_init_Uni(:,:,2)),'.-','linewidth',2,'color',[.5 .5 .5])

plot(t_init_Bi(:,3:end,1)','b.-')
plot(t_init_Bi(:,3:end,2)','g.-')

plot([6 7],t_init_Uni(:,:,1),'k.-')
plot([6 7],t_init_Uni(:,:,2),'.-','color',.5*[1 1 1])

legend('Bimanual 3-7','Unimanual 1-2')

%%
%{
%small jumps
fhandle = figure(4); clf; hold
set(fhandle,'Position',[200 500 1200 250]);
set(fhandle,'Color','w');

subplot(1,3,1); hold on
plot(t_init_Uni(:,1,1),t_init_Uni(:,2,1),'ko')
axis equal
plot([100 300],[100 300],'k')
xlabel('Unimanual 1')
ylabel('Unimanual 2')

subplot(1,3,2); hold on
plot(t_init_Uni(:,2,1),t_init_Bi(:,6,1),'ro')
axis equal
plot([100 300],[100 300],'k')
xlabel('Unimanual 2')
ylabel('Bimanual 6')

subplot(1,3,3); hold on
plot(t_init_Uni(:,2,1),t_init_Bi(:,7,1),'ro')
axis equal
plot([100 300],[100 300],'k')
xlabel('Unimanual 2')
ylabel('Bimanual 7')

% large jumps
fhandle = figure(5); clf; hold
set(fhandle,'Position',[200 150 1200 250]);
set(fhandle,'Color','w');

subplot(1,3,1); hold on
plot(t_init_Uni(:,1,2),t_init_Uni(:,2,2),'ko')
axis equal
plot([100 300],[100 300],'k')
xlabel('Unimanual 1')
ylabel('Unimanual 2')

subplot(1,3,2); hold on
plot(t_init_Uni(:,2,2),t_init_Bi(:,6,2),'ro')
axis equal
plot([100 300],[100 300],'k')
xlabel('Unimanual 2')
ylabel('Bimanual 6')

subplot(1,3,3); hold on
plot(t_init_Uni(:,2,2),t_init_Bi(:,7,2),'ro')
axis equal
plot([100 300],[100 300],'k')
xlabel('Unimanual 2')
ylabel('Bimanual 7')

%}
%% compare fits for unimanual and last bimanual block
%
Nsubj = 13;
for j=1:2
    fhandle = figure(30+j); clf; hold
    set(fhandle,'Position',[200 200 1200 600]);
    set(fhandle,'Color','w');
    for subj = 1:Nsubj
        subplot(3,5,subj); hold on
        plot(fit.Uni(subj,2,j).mean_vel,'k','linewidth',2)
        plot(fit.Bi(subj,7,j).mean_vel,'b','linewidth',2)
        
        plot(fit.Uni(subj,2,j).fitted_vel,'r','linewidth',2)
        plot(fit.Uni(subj,2,j).pOpt(1)*[1 1],[-.05 .15],'k')
        
        
        plot(fit.Bi(subj,7,j).fitted_vel,'g','linewidth',2)
        plot(fit.Bi(subj,7,j).pOpt(1)*[1 1],[-.05 .15],'b')
        
        text(700,.1,['c = ',num2str(fit.Bi(subj,7,j).pOpt(4))],'color','b')
        text(700,.12,['c = ',num2str(fit.Uni(subj,2,j).pOpt(4))],'color','k')
        
        legend('Unimanual 2','Bimanual 7','location','Southeast')
        legend boxoff
        xlim([0 1000])
        ylim([-.05 .15])
    end
end


