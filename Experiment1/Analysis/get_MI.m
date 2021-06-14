function [MI H_joint H_target H_action] = get_MI(targetDir,reachDir,bins)
% estimate mutual information between target direction and reach direction

% make sure directions are in [-180 180]
reachDir(reachDir>180) = reachDir(reachDir>180)-360;
reachDir(reachDir<-180) = reachDir(reachDir<-180)+360;

targetDir(targetDir>180) = targetDir(targetDir>180)-360;
targetDir(targetDir<-180) = targetDir(targetDir<-180)+360;


% discretize data by binning
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

% regularize distribution for numerical stability
eps = .00001;
w = eps/numel(Pj);
PjN = w*ones + (1-eps)*Pj;

H_joint = -sum(sum(PjN.*log(PjN)));

p_targ = sum(N')/sum(sum(N));
w = eps/numel(p_targ);
p_targN = w*ones + (1-eps)*p_targ;
H_target = -sum(p_targN.*log(p_targN));

p_action = sum(N)/sum(sum(N));
w = eps/numel(p_action);
p_actionN = w*ones + (1-eps)*p_action;
H_action = -sum(p_actionN.*log(p_actionN));
MI = H_target + H_action - H_joint;