function [paths, num] = sampledata_LabelMe(k, p, t, ipdir, token)

fileList = extractFiles(ipdir, token);
N = size(fileList,2);
if(p<1)
 num = round(p*N);
else
 num = p;
end

ind = ceil(N*rand(num,1));
count = 0;
paths = [];
for i=1:num
 if(isempty(paths))
  paths{1} = fileList{ind(i)};
  count = count + 1;
 else if(isempty(checkList(paths,fileList{ind(i)})))
  count = count + 1;
  paths{count} = fileList{ind(i)};
 else
 end
end

num = count;
filename = ['/lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/' 'indexsets_' num2str(k) '_' num2str(p) '_' num2str(t) '.mat'];
save(filename, 'paths');

end
