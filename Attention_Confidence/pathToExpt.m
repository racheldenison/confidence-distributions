function exptpath = pathToExpt(directory)

% exptpath = pathToExpt(directory)

exptpath = sprintf('%s/Confidence/Attention_Confidence', pathToCarrascoExpts);

if nargin==1
    exptpath = sprintf('%s/%s', exptpath, directory);
end