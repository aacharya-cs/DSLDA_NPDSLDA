function [] = split_train_test_confdata(sourcepath, savepath)

%%confname = {'cikm', 'dac', 'glsvlsi', 'icml', 'kdd', 'sigir', 'www'};
confname = {'cikm', 'dac', 'glsvlsi', 'icml', 'ISPD', 'kdd', 'sigir', 'spaa', 'www'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii=1:size(confname,2)
    
    confname{ii}
    datafilename = [sourcepath confname{ii} '_data.mat'];
    binarytagfilename = [sourcepath confname{ii} '_data_tagbinary.mat'];
    
    savetrdata = [savepath confname{ii} '_train.mat'];
    savetestdata = [savepath confname{ii} '_test.mat'];
    
    A = load(datafilename);
    B = load(binarytagfilename);

    if(strcmp(confname{ii},'icml')==1)
     N = size(A.wcount,2)-1; %% because of some weird error
    else
     N = size(A.wcount,2);
    end
    trind  = SelRandomVec(N,round(N/2));
    testind = setdiff([1:N],trind);
    
    wcount = [];
    windex = [];
    nwordspdoc = [];
    class_labels = [];
    annotations = [];
    liblindata = [];
    
    for i=1:length(trind)
        wcount{i} = A.wcount{trind(i)};
        windex{i} = A.windex{trind(i)};
        nwordspdoc(i) = A.nwordspdoc(i);
        class_labels(i) = A.class_labels(i);
        annotations(i,:) = B.btags(trind(i), :);
    end
    liblindata = A.liblindata(trind,:);
    save(savetrdata, 'wcount', 'windex', 'nwordspdoc', 'class_labels', 'annotations', 'liblindata');
    
    wcount = [];
    windex = [];
    nwordspdoc = [];
    class_labels = [];
    annotations = [];
    liblindata = [];
    
    for i=1:length(testind)
        wcount{i} = A.wcount{testind(i)};
        windex{i} = A.windex{testind(i)};
        nwordspdoc(i) = A.nwordspdoc(i);
        class_labels(i) = A.class_labels(i);
        annotations(i,:) = B.btags(testind(i), :);
    end
    liblindata = A.liblindata(testind,:);
    save(savetestdata,'wcount', 'windex', 'nwordspdoc', 'class_labels', 'annotations', 'liblindata');
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
