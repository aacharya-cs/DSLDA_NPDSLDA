function [] = mergeyears(fullpath, mode)

addpath(fullpath);
confname = {'cikm' , 'kdd', 'icml', 'www', 'sigir', 'dac', 'glsvlsi'};
fileList = getAllFiles(fullpath);
count = 1;

if(mode==1)
    
    for i=1:size(fileList,1)
        temp = regexp(fileList{i},'_nd.txt','ONCE');
        if(~isempty(temp))
            fileListmod{count} = fileList{i};
            count = count + 1;
        end
    end
    
    for i=1:size(confname,2)
        writefilename = [confname{i} '_tags_nd.txt'];
        fp = fopen(writefilename,'w');
        inda = strfind(fileListmod, confname{i});
        indb = find(not(cellfun('isempty', inda)));
        for j=1:length(indb)
            filename = fileListmod(indb(j));
            fp2 =  fopen(filename{1},'r');
            tline = fgets(fp2);
            while(ischar(tline))
                fprintf(fp,'%s',tline);
                tline = fgets(fp2);
            end
            fclose(fp2);
            fprintf(fp,'\n');
        end
        fclose(fp);
    end
    
else
    
    for i=1:size(fileList,1)
        temp = regexp(fileList{i},'abstract.txt','ONCE');
        if(~isempty(temp))
            fileListmod{count} = fileList{i};
            count = count + 1;
        end
    end
    
    for i=1:size(confname,2)
        writefilename = [confname{i} '_abstract.txt'];
        fp = fopen(writefilename,'w');
        inda = strfind(fileListmod, confname{i});
        indb = find(not(cellfun('isempty', inda)));
        for j=1:length(indb)
            filename = fileListmod(indb(j));
            fp2 =  fopen(filename{1},'r');
            tline = fgets(fp2);
            while(ischar(tline))
                fprintf(fp,'%s',tline);
                tline = fgets(fp2);
            end
            fclose(fp2);
            fprintf(fp,'\n');
        end
        fclose(fp);
    end
    
end

end
