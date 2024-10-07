%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EXPORT FROM EEGLAB TO erpR (0.2) %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script contains a simple loop to allow
% exporting multiple files from EEGLAB to 
% to files suitable to be imported with erpR.

% To export the data follow these steps:

% 1) be sure that the eeglab2erpR.m function is in the current directory
%   or in an attached path. You can download the function here
%   https://sites.google.com/site/giorgioarcara/erpr
%
% 2) load all dataset you want to export in EEGLAB.
%
% 3) change all parameters needed in this script. Below there is a section
%   of code with parameters to be changed. Be careful in setting
%   all the required parameters.
% 
% 4) run this script (simply typing the command 
%  export_cycle_with_eeglab2erpR on the matlab prompt).

% All exported datasets will be saved in the current MATLAB directory.

% NOTE: The script won't work if any of the datasets does
% not contain at least one epoch for each condition specified.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PARAMETER SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%
%%% SELECT CONDITIONS 
%%%%%%%%%%

% the object 'condition' specifies the conditions to be exported, that is the 'type' labels of EEG events will be selected, averaged, and then exported in erpR format.
% If two or more types are averaged in one condition(see below how to do so) the name in the
% exported file will be obtained by merging the name of the conditions.

% conditions = {{'condition_A'}}; export a single condition

%conditions={{'condition_A' 'condition_B'}}; % conditions A and B will be averaged and stored in the same file.
    
conditions={{'condition_A'} {'condition_B'}}; % conditions A and B will be stored in separate files.

%%%%%%%%%%%
%%% SELECT DATASETS TO BE INCLUDED 
%%%%%%%%%%%

% The object 'datasets' specifies the datasets to be exported.
% As default all datasets in ALLEEG are exported but optionally, you can
% specify the numbers of the datasets
    
 datasets=1:10 % this will export only dataset from 1 to 10
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SELECT NUMBERS TO BE USED IN FILE NAMING %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

% The numbers to be attached at the end of the individual files.
% Each number will codify a specific subject, and all files ending with
% the same number are referred to the same subject.

% NOTE:  numbers can be different from 'datasets'. For example, you 
% may want to export the first 5 datasets from EEGLAB (datasets = 1:5), 
% but with 'number' from 10 to 15 (numbers = 10:15).

numbers=1:10

%%%%%%%%%%%%%%%%%%%%%%
%%% SET EXPORT NAME %%
%%%%%%%%%%%%%%%%%%%%%%   

% this object specifies the initial string of all the exported data
% This is usually the name of the experiment.
    
export_name='Experiment1_'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% !!! END OF PARAMETER SETTINGS !!! %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for s = 1:length(datasets)
    
    eeglab2erpR(ALLEEG(datasets(s)), conditions,  numbers(s), export_name) 
    
end;




