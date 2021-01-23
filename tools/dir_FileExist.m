function [dir_FileExist] = dir_FileExist(Path,FileName)
Files = dir(Path);
FileNames = strings(length(Files),1);
for n = 1:length(Files)
    FileNames(n) = Files(n).name;
end
dir_FileExist = ~isempty(find(contains(FileNames,FileName)));

