function [] = genannotations()

%% donkey, monkey, goat, wolf, jetski, zebra, centaur, mug, statue, building, bag, carriage


ipdir = '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_test_refined_images/';
N_ATTS = 64;
fd  = fopen('/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/ayahoo_test.txt');
res = textscan(fd, ['%s %s' repmat(' %f',1,N_ATTS + 4)],'CollectOutput',1);
fclose(fd);

img_names  = res{1}(:,1);
attributes = res{2}(:,5:end);
N          = size(attributes,1);

for i=1:N    
    opfilename  = [ipdir img_names{i}(1:end-4) '_' num2str(i) '_annotations.mat']
    annotations = attributes(i,:);
    save(opfilename, 'annotations');
end

end
