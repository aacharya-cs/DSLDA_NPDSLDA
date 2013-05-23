function [] = convert_tags_to_binary(filename,total_tags)

%% example input: convert_tags_to_binary('kdd_data.mat', 10)
%% example output: kdd_data_tagbinary.mat
filename

A = load(filename);
A = A.tags;
btags = [];

for i=1:size(A,2)
 temp = zeros(1,total_tags);   
 ind = A{i};
 temp(ind) = 1;
 btags = [btags; temp];
end

savefilename = [filename(1:end-4) '_tagbinary.mat'];
save(savefilename,'btags');

end

