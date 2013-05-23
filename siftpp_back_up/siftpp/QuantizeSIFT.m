function [] = QuantizeSIFT(p, k, t)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Quantize SIFT starts');
%%ipdir = '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/LabelMe_test_refined_images/';
ipdir = '/lusr/u/ayan/MLDisk/LabelMeData/Images/spatial_envelope_256x256_static_8outdoorcategories/';
token = '.desc';
[paths, countimg] = sampledata_LabelMe(k, p, t, ipdir, token);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opdir = '/lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/';

opfilename1 = [opdir 'LabelMe_' num2str(k) '_' num2str(p) '_' num2str(t) '_col_ccs'];
opfilename2 = [opdir 'LabelMe_' num2str(k) '_' num2str(p) '_' num2str(t) '_row_ccs'];
opfilename3 = [opdir 'LabelMe_' num2str(k) '_' num2str(p) '_' num2str(t) '_tfn_nz'];
opfilename4 = [opdir 'LabelMe_' num2str(k) '_' num2str(p) '_' num2str(t) '_dim'];

fid1  = fopen(opfilename1,'w+');
fid2  = fopen(opfilename2,'w+');
fid3  = fopen(opfilename3,'w+');
 
count     = 0;
szvector  = [];
nzs       = 0;
imgfeatures = [];

for i=1:countimg
    binfilename = paths{i};
    fp = fopen(binfilename,'r');
    A = fread(fp);
    fclose(fp);
    sz2 = 128;
    sz1 = length(A)/sz2;
    SIFTB = reshape(A, sz2, sz1);
    imgfeatures = [imgfeatures SIFTB];
    [colptr, rowptr, nzrs] = getnzs_for_gmeans(SIFTB);
    colptr = colptr + nzs;
    WriteInGmeansFormat(fid1,fid2,fid3,colptr,rowptr,nzrs);
    nzs   =  nzs + length(find(SIFTB>0));
    szvector  = [szvector; size(SIFTB,2)];
    count = count + size(SIFTB,2);    
end


fclose(fid1);
fclose(fid2);
fclose(fid3);

fid4  = fopen(opfilename4,'w+');
fprintf(fid4,'%d %d %d', size(SIFTB,1), count, nzs);
fclose(fid4);

spimg = imgfeatures;
size(spimg)

savefilename = [opdir 'imgfeatures_' num2str(k) '_' num2str(p) '_' num2str(t) '.mat'];
save(savefilename,'spimg');


end
