function [flyNum,newFly] = getFlyNumTwoPhoton(prefixCode,expNum)

newFly = input('New fly? ','s');

dataDirectory = getpref('scimSavePrefs','dataDirectory');

flyNum = 1; 

% Make numbers strings
eNum = num2str(expNum,'%03d');

while( isdir([dataDirectory,prefixCode,'\expNum',eNum,...
    '\flyNum',num2str(flyNum,'%03d')]) )
    flyNum = flyNum + 1;
end

if ~strcmp(newFly,'y') && flyNum ~= 1
    flyNum = flyNum -1; 
end 

fprintf(['Fly Number = ',num2str(flyNum),'\n'])