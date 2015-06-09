function settings = twoPhotonSettings(stim)

%% Parameters
% Samp Rate
settings.sampRate.out   = stim.sampleRate;
settings.sampRate.in    = stim.sampleRate;

% Break out box 
settings.bob.trigOut = 'port0/line0';
settings.bob.aiType = 'SingleEnded';

settings.devID = 'Dev3';


