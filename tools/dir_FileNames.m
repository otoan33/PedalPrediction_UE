function [FileNames, FileNumber] = dir_FileNames(Path)
Files = dir(Path);
FileNumber = length(Files);
FileNames = strings(length(Files),1);
for n = 1:length(Files)
    FileNames(n) = Files(n).name;
end


