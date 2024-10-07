%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EXPORT FROM EEGLAB TO erpR (0.2) %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script exports data from (epoched) eeglab dataset
% to files suitable to be imported with erpR.
% To export the data follow these steps:

% 1) load all dataset you want to export in eeglab.
%
% 2) change all parameters needed in this sript. Below there is a section
%   of code with parameters to be changed. Be careful in setting
%   all the required parameters.
% 
% 3) run this script (simply typing the command 
%   export_eeglab2erpR on the matlab prompt).

% Once you run the script, you will be asked to select a directory. 
% All exported datasets will be saved in this directory.

% NOTE: The script won't work if any of the datasets does
% not contain at least one epoch for each condition specified.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PARAMETER SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SELECT CONDITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the object 'condition' specifies the conditions to be exported, that is the 'type' labels of EEG events will be selected, averaged, and then exported in erpR format.
% If two or more types are averaged in one condition(see below how to do so) the name in the
% exported file will be obtained by merging the name of the conditions.

%conditions={{'condition_A' 'condition_B'}}; % conditions A and B will be averaged and stored in the same file.
    
conditions={{'condition_A'} {'condition_B'}}; % conditions A and B will be stored in separate files.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SELECT DATASETS TO BE INCLUDED %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The object 'datasettouse' specifies the datasets to be exported.
% As default all datasets in ALLEEG are exported but optionally, you can
% specify the numbers of the datasets
    
    datasettouse=1:10 % this will export only dataset from 1 to 10.
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SELECT NUMBERS TO BE USED IN FILE NAMING %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

% The numbers to be attached at the end of the individual files.
% Each number will codify a specific subject, and all files ending with
% the same number are referred to the same subject

numbers=1:10


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
%%% SET EXPORT NAME %%
%%%%%%%%%%%%%%%%%%%%%%   
% this objects specifies the initial string of all the exported data
% This is usually the name of the experiment.
    
    export_name='Experiment1_'
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% !!! END OF PARAMETER SETTINGS !!! %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



seldir=uigetdir('')


    
    fprintf('The export will be performed on the following datasets:\n')
    datasettouse
  
    conditionsname={};
    for i=1:size(conditions,2);
       mergedname=[];
       for k=1:size(conditions{i},2);
           mergedname=strcat(mergedname, conditions{i}{k});
       end;
       conditionsname{i}=mergedname;
    end;
    Allsubjectconditions={};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
 for  condit=1:size(conditions,2)
        for myfile=1:size(datasettouse,2);
		number=numbers(myfile);
            fprintf(num2str(number)) % show the exported subject
            fprintf('\n')
            EEGset = ALLEEG(datasettouse(1,myfile));
            conditions_name=struct2cell(EEGset.event);
            conditions_name=conditions_name(1,:);
            
            EEGdata=pop_selectevent(EEGset,'type',conditions{condit},'deleteevents','off','deleteepochs','on','invertepochs','off');            
                
            chanloc=struct2cell(EEGdata.chanlocs);
            chanloc=chanloc(1,:);
            Averagesubj=mean(EEGdata.data,3)';
             
       

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% EXPORT IN TXT
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            filename=strcat(seldir, '/', export_name ,conditionsname{condit},'_subj',num2str(numbers(myfile)),'.txt');
            fid = fopen(filename, 'w');
            fprintf(fid, '%s\t', EEGset.filename);
            fprintf(fid, '\n', '');
            fprintf(fid, '%s\t', chanloc{:});
            fprintf(fid, '\n', '');
            for i=1:size(Averagesubj,1);%        
                fprintf(fid, '%d\t', Averagesubj(i,:));
                fprintf(fid, '\n', '');
            end;
            fclose(fid);  
        end;
end;
    
