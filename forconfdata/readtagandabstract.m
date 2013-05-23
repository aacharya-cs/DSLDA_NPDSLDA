function  [] = readtagandabstract(forbiddentags, fullpath1, fullpath2, fullpath3, maxtags, confname)


V = 13412; %% vocabulary size -- computed by running through the corpus once 

addpath(fullpath1);
addpath(fullpath2);
addpath(fullpath3);

tagList    = [];
vocabList  = [];

for i=1:size(confname,2)
    
    %% reset variables
    doccount   = 1;
    tline2prev = '';
    tags = [];
    windex = [];
    wcount = [];
    class_labels = [];
    nwordspdoc = [];
    liblindata = [];
    
    tagfile = [confname{i} '_tags_nd.txt']
    abstractfile = [confname{i} '_abstract.txt']
    tagdistributionfile = [confname{i} '_tagdistribution.txt']
    
    tags_name_mod = select_top_maxtags(tagdistributionfile, forbiddentags, maxtags);
    %% tags_name_mod contains the most frequent non-forbidden tags
    
    fp1 = fopen(tagfile,'r');
    fp2 = fopen(abstractfile,'r');
    
    tline1 = fgetl(fp1);
    tline2 = fgetl(fp2);
    
    while(ischar(tline2))
        
        inda = [];
        indb = [];
        
        %% read the abstract
        if(strcmp(tline2,'noabstract')==1)
            words = [];
        else
            if(~isempty(tline2))
                words = regexp(tline2,' ','split');
                temp2 = [];
            else  %% marks end of an abstract
                if(strcmp(tline2prev,'noabstract')==0)
                    doccount = doccount + 1;
                    words = [];
                end
            end
        end
        
        M = size(words,2);
        for m=1:M
            indb = checkList(vocabList,words{m});
            if(isempty(indb))
                sz = size(vocabList,2);
                vocabList{sz+1} = words{m};
            end
            tempind = strfind(vocabList, words{m});
            tempindex = find(not(cellfun('isempty', tempind)));
            temp2 = [temp2 tempindex(1)];
        end
        
        temp1 = []; %% will contain tag indices; so need to initialize at the start of every document
        
        %% read the tags
        if(~isempty(tline2)) %% read only when abstract is not empty
            while(ischar(tline1) && (~isempty(tline1)))
                if(strcmp(tline2,'noabstract')==0)  %% ignore tags for documents that have 'noabstract' in the abstract field
                    indb = checkList(tagList,tline1);
                    if(isempty(indb)) %% for new tag -- only read tags that are present in tags_name_mod; ignore rest of the tags and ignore any document that does not have any of the tags from tags_name_mod
                        validtagindex = find_matching_tag(tags_name_mod,tline1);
                        if(~isempty(validtagindex)) %% if it belongs to the frequent tagList
                            sz = size(tagList,2);
                            tagList{sz+1} = tline1;
                            temp1 = [temp1 sz+1];
                        end
                    else
                        temp1 = [temp1 indb(1)];
                    end
                end
                tline1 = fgetl(fp1);
            end
            if(strcmp(tline2,'noabstract')==0)
                if(isempty(temp1))
                    doccount = doccount -1;
                else
                    tags{doccount} = temp1;
                end
            end
            tline1 = fgetl(fp1);
        end
        tline2prev = tline2;
        tline2 = fgetl(fp2);
        
        if(M>0 && ~isempty(temp1))
            fprintf('%s/%d\n', confname{i}, doccount);
            
            %% create data for my model
            temp2 = sort(temp2);
            windex{doccount} = unique(temp2);
            wcount{doccount} = hist(temp2, unique(temp2));
            class_labels(doccount) = i;
            nwordspdoc(doccount) = length(temp2);
            
            %% create data for liblinear
            tempmat = zeros(1,V);
            tempmat(windex{doccount}) = wcount{doccount};
            liblindata = [liblindata; sparse(tempmat)];
        end
        
    end
    
    %% save data for each conference
    
    savefilename = [confname{i} '_data'];
    save(savefilename, 'tags', 'wcount', 'windex', 'class_labels', 'nwordspdoc', 'liblindata');
    
end

save('tagList.mat','tagList');
save('vocabList.mat','vocabList');

%% now convert the tags to binary representation
A = load('tagList.mat');
total_tags = size(A.tagList,2);
for i=1:size(confname,2)
    filename = [confname{i} '_data.mat'];
    convert_tags_to_binary(filename,total_tags);
end

end
