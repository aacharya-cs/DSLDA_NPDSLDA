function [] = converttoPGM()

clc;

%dirName  = '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_test_images/';
dirName  = '/lusr/u/ayan/MLDisk/LabelMeData/Images/spatial_envelope_256x256_static_8outdoorcategories/';
token    = '.jpg';
fileList = extractFiles(dirName, token);

N = size(fileList,2);
fp = fopen('filepaths.txt','w');

for i=1:N
    disp('image number: ');
    i
    filename = fileList{i};
    A = imread(filename);
    opfilename = [filename(1:end-4) '.pgm'];
    imwrite(A, opfilename, 'pgm');
    fprintf(fp, '%s\n', opfilename);
    rmstr = ['rm -rf ' filename];
    system(rmstr);
end

fclose(fp);

end
