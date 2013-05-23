function [] = numberofdocuments(filename)

fp = fopen(filename,'r');
tline =  fgetl(fp);
count = 0;
while(ischar(tline))
    if(isempty(tline))
        count = count +1;
    end
    tline = fgetl(fp);
end

end

