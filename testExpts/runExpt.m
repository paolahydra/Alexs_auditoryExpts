function runExpt(prefixCode,expNum) 


%% Get fly and experiment details from experimenter 
newFly = input('New fly? ','s');
[flyNum, flyExpNum] = getFlyNum(prefixCode,expNum,newFly);

%% Archive this code 
archiveExpCode(prefixCode,expNum,flyNum,flyExpNum)

%% Generate stimulus 
stim = PipStimulus;
meta.numTrialsPerBlock = 18;
speakerNonRan = repmat(1:3,1,6);
speakerRan = speakerNonRan(randperm(18));


%% Change speaker
count = 1; 
for i = 1:1000000;
    stim.speaker = speakerRan(count);
    switchSpeaker(stim.speaker);    
    acquireTrial(stim,prefixCode,expNum,flyNum,flyExpNum,meta);
    if count == 18
        count = 1; 
        speakerRan = speakerNonRan(randperm(18));
    else
        count = count+1;
    end
end


%% Backup data 
makeBackup
