function [] = read_abstract_and_tag (filename)


abstractid = 'NAME="abstract" class="small-text">ABSTRACT';
abstractid1 = '<div style="display:inline">';
abstractid2 = '</div>';
tagid = '<strong>Tags:</strong>';
tagid1 = '<a href=';
stopid = '<dl title="Authors"';
stoptagid = 'tabbed view</a> <noscript>';

bufferfile = 'tempfile';
A = load(filename);
opfilename = ['/v/filer4b/v16q001/ml/data/Ayans/newconfdata/' filename(1:end-4) 'abstracts.txt'];
fid1 = fopen(opfilename,'w+');
totsz = size(A.doinum,2);

for i=1:size(A.doinum,2)
    
    dispstr = [num2str(i) '/' num2str(totsz)];
    disp(dispstr);
    temp = A.doinum{i};
    p = regexp(temp,'/');
    URLname = ['http://dl.acm.org/citation.cfm?doid=' temp(p+1:end-1) '&preflayout=flat'];
    urlwrite(URLname,bufferfile);
    fid = fopen(bufferfile,'r');
    
    condition  = 1;
    condition1 = 0;
    condition2 = 0;
    tagpresent = 0;
    
    while (~feof(fid) && condition == 1)
        line = fgets(fid);
        
        temp = strtrim(line);
        p = strcmp(temp,tagid);
        if(p)
            condition1 = 1;
        end
        [p1 q1]= regexp(line,tagid1);
        
        [p8 q8]= regexp(line,stoptagid);
        if(condition1==1 && ~isempty(p8))
            condition1 = 0;
            fprintf(fid1,'%s\n', '********************************');
        end
        
        if(condition1==1 && ~isempty(p1))
            tagpresent = 1;
            p2 = regexp(line,'">');
            p3 = regexp(line,'</span>');
            linemod = line(p2(end)+2:p3-1);
            linemod = strtrim(linemod);
            fprintf(fid1,'%s\n', linemod);
        end
        
        [p4 q4]= regexp(line,abstractid);
        if(~isempty(p4))
            condition2 = 1;
            if(tagpresent==0) % if no tag is present add "notag"
                fprintf(fid1,'%s\n', 'notag');
                fprintf(fid1,'%s\n', '********************************');
            end
        end
        [p5 q5]= regexp(line,abstractid1);
        if(condition2==1 && ~isempty(p5))
            [p6 q6]= regexp(line,abstractid2);
            linemod = line(q5+1:p6-1);
            linemod = strtrim(linemod);
            fprintf(fid1,'%s\n', linemod);
        end
        
        [p7 q7]= regexp(line,stopid);
        if(~isempty(p7))
            condition = 0;
        end
        
    end
    fprintf(fid1,'\n\n');
end
fclose(fid1);

end

