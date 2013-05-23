function [] = removextranewline(filename)

%% removes initial and intermediate extra newlines

newfilename = [filename(1:end-4) '_mod.txt'];
fp1 = fopen(filename,'r');
fp2 = fopen(newfilename,'w');
tline = fgetl(fp1);
tlineprev = 'null';
started = 0;
indicator = 0;

while(ischar(tline))
    if(~isempty(tline))
        started = 1;
    end
    if(isempty(tline) && started==0)
    elseif(strcmp(tlineprev,'null')==1)
        fprintf(fp2,'%s\n',tline);
    else
        temp = isempty(tlineprev);
        if((isempty(tline)) && temp==0 && indicator==0)
            fprintf(fp2,'%s\n',tline);
            indicator = 1;
        end
        if((~isempty(tline)))
            fprintf(fp2,'%s\n',tline);
            indicator = 0;
        end
    end
    if(started==0)
    else
        tlineprev = tline;
    end
    tline = fgetl(fp1);
end

fclose(fp1);
fclose(fp2);

end

