function [] = gmeans_assign_clusters_on_full(k, p)

filename3 = ['/lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/' 'clustercenters_' num2str(k) '_' num2str(p) '_1.mat'];
ipdir    = '/lusr/u/ayan/MLDisk/LabelMeData/Images/spatial_envelope_256x256_static_8outdoorcategories/';
token    = '.desc';
fileList = extractFiles(ipdir, token);
cluster_centers = load(filename3);
cluster_centers = cluster_centers.C;

IDmat = [];
N = size(fileList,2);

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
    ID = sort(ID);
    [~,Ipos,~] = unique(ID);
    Ipos  = [Ipos' length(ID)];
    Iposp = [0 Ipos(1:end-1)];
    filename{i} = binfilename;
    vwordsindex{i} = unique(ID);
    vwordscount{i} = (Ipos - Iposp);
    vwordscount{i}(end) = [];
end

save('/lusr/u/ayan/Documents/DSLDA_SDM/DSLDA/LabelMe_vwords.mat', 'filename', 'vwordsindex', 'vwordscount');

end
