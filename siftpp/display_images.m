function [] = display_images()

% displays images of a specific directory
ipdir = '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_test_refined_images/';
fileList = getAllfiles(ipdir);

N = size(fileList,2);

for i=1:N
    disp('image number: ');
    i
    filename = fileList{i};
    im = imread(filename);
    imagesc(im);
    title(filename);
    pause
end

end
