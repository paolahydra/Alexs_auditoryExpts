function acquireTwoPhotonTrial(stim,trialMeta,varargin)

evalin('base','clear all');
fprintf('\n*********** Acquiring Trial ***********')

%% Trial time
trialMeta.trialStartTime = datestr(now,'HH:MM:SS');

%% Create stimulus if needed
if ~exist('stim','var')
    stim = noStimulus;
end

%% Load settings
settings = twoPhotonSettings(stim);

%% Configure ouput session
sOut = daq.createSession('ni');
sOut.Rate = settings.sampRate.out;

% Add analog out channel (speaker)
sOut.addAnalogOutputChannel(settings.devID,0,'Voltage');
sOut.Rate = settings.sampRate.out;

% Add digital out channel (external trigger)
sOut.addDigitalChannel(settings.devID,settings.bob.trigOut,'OutputOnly');

extTrig = ones(size(stim.stimulus));
extTrig(1) = 0;
extTrig(end) = 0;


%% Run trial
sOut.queueOutputData([stim.stimulus extTrig]);
sOut.startForeground;

%% Save data
if nargin ~= 0
    % Get filenames
    folder = getpref('scimSavePrefs','folder');
    basename = getpref('scimSavePrefs','basename');
    trialMeta.roiNum = getpref('scimSavePrefs','roiNum');
    saveFolder = [folder,'\roiNum',num2str(trialMeta.roiNum,'%03d'),'\'];
    if ~isdir(saveFolder)
        mkdir(saveFolder)
    end
    
    % Put image in correct roiNum folder and rename to include roiNum
    cd(folder)
    while isempty(dir('*tif'))
    end
    imageSearchResult = dir('*tif');
    currentImageName = imageSearchResult.name;
    trialNumStr = regexp(currentImageName,'(?<=_)\d*(?=.tif)','match');
    trialNum = str2num(char(trialNumStr));
    fprintf(['\nTrialNum = ',num2str(trialNum)])
    
    newImageName = [saveFolder,basename,'roiNum',num2str(trialMeta.roiNum,'%03d'),...
        '_trialNum',num2str(trialNum,'%03d'),'_image.tif'];
    movefile(currentImageName,newImageName)
    
    metaFileName = [saveFolder,basename,'roiNum',num2str(trialMeta.roiNum,'%03d'),...
        '_trialNum',num2str(trialNum,'%03d'),'.mat'];
    
    % Convert stim object to structure for saving
    warning('off','MATLAB:structOnObject')
    Stim = struct(stim);
    
    % Save data,trialMeta and Stim
    save(metaFileName,'trialMeta','Stim');
    
end

%% Close daq objects
sOut.stop;

%% Plot data




end
