%Imports a random grayscale video from a directory (containing a dataset or
%something)

%Input:
% path: location of directory

function [X, Gray_name] = import_random_Gray(name)
%cd(path)
%vids  = dir('*.avi*');
%index = floor(rand*length(vids)) + 1;
X = RGB2Gray_signal([name]);
Gray_name = name;