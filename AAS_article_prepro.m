%ALPHA ASYMMETRY ARTICLE preprocessing
%Beginning of the script:
% This command clears the workspace.
clear all, clc
% Sets the filepath, so MATLAB knows where to find the data.
filepath = 'G:\Iris\rawdata (stimuli)\\';
% Loop for running preprocessing per subject
for subjID = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38]
% Loads the EEG data per subject
 n = subjID
 EEG = pop_loadset('filename',['S' num2str(subjID) '.set'],'filepath', 'G:\xxx\rawdata (stimuli)\');

% Renaming the data
 loadName = num2str(subjID);
 dataName = loadName(1:end-4);

% Creating copy of dataset.
 EEG.setname = dataName;

% Down sample the data.
EEG = pop_resample(EEG, 256);

% High-pass filter the data at 1-Hz. Note that EEGLAB uses pass-band edge, therefore 1/2 = 0.5 Hz.
EEG = pop_eegfiltnew(EEG, 1, [], 1650, 0, [], 0);
% Import channel info
EEG = pop_eegfiltnew(EEG, [], 40, 166, 0, [], 0);
EEG=pop_chanedit(EEG, 'load',{'J:\\66electr.ced' 'filetype' 'autodetect'});

% Delete eye channels
EEG = pop_select( EEG,'nochannel',{'HEOG' 'VEOG'});
% Reject bad channels probability of 2
EEG = pop_rejchan(EEG, 'elec',[1:64] ,'threshold',2,'norm','on','measure','prob');
% Re-reference the data to average,
 EEG.nbchan = EEG.nbchan+1;
 EEG.data(end+1,:) = zeros(1, EEG.pnts);
 EEG.chanlocs(1,EEG.nbchan).labels = 'initialReference';
EEG = pop_reref(EEG, []);
 EEG = pop_select( EEG,'nochannel',{'initialReference'});
% Epoching data per category
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, { '10' '20' '30' '40' }, [-0.5 6], 'newname', ' resampled epochs', 'epochinfo', 'yes');
% Reject bad trials by means of kurtosis
EEG = pop_rejkurt(EEG,1,[1:EEG.nbchan] ,5,5,1,1);
EEG = eeg_checkset( EEG );
% Run ICA
Run ICA
% Save new data set
EEG = pop_saveset( EEG, 'filename',['S' num2str(n) 'prepocessed.set'],'filepath','G:\xxx\rawdata
(stimuli)\remarked\remarkepreprocessed\\');
end