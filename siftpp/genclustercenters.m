function [] = genclustercenters(p, k, t)

filename1 = ['/lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_results_' num2str(k) '_' num2str(p) '_' num2str(t) '_tfn_doctoclus.' num2str(k)];
filename2 = ['/lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/' 'imgfeatures_' num2str(k) '_' num2str(p) '_' num2str(t) '.mat'];
filename3 = ['/lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/' 'clustercenters_' num2str(k) '_' num2str(p) '_' num2str(t) '.mat'];

A = dlmread(filename1, '\n');
A = A(2:end);
B = load(filename2);
B = B.spimg;
B = B';

length(A)
size(B)
C = zeros(k,128);
nonemptycluster = 0;

for i=0:k-1
 ind = find(A==i);
 if(~isempty(ind))
  nonemptycluster = nonemptycluster + 1;
  C(nonemptycluster,:) = mean(B(ind,:),1);
 end
end

if(nonemptycluster<k)
 ind = [nonemptycluster:k];
 C(ind,:) = [];
end

save(filename3, 'C');

end



