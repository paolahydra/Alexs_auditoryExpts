%% flexSoundExpt.m
% AVB 2015/06/09

%% Run at start of experiment
runTwoPhotonExpt('test',1)

%% Pip 
stim = PipStimulus;
for i = 1:5
    if i ==1 
        getRoiNum; 
    end
    acquireTwoPhotonTrial(stim); 
end

%% Chirp 
stim = Chirp;
getRoiNum; 
acquireTwoPhotonTrial(stim); 

%% Run at end of experiment 
diary off 