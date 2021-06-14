clear all
subjnames = {   
    
                %'200.052',
                '200.071',
                '200.142',
                %'200.147',
                %'200.200',
                %
                '200.206',
                '200.213',
                '200.218',
                '200.223',
                %'200.233',
                %'200.243',
                %'200.247',
                '200.252',
                '200.256',
                '200.258',
                '200.259',
                '200.268',            
                '200.270',
                '200.271',
                };
               

%Nblocks = [11 10 10 10 10];
%data{1} = loadSubjData([subjname,'/D1'],{'B0'});
Nsubj = length(subjnames)

%path = '../../../Expt1_Data/';
path = '../Data/'
%
for subj = 1:Nsubj%length(subjnames)
    clear data
    disp(['Subj ',num2str(subj),'/',num2str(Nsubj),' : ',subjnames{subj}]);
    disp('    Loading Subject Data...');
    dayNums = [1 2 3 4];
    data.BiInit = loadSubjData([path,subjnames{subj},'/D1'],{'B2'}); % Day 1 chunk
    data.Bi{1} = loadSubjData([path,subjnames{subj},'/D1'],{'B3','B4','B5','B6','B7'}); % Day 1 chunk
    for i=2:4
        data.Bi{2*(i-1)} = loadSubjData([path,subjnames{subj},'/D',num2str(i)],{'B1','B2','B3','B4','B5'}); % Middle Day, chunk 1
        data.Bi{2*(i-1)+1} = loadSubjData([path,subjnames{subj},'/D',num2str(i)],{'B6','B7','B8','B9','B10'}); % Middle Day, chunk 2
    end
    data.Uni{1} = loadSubjData([path,subjnames{subj},'/D5'],{'B1','B2','B3','B4','B5'}); % Unimanual chunk 1
    data.Uni{2} = loadSubjData([path,subjnames{subj},'/D5'],{'B6','B7','B8','B9','B10'}); % Unimanual chunk 2
    
    data.nojmp.Uni1 = loadSubjData([path,subjnames{subj},'/D1'],{'B1'}); % Uni pre (no jumps)
    data.nojmp.Uni2 = loadSubjData([path,subjnames{subj},'/D1'],{'B8'}); % Uni post (no jumps)
%end

%save BimanualSkillData_raw
%}
%%
%clear all
%load BimanualSkillData_raw


%for subj = 1:Nsubj
    % process data (smooth etc, rotate, get RT, etc.)
    disp(['Subj ',num2str(subj),'/',num2str(Nsubj),' : ',subjnames{subj}]);
    disp('    Processing Data...')
    for i=1:length(data.Bi)
        data.Bi{i} = processData(data.Bi{i});
    end
    for i=1:length(data.Uni)
        data.Uni{i} = processData(data.Uni{i});
    end
    data.nojmp.Uni1 = processData(data.nojmp.Uni1);
    data.nojmp.Uni2 = processData(data.nojmp.Uni2);

    % split into jump types
    disp('    Splitting data by jump type...')
    for i=1:length(data.Uni)
        d{subj}.Uni{i} = splitDatabyJump(data.Uni{i});
    end

    for i=1:length(data.Bi)
        d{subj}.Bi{i} = splitDatabyJump(data.Bi{i});
    end
    
    d{subj}.BiInit = processData(data.BiInit);

%for subj=1:length(subjnames)
    d{subj}.Uni_nojmp{1} = data.nojmp.Uni1;
    d{subj}.Uni_nojmp{2} = data.nojmp.Uni2;
    
    % save data
    disp('    Saving...')
    fname = fullfile([path,'BimanualSkillData_S',num2str(subj)]);
    save(fname,'data')
end
    
%%
fname = fullfile([path,'BimanualSkillData']);
save(fname,'d');
disp('All Done')
