function [paths, num] = sampledata_ayahoo(p, ipdir, token)

fileList = extractFiles(ipdir, token);
N = size(fileList,2);
if(p<1)
 num = round(p*N);
else
 num = p;
end

ind = ceil(N*rand(num,1));
for i=1:num
 paths{i} = fileList{ind(i)}; 
end

end
