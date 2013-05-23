function [] = save_images ()
% Example function for using read_att_data.m, and the dataset
% Input: <fname> name of dataset to use
%        <imdir> directory where images are stored

fname   = 'ayahoo_test.txt'; 
imdir   = '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_test_images/';
imopdir = '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_test_refined_images/';

[img_names img_classes bboxes attributes] = read_att_data(fname);

for i = 1:length(img_names)
   filename = img_names{i};
   filename = [filename(1:end-4) '.pgm'];
   im = imread(fullfile(imdir, filename));
   bbox = bboxes(i,:);
   opim = im(bbox(2):bbox(4), bbox(1):bbox(3), :);
   opfilename = fullfile(imopdir, [filename(1:end-4) '_' num2str(i) '.pgm'])
   imwrite(opim, opfilename, 'pgm');
end

end
