function [fileList] = extractFiles(dirName, token)

fileList1 = getAllFiles(dirName);
count = 1;
for i=1:size(fileList1,1)
    if(~isempty(regexp(fileList1{i},token)))
        fileList{count} = fileList1{i};
        count = count+1;
    end
end

end
