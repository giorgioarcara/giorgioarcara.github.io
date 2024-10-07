function eeglab2erpR(EEG, conditions,  number, export_name) 
% 
% eeglab2erpR() - Function to export data from eeglab .set to an erpR file.
%                 File will be exported with a file name obtained by the
%                 combination of 'export_name', 'condition', and 'number'.
%                 In erpR terminology, the combination of 'export_name' and
%                 'condition' will define the file 'base'. 
%
%  USAGE: 
%
%       eeglab2erpR(EEG, conditions,  base, number) 
% 
% 
%
% - EEG: an EEG dataset. you can specify it from the ALLEEG structure (e.g.
%       ALLEEG(2)).
%
% - conditions: the conditions to be averaged and then exported to erpR. 
%               condition is a cell containing cells specifying the 'type' 
%               labels of EEGLAB events that will be selected, averaged
%               and then exported in erpR format. If two or more  types are
%               averaged in one condition(see below how to do so) 
%               the name in the exported file will be obtained by merging the name of the conditions.
%
%               conditions = {{'condition_A'}}; export a single condition
%
%               conditions = {{'condition_A' 'condition_B'}}; % conditions A and B will be averaged and stored in the same file.
%    
%               conditions = {{'condition_A'} {'condition_B'}}; % conditions A and B will be stored in separate files.
%
%
% - number: the subject number in erpR language
%
% - export_name: OPTIONAL, an additional string to 
%                be added in the exported
% files
%
%  NOTE: You can easily incorporate this function in a cycle to quickly
%  export several subjects and conditions. 
%
% see in the page https://sites.google.com/site/giorgioarcara/erpr
% for an additional matlab script with an example of this cycle
%
% 
% Authors: Giorgio Arcara, 2016

if (nargin < 4)
    export_name='';
end;

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
                fprintf(num2str(number)) % show the exported subject
                fprintf('\n')
                conditions_name=struct2cell(EEG.event);
                conditions_name=conditions_name(1,:);

                EEGdata=pop_selectevent(EEG,'type',conditions{condit},'deleteevents','off','deleteepochs','on','invertepochs','off');            

                chanloc=struct2cell(EEGdata.chanlocs);
                chanloc=chanloc(1,:);
                Averagesubj=mean(EEGdata.data,3)';



                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%% EXPORT IN TXT
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                filename=strcat(export_name ,conditionsname{condit},'_subj',num2str(number),'.txt');
                fid = fopen(filename, 'w');
                fprintf(fid, '%s\t', EEG.filename);
                fprintf(fid, '\n', '');
                fprintf(fid, '%s\t', chanloc{:});
                fprintf(fid, '\n', '');
                for i=1:size(Averagesubj,1);%        
                    fprintf(fid, '%d\t', Averagesubj(i,:));
                    fprintf(fid, '\n', '');
                end;
                fclose(fid);  
            end;
end