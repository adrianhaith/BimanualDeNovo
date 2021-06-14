% test yoking metric
clear all

% load non-yoking subject
subjNum = 9;
fname = fullfile('../../../','Expt1_data',['BimanualSkillData_S',num2str(subjNum)])
load(fname)

% look on last day
figure(1); clf; hold on
blockNum = 2;
Lall = [];
Rall = [];
for i = 1:60 % random trial to examine yoking
    L = data.Bi{blockNum}.L{i};
    R = data.Bi{blockNum}.R{i}
    C = data.Bi{blockNum}.C{i};
    
    plot(L(:,1),L(:,2),'g')
    plot(R(:,1),R(:,2),'r')
    plot(C(:,1),C(:,2),'b')
    
    Lall = [Lall; L];
    Rall = [Rall; R];
end

figure(2); clf; hold on
for i = 1:60 % random trial to examine yoking
    L = data.Bi{blockNum}.L{i};
    R = data.Bi{blockNum}.R{i};
    subplot(2,2,1); hold on
    plot(L(:,1),R(:,1))
    subplot(2,2,2); hold on
    plot(L(:,2),R(:,1))
    subplot(2,2,3); hold on
    plot(L(:,1),R(:,2))
    subplot(2,2,4); hold on
    plot(L(:,2),R(:,2))
end

yoking = corr(Lall,Rall);

%% load yoking subject

subjNum = 7;
fname = fullfile('../../../','Expt1_data',['BimanualSkillData_S',num2str(subjNum)])
load(fname)