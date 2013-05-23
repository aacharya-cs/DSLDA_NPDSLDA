function  [] = extract_abstract_and_tag ()

foldername = '/v/filer4b/v35q001/ayan/Documents/aaaa/confpaperlinks';
addpath(genpath(foldername));
filenames  = dir(foldername);
[M N] = size(filenames);

for k = 10:max(M,N)
    FileName = filenames(k).name;
    if(~isempty(regexp(FileName,'.txt')))
        fprintf(1, 'Now reading %s\n', FileName);
        FileNameMat = extractdois(FileName);
        read_abstract_and_tag (FileNameMat);
    end
end

end



