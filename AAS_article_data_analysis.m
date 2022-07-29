%%Data analysis

% To create a clear workspace
close all
clear all
% Creating the necessary empty variables
numberapochs = 0;
validmarkers = [];
done2 = 0;
done = 0;

% Argument for newtimef() function
 plotres = 'off';
 morlet = [0] % if 0 Fast Fourier Transform is applied
 baselinev = 0
 timesoutvalue = 200

% Loop for running data analysis per subject
for subj = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38]
% Loads the EEG data per subject
EEG = pop_loadset('filename',['S' num2str(subj) '.set'],'filepath', 'G:\Iris\output
(stimuli)1h\MARAD\interpolated\CSDed\New markers\');
% creates copy of loaded EEG data
EEG2 = EEG;
% trigger variables
done = 0;
done2 = 0;
numberapochs = 0; % number of epoch variable
% stimulus rating
for stimulus = [1:4];
done2 = 0;
% valence rating
for valence = [1:3];
done2 = 0;

% arousal rating
for arousal = [1:9];
done2 = 0;
% motivational-direction rating
for aw = [1:9];
done2 = 0;

% marker number computation
stimulusnumber = (stimulus)+((valence)*10)+((arousal)*100)+((aw)*1000);
% marker computation in string format (for the epoching function)
stimulusnumber2 = num2str(stimulusnumber);
% Look that individuates the the marker in the EEG file

for i = 1:length(EEG.event);
% if marker is found
 if done2 == 0;
 if EEG.event(i).type == (stimulusnumber);
% Epoching
EEG = pop_epoch( EEG, {stimulusnumber2} , [-0.5 6], 'newname', ' resampled epochs', 'epochinfo', 'yes');
% Baseline correction EEG = pop_rmbase( EEG, [-500 0]);
 done = 1;
% Increase of epoch number
 numberapochs = numberapochs+1;
 if numberapochs == 1;
 validmarkers = cat(3, EEG.data);
% EEG comes back to the copied EEG per subject EEG = EEG2;
done2 = 1;
% Increase of epoch number
else
validmarkers = cat(3, EEG.data, validmarkers);
 EEG = EEG2;
 done2 = 1;
 end
 end
 end
 end
 end
 end
 end
end
if done == 1

% clustering the right electrodes
include_chans_right = [4 12 50];
% clustering the left electrodes
include_chans_left = [3 11 49];
% Compute data for right cluster
right_data = squeeze(mean(validmarkers(include_chans_right,:,:),1));
% Compute data for left cluster
left_data = squeeze(mean(validmarkers(include_chans_left,:,:),1));
% Computing spectral power for right and left data clusters
[ersp,itc,powbase,times,freqs] = newtimef(right_data, EEG.pnts, [-500 4000], EEG.srate, morlet, 'baseline', NaN,
'verbose', 'off', 'timesout', timesoutvalue, 'freqs', [1 35])


[ersp2,itc,powbase,times,freqs] = newtimef(left_data, EEG.pnts, [-500 4000], EEG.srate, morlet, 'baseline', baselinev,
'verbose', 'off', 'timesout', timesoutvalue, 'freqs', [1 35]);
% Storing alpha power in workspace in variable "alpha"
alpha(subj,2) = mean(mean(ersp2 (15:25, 9:200)));
alpha(subj,1) = mean(mean(ersp (15:25, 9:200)));
close all
else
% If the subject does not have any valid trial, fill the "alpha" variable with zeros
alpha(subj,2) = 0;
alpha(subj,1) = 0;
close all
end
end