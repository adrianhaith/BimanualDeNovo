clear all
addpath ../../Experiment1/Analysis
addpath ../../functions
load BimanualSkillData_control

% data structures:
%       d{subject}.(hand){perturbation}
%           hand: L (left), R (right), or Bi (bimanual)
%           perturbation types: [-3cm -1.5cm 0cm 1.5cm 3cm never];
%               'never' includes trials that are never perturbed in any block

%% Basic performance - No-jump trials

hands = {'L','R','Bi'};
dt = 1/130;

% average response over a time window
rng = 51:70; % range to examine feedback response

for subj = 1:length(d)

    Nbin = 40; % number of trials to bin together
    
    for i = 1:length(hands)
        dAll.(hands{i}).pathLength(subj,:) = binData(d{subj}.(hands{i}){6}.pathlength,Nbin); % path length
        dAll.(hands{i}).pathLength_null(subj,:) = binData(d{subj}.(hands{i}){6}.pathlength_null,Nbin); % path length in null space
        dAll.(hands{i}).movDur(subj,:) = binData(d{subj}.(hands{i}){6}.movtime,Nbin); % movement duration
        dAll.(hands{i}).RT(subj,:) = binData(d{subj}.(hands{i}){6}.RT,Nbin)-100; % reaction time
        dAll.(hands{i}).pkVel(subj,:) = binData(d{subj}.(hands{i}){6}.pkVel,Nbin); % peak velocity
        dAll.(hands{i}).pkVel_1s(subj,:) = binData(d{subj}.(hands{i}){6}.pkVel_1s,Nbin);
        dAll.(hands{i}).initDir(subj,:) = binData(d{subj}.(hands{i}){6}.initDir,Nbin); % initial reach direction

        %-- Perturbation response - velocity------------------------
        
        % large jumps
        r = getResponses([-d{subj}.(hands{i}){1}.CrX_post ; d{subj}.(hands{i}){5}.CrX_post],.03,dt);
        dAll.(hands{i}).response_large.pos(subj,:) = r.pos;
        dAll.(hands{i}).response_large.vel(subj,:) = r.vel;
        dAll.(hands{i}).response_large.vel_var(subj,:) = r.vel_var;
        dAll.time = r.time;
        
        % small jumps
        r = getResponses([-d{subj}.(hands{i}){2}.CrX_post ; d{subj}.(hands{i}){4}.CrX_post],.015,dt);
        dAll.(hands{i}).response_small.pos(subj,:) = r.pos;
        dAll.(hands{i}).response_small.vel(subj,:) = r.vel;
        dAll.(hands{i}).response_small.vel_var(subj,:) = r.vel_var;
        
        % no jumps
        r = getResponses(d{subj}.(hands{i}){3}.CrX_post,0,dt);
        dAll.(hands{i}).response_nojmp.pos(subj,:) = r.pos;
        dAll.(hands{i}).response_nojmp.vel(subj,:) = r.vel;
        dAll.(hands{i}).response_nojmp.vel_var(subj,:) = r.vel_var;
        
        for pert = 1:5
            [dAll.(hands{i}).peakResponse_large(subj), dAll.(hands{i}).peakResponse_lat_large(subj)] = max(dAll.(hands{i}).response_large.vel(subj,:));
            [dAll.(hands{i}).peakResponse_small(subj), dAll.(hands{i}).peakResponse_lat_small(subj)] = max(dAll.(hands{i}).response_small.vel(subj,:));
            [dAll.(hands{i}).peakResponse_nojmp(subj), dAll.(hands{i}).peakResponse_lat_nojmp(subj)] = max(dAll.(hands{i}).response_nojmp.vel(subj,:));
        end
    end
end

%%

save Bimanual_control_compact dAll

