function [indb] = checkList(oldList,newString)

inda = strfind(oldList, newString);
if(iscell(inda))
    indb = find(not(cellfun('isempty', inda)));
else
    indb = inda;
end

end
