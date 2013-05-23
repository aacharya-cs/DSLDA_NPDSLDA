function [] = doisextractorforall()

foldername = '/v/filer4b/v35q001/ayan/Documents/aaaa/confpaperlinks';
addpath(genpath(foldername));
filenames = dir(foldername);
[M N] = size(filenames);
for i=3:max(M,N)
    extractdois(filenames(i).name);
end

end
