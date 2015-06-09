function runTwoPhotonExpt(prefixCode,expNum,stimSetNum,varargin)

%% Get folder and basename
dataDirectory = getpref('scimSavePrefs','dataDirectory');
[flyNum, newFly] = getFlyNumTwoPhoton(prefixCode,expNum);

folder = [dataDirectory,prefixCode,'\expNum',num2str(expNum,'%03d'),...
    '\flyNum',num2str(flyNum,'%03d')];

if ~isdir(folder)
    mkdir(folder)
end

basename = [prefixCode,'_expNum',num2str(expNum,'%03d'),...
    '_flyNum',num2str(flyNum,'%03d'),'_'];


%% Set meta data
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.dNum           = datestr(now,'YYmmDD');
exptInfo.exptStartTime  = datestr(now,'HH:MM:SS');

%% Get and save fly details
if strcmp(newFly,'y')
    getFlyDetails(exptInfo,basename,dataDirectory)
end

%% Save folder and basename to matlab preferences
setpref('scimSavePrefs',{'folder','basename','roiNum'},{folder,basename,[]})

%% Set Dir and basename in ScanImage
fprintf('*********\nSet directory and basename in ScanImage then press Enter');
fprintf('\nDirectory = ')
disp(folder)
fprintf('Basename = ')
disp(basename)
clipboard('copy',basename);
fprintf('*********\n');
input('')

%% Save exptInfo
filename = [folder,'\',basename,'exptInfo'];
save(filename,'exptInfo')

%% Create diary 
diaryFilename = [folder,'\',basename,'diary.txt'];
diary(diaryFilename)
diary on

%% Run stim set if provided
if exist('stimSetNum','var')
    trialMeta.stimSetNum = stimSetNum;
    getRoiNum;
    contAns = input('Would you like to start the experiment? ','s');
    if strcmp(contAns,'y')
        fprintf('**** Running Experiment ****\n')
        eval(['twoPhotonStimSet_',num2str(stimSetNum,'%03d'),...
            '(','trialMeta',')'])
    end
end

%% Run flexible experiment if no stimSet is provided
if ~exist('stimSetNum','var')
    edit flexSoundExpt;
end


