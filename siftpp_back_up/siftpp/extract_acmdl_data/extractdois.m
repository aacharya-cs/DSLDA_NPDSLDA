function [savefilename] = extractdois(filename)

fid = fopen(filename,'r'); 
i = 1;

while ~feof(fid)
    line = fgets(fid);
    [p q]= regexp(line,'doi>');
    if(~isempty(p))
        doinum{i} = line(q+1:end);
        i = i+1;
    end
end

savefilename = [filename(1:end-4) '.mat'];
save(savefilename,'doinum');
fclose(fid);


end
