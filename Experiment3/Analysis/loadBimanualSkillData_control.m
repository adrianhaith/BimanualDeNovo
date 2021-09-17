clear all
addpath ../../functions
addpath ../../Experiment1/Analysis
subjnames = {'S5','S6','S7','S8','S9','S10','S11','S12'}; % subjects to analyze
Nsubj = length(subjnames);

% path to data
path = '../Data/';

for subj = 1:Nsubj
    disp(['Subj ',num2str(subj),'/',num2str(Nsubj),' : ',subjnames{subj}]);
    disp('    Loading Subject Data...');
    
    % set parameters for analysese that vary across subjects
    if subj < 6
        readLine = 6; % starts reading data files after line 6
        start = [0.6 0.3]; % position of the starting target
    else
        readLine = 8;
        start = [0.6 0.25];
    end
    
    % load data 
    data.L = loadSubjData_control([path,subjnames{subj},'/Left'],{'B1','B2','B3','B4','B5'},readLine,start);
    data.R = loadSubjData_control([path,subjnames{subj},'/Right'],{'B1','B2','B3','B4','B5'},readLine,start);
    data.Bi = loadSubjData_control([path,subjnames{subj},'/Both'],{'B1','B2','B3','B4','B5'},readLine,start);

    % process data (smooth etc, rotate, get RT, etc.)
    disp('    Processing Data...')
    data.L = processData(data.L);
    data.R = processData(data.R);
    data.Bi = processData(data.Bi);

    % split into jump types
    disp('    Splitting data by jump type...')
    
    d{subj}.L = splitDatabyJump(data.L);
    d{subj}.R = splitDatabyJump(data.R);
    d{subj}.Bi = splitDatabyJump(data.Bi);
    
    % save data
    disp('    Saving...')
    fname = fullfile(['BimanualSkillData_S',num2str(subj)]);
    save(fname,'data')
end

save BimanualSkillData_control d
disp('All Done')
