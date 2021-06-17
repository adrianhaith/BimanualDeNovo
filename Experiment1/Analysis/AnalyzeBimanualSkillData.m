clear all
addpath ../../functions
load ../../../Expt1_data/BimanualSkillData
%load BimanualSkillData

% data structures:
%       d{subject}.Bi{chunk}{perturbation}
%           1 'chunk' on day 1, 2 chunks on subsequent days
%           perturbation types: [-3cm -1.5cm 0cm 1.5cm 3cm never];
%               'never' includes trials that are never perturbed in any block
%

%% Basic performance - No-jump trials
% path length - all
% bad subjs = [7
for subj = 1:length(d)
    Nday = 4;
    Nchunk = 7;
    NchunkUni = 2;

    Nbin = 40; % number of trials to bin together

    for chunk=1:Nchunk
        % null path length
        dAll.Bi.pathLength(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Bi{chunk}{6}.pathlength,Nbin);
        dAll.Bi.pathLength_null(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Bi{chunk}{6}.pathlength_null,Nbin);
        dAll.Bi.pathLength_ratio(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Bi{chunk}{6}.pathlength_null./d{subj}.Bi{chunk}{6}.pathlength,Nbin);
        dAll.Bi.movDur(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Bi{chunk}{6}.movtime,Nbin);
        dAll.Bi.RT(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Bi{chunk}{6}.RT,Nbin)-100;
        dAll.Bi.pkVel(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Bi{chunk}{6}.pkVel,Nbin);
        dAll.Bi.pkVel_1s(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Bi{chunk}{6}.pkVel_1s,Nbin);
        dAll.Bi.initDir(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Bi{chunk}{6}.initDir,Nbin);
    end

    for chunk = 1:NchunkUni
        dAll.Uni.pathLength(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Uni{chunk}{6}.pathlength,Nbin);
        dAll.Uni.pathLength_null(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Uni{chunk}{6}.pathlength_null,Nbin);
        dAll.Uni.pathLength_ratio(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Uni{chunk}{6}.pathlength_null./d{subj}.Bi{chunk}{6}.pathlength,Nbin);
        dAll.Uni.movDur(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Uni{chunk}{6}.movtime,Nbin);
        dAll.Uni.RT(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Uni{chunk}{6}.RT,Nbin)-100; 
        dAll.Uni.pkVel(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Uni{chunk}{6}.pkVel,Nbin);
        dAll.Uni.pkVel_1s(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Uni{chunk}{6}.pkVel_1s,Nbin);
        dAll.Uni.initDir(subj,5*(chunk-1)+[1:5]) = binData(d{subj}.Uni{chunk}{6}.initDir,Nbin);
    end

    % unimanual no-jump data
    dAll.UniNoJmp.pathLength(subj,:) = [d{subj}.Uni_nojmp{1}.pathlength d{subj}.Uni_nojmp{2}.pathlength];
    dAll.UniNoJmp.movDur(subj,:) = [d{subj}.Uni_nojmp{1}.movtime d{subj}.Uni_nojmp{2}.movtime];
    dAll.UniNoJmp.RT(subj,:) = [d{subj}.Uni_nojmp{1}.RT d{subj}.Uni_nojmp{2}.RT];
    dAll.UniNoJmp.pkVel(subj,:) = [d{subj}.Uni_nojmp{1}.pkVel d{subj}.Uni_nojmp{2}.pkVel];
    dAll.UniNoJmp.pkVel_1s(subj,:) = [d{subj}.Uni_nojmp{1}.pkVel_1s d{subj}.Uni_nojmp{2}.pkVel_1s];
    dAll.UniNoJmp.initDir(subj,:) = [d{subj}.Uni_nojmp{1}.initDir d{subj}.Uni_nojmp{2}.initDir];
    
    % initial bimanual data
    dAll.BiInit.pathLength(subj,:) = d{subj}.BiInit.pathlength;
    dAll.BiInit.movDur(subj,:) = d{subj}.BiInit.movtime;
    dAll.BiInit.RT(subj,:) = d{subj}.BiInit.RT;
    dAll.BiInit.pkVel(subj,:) = d{subj}.BiInit.pkVel;
    dAll.BiInit.pkVel_1s(subj,:) = d{subj}.BiInit.pkVel_1s;
    dAll.BiInit.initDir(subj,:) = d{subj}.BiInit.initDir;
    
    %-- Perturbation response - velocity------------------------
    Dend = Nchunk; % last day
    dt = 1/130;

    % Bimanual
    %cCol = [linspace(0.3,1,Nchunk)' linspace(.3,0,Nchunk)' linspace(.3,0,Nchunk)'];
    for c = 1:Nchunk
        r = getResponses([-d{subj}.Bi{c}{1}.CrX_post ; d{subj}.Bi{c}{5}.CrX_post],.03,dt);
        dAll.Bi.response_large.pos(subj,:,c) = r.pos;
        dAll.Bi.response_large.vel(subj,:,c) = r.vel;
        dAll.Bi.response_large.vel_var(subj,:,c) = r.vel_var;
        dAll.time = r.time;
        
        r = getResponses([-d{subj}.Bi{c}{2}.CrX_post ; d{subj}.Bi{c}{4}.CrX_post],.015,dt);
        dAll.Bi.response_small.pos(subj,:,c) = r.pos;
        dAll.Bi.response_small.vel(subj,:,c) = r.vel;
        dAll.Bi.response_small.vel_var(subj,:,c) = r.vel_var;
        
        r = getResponses(d{subj}.Bi{c}{3}.CrX_post,0,dt);
        dAll.Bi.response_nojmp.pos(subj,:,c) = r.pos;
        dAll.Bi.response_nojmp.vel(subj,:,c) = r.vel;
        dAll.Bi.response_nojmp.vel_var(subj,:,c) = r.vel_var;
    end
    % unimanual
    for c=1:2 % 
        r = getResponses([-d{subj}.Uni{c}{1}.CrX_post ; d{subj}.Uni{c}{5}.CrX_post],.03,dt);
        dAll.Uni.response_large.pos(subj,:,c) = r.pos;
        dAll.Uni.response_large.vel(subj,:,c) = r.vel;
        dAll.Uni.response_large.vel_var(subj,:,c) = r.vel_var;
        
        r = getResponses([-d{subj}.Uni{c}{2}.CrX_post ; d{subj}.Uni{c}{4}.CrX_post],.015,dt);
        dAll.Uni.response_small.pos(subj,:,c) = r.pos;
        dAll.Uni.response_small.vel(subj,:,c) = r.vel;
        dAll.Uni.response_small.vel_var(subj,:,c) = r.vel_var;
        
        r = getResponses(d{subj}.Uni{c}{3}.CrX_post,0,dt);
        dAll.Uni.response_nojmp.pos(subj,:,c) = r.pos;
        dAll.Uni.response_nojmp.vel(subj,:,c) = r.vel;
        dAll.Uni.response_nojmp.vel_var(subj,:,c) = r.vel_var;
    end

    % average response over a time window
    rng = 51:70; % range to examine feedback response

    for c =1:Nchunk
        for pert = 1:5
            %average response in a window
            dAll.Bi.pResponseAv(pert,c,subj) = nanmean(nanmean(diff(d{subj}.Bi{c}{pert}.CrX_post(:,rng)'))');
            dAll.Uni.pResponseAv(pert,subj) = nanmean(nanmean(diff(d{subj}.Uni{1}{pert}.CrX_post(:,rng)'))');
            
            % peak response and latency
            [dAll.Bi.peakResponse_large(subj,c), dAll.Bi.peakResponse_lat_large(subj,c)] = max(dAll.Bi.response_large.vel(subj,:,c));
            [dAll.Bi.peakResponse_small(subj,c), dAll.Bi.peakResponse_lat_small(subj,c)] = max(dAll.Bi.response_small.vel(subj,:,c));
            [dAll.Bi.peakResponse_nojmp(subj,c), dAll.Bi.peakResponse_lat_nojmp(subj,c)] = max(dAll.Bi.response_nojmp.vel(subj,:,c));
        end
    end
    
    for c=1:NchunkUni
        for pert = 1:5
            [dAll.Uni.peakResponse_large(subj,c), dAll.Uni.peakResponse_lat_large(subj,c)] = max(dAll.Uni.response_large.vel(subj,:,c));
            [dAll.Uni.peakResponse_small(subj,c), dAll.Uni.peakResponse_lat_small(subj,c)] = max(dAll.Uni.response_small.vel(subj,:,c));
            [dAll.Uni.peakResponse_nojmp(subj,c), dAll.Uni.peakResponse_lat_nojmp(subj,c)] = max(dAll.Uni.response_nojmp.vel(subj,:,c));
        end
    end
    
end

%%

save Bimanual_compact dAll

