function [] = gmeans_assign_clusters(k, p, t)

filename1 = ['/lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/' 'clusterseeds_' num2str(k) '_' num2str(p) '_' num2str(t) '.txt'];
filename2 = ['/lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/' 'indexsets_' num2str(k) '_' num2str(p) '_' num2str(t+1) '.mat']
filename3 = ['/lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/' 'clustercenters_' num2str(k) '_' num2str(p) '_' num2str(t) '.mat'];

ipdir    = '/lusr/u/ayan/MLDisk/LabelMeData/Images/spatial_envelope_256x256_static_8outdoorcategories/';
token    = '.desc';
fileList = extractFiles(ipdir, token);
cluster_centers = load(filename3);
cluster_centers = cluster_centers.C;

ind = load(filename2);
ind = ind.paths;

IDmat = [];
N = size(fileList,2)
size(ind)

totdocs = 0;
countval = 0;
indexset = [];

for i=1:N
    binfilename = fileList{i};
    fp = fopen(binfilename,'r');
    A = fread(fp);
    fclose(fp);
    sz2 = 128;
    sz1 = length(A)/sz2;
    SIFTB = reshape(A, sz2, sz1);
    SIFTB = SIFTB';
    D = pdist2(SIFTB,cluster_centers,'euclidean'); 
    [~,ID] = min(D,[],2);
    index = [];
    index = checkList(ind,binfilename);
    if(~isempty(index))
     totdocs = totdocs + size(SIFTB,1);
     IDmat = [IDmat; ID];
     countval = countval + 1;
     filename{countval} = binfilename;
     vwords{countval} = sort(ID);
     indexset = [indexset index];
    end
end

fid = fopen(filename1, 'wt');
fprintf(fid, '%d 1\n', length(IDmat));
fprintf(fid, '%d\n', IDmat-1);
fclose(fid);

save('LabelMe_vwords.mat', 'filename', 'vwords');

end
