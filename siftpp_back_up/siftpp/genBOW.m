function [] = genBOW()

ipdir    = '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_test_refined_images/';
token    = '.desc';
fileList = extractFiles(ipdir, token);
cluster_centers = load('/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/clustercenters.mat');
cluster_centers = cluster_centers.C;

count     = 0;
szvector  = [];
nzs       = 0;
visualwords  = size(cluster_centers,1);
vwordsind = [1:visualwords];

N = size(fileList,2);
count = zeros(12,1);
%% donkey, monkey, goat, wolf, jetski, zebra, centaur, mug, statue, building, bag, carriage

for i=1:N
    
    binfilename = fileList{i}
    fp = fopen(binfilename,'r');
    A = fread(fp);
    fclose(fp);
    sz2 = 128;
    sz1 = length(A)/sz2;
    SIFTB = reshape(A, sz2, sz1);
    SIFTB = SIFTB';
    D = pdist2(SIFTB,cluster_centers,'euclidean');
    [~,ID] = min(D,[],2);
    
    annotationfilename = [fileList{i}(1:end-5) '_annotations.mat'];
    C = load(annotationfilename);
    C = C.annotations;
    
    %ID = sort(ID);
    %histogram = hist(ID,vwordsind);
    
    if(~isempty(regexp(binfilename,'donkey')))
        count(1) = count(1) + 1;    
        donkey.w{count(1)} = ID;
        donkey.annotations{count(1),:} = C;
        
    elseif(~isempty(regexp(binfilename,'monkey')))
        count(2) = count(2) + 1;
        monkey.w{count(2)} = ID;
        monkey.annotations{count(2),:} = C;
        
    elseif(~isempty(regexp(binfilename,'goat')))
        count(3) = count(3) + 1;      
        goat.w{count(3)} = ID;
        goat.annotations{count(3),:} = C;
        
    elseif(~isempty(regexp(binfilename,'wolf')))
        count(4) = count(4) + 1;
        wolf.w{count(4)} = ID;
        wolf.annotations{count(4),:} = C;
        
    elseif(~isempty(regexp(binfilename,'jetski')))
        count(5) = count(5) + 1;
        jetski.w{count(5)} = ID;
        jetski.annotations{count(5),:} = C;
        
    elseif(~isempty(regexp(binfilename,'zebra')))
        count(6) = count(6) + 1;
        zebra.w{count(6)} = ID;
        zebra.annotations{count(6),:} = C;
        
    elseif(~isempty(regexp(binfilename,'centaur')))
        count(7) = count(7) + 1;
        centaur.w{count(7)} = ID;
        centaur.annotations{count(7),:} = C;
        
    elseif(~isempty(regexp(binfilename,'mug')))
        count(8) = count(8) + 1;
        mug.w{count(8)} = ID;
        mug.annotations{count(8),:} = C;
        
    elseif(~isempty(regexp(binfilename,'statue')))
        count(9) = count(9) + 1;
        statue.w{count(9)} = ID;
        statue.annotations{count(9),:} = C;
        
    elseif(~isempty(regexp(binfilename,'building')))
        count(10) = count(10) + 1;
        building.w{count(10)} = ID;
        building.annotations{count(10),:} = C;
        
    elseif(~isempty(regexp(binfilename,'bag')))
        count(11) = count(11) + 1;
        bag.w{count(11)} = ID;
        bag.annotations{count(11),:} = C;

    elseif(~isempty(regexp(binfilename,'carriage')))
        count(12) = count(12) + 1;
        carriage.w{count(12)} = ID;
        carriage.annotations{count(12),:} = C;
    end
    
end


savefile1 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'donkey_data.mat'];
savefile2 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'monkey_data.mat'];
savefile3 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'goat_data.mat'];
savefile4 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'wolf_data.mat'];
savefile5 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'jetski_data.mat'];
savefile6 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'zebra_data.mat'];
savefile7 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'centaur_data.mat'];
savefile8 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'mug_data.mat'];
savefile9 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'statue_data.mat'];
savefile10 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'building_data.mat'];
savefile11 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'bag_data.mat'];
savefile12 = ['/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/' 'carriage_data.mat'];

save(savefile1,'donkey');
save(savefile2,'monkey');
save(savefile3,'goat');
save(savefile4,'wolf');
save(savefile5,'jetski');
save(savefile6,'zebra');
save(savefile7,'centaur');
save(savefile8,'mug');
save(savefile9,'statue');
save(savefile10,'building');
save(savefile11,'bag');
save(savefile12,'carriage');

end
