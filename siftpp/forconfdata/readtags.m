function [tags_name, tags_freq] = readtags(filename)


%% reads the tags from the *tagdistribution* file

fp    = fopen(filename,'r');
tline = fgetl(fp);
count = 1;
i     = 1;

while(ischar(tline))
    if(count>2)
        matchstart = regexp(tline,' ', 'end');
        tags_name{i} = tline(1:matchstart(end)-1);
        tags_freq{i} = tline(matchstart(end)+1:end);
        i =  i+1;
    end
    tline = fgetl(fp);
    count = count + 1;    
end

end
