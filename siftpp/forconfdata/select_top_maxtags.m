function [tags_name_mod] = select_top_maxtags(tagdistributionfile, forbiddentags, maxtags)
%% select only first "maxtags" number of tags by avoiding forbidden tags
selind = [];
[tags_name, tags_freq] = readtags(tagdistributionfile);
for ii=1:size(tags_name,2)
    tagind = strfind(forbiddentags, tags_name{ii});
    tagindex = find(not(cellfun('isempty', tagind)));
    if(isempty(tagindex))
        selind = [selind ii];
    end
end

if(maxtags<length(selind))
    selind =  selind(1:maxtags);
end

%% save the selected tags in another cell
for j=1:length(selind)
    tags_name_mod{j} = tags_name{selind(j)};
end

end
