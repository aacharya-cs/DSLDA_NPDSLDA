function [validtagindex] = find_matching_tag(tags_name_mod,tline)

%% does exact matching of a string from a cell array of strings

tline2 = [' ' tline];
tline3 = [tline ' '];
valid1 = strfind(tags_name_mod, tline);
valid2 = strfind(tags_name_mod, tline2);
valid3 = strfind(tags_name_mod, tline3);

validtagindex1 = find(not(cellfun('isempty', valid1)));

%% indicates parts of strings; so should be ignored
validtagindex2 = find(not(cellfun('isempty', valid2)));
validtagindex3 = find(not(cellfun('isempty', valid3)));

if(isempty(validtagindex2) && isempty(validtagindex3))
    validtagindex = validtagindex1;
else
    if(~isempty(validtagindex2) && ~isempty(validtagindex3))
        ind1 =  setdiff(validtagindex1,validtagindex2);
        ind2 =  setdiff(validtagindex1,validtagindex3);
        validtagindex = intersect(ind1, ind2);
    elseif(~isempty(validtagindex2))
        validtagindex = setdiff(validtagindex1,validtagindex2);
    else
        validtagindex = setdiff(validtagindex1,validtagindex3);
    end
end

end