function [trdata, testdata, selindex, classnames, MCMacc] = get_confdata(pathname, p1, p2, p3, classfilename, k2, minvtopic)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% treats the last file name as the target class
%% p1: percentage or number of instances from the source data in training
%% p2: percentage or number of instances from the target data in training
%% p3: percentage of training data that have missing labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classnames   = textread(classfilename,'%s\n');
for i=1:size(classnames,1)-1
    source_class{i} = classnames{i};
end
target_class = classnames{end};

A = load('vocabList.mat');
trdata.V    = size(A.vocabList,2); %% code book size or vocabulary size
testdata.V  = size(A.vocabList,2);

A = load('tagList.mat');
trdata.k1   = size(A.tagList,2);  %% maximum number of visible topics
testdata.k1 = size(A.tagList,2);

trdata.k2   = k2;  %% number of latent topics
testdata.k2 = k2;

[M N] = size(classnames);

trdata.Y    = max(M,N);  %% number of classes
testdata.Y  = max(M,N);

%% collect training data
count = 1;
for i=1:trdata.Y
    if(i<trdata.Y)
        filename = [pathname source_class{i} '_train.mat'];
        A = load(filename);
        p = p1;
    else
        filename = [pathname target_class '_train.mat'];
        A = load(filename);
        p = p2;
    end
    N = size(A.wcount,2);
    selindtrain = SelRandomVec(N, round(p*N)); %% doc index selection according to p1 or p2
    
    %% select only a subset of training data to have labels
    Ntrain = length(selindtrain);
    selindtrlabels = SelRandomVec(Ntrain, round(p3*Ntrain)); %% select indices out of selindtrain to have labels
    selindtrainbinarylabels = zeros(1,Ntrain);
    selindtrainbinarylabels(selindtrlabels) = 1; %% only a subset of selected indices should have class labels
    %% selection done
    
    tempnzeros = 0;
    ndocs = 0;
    invalidindex = [];
    svmvalidindex = [];
    
    for j=1:Ntrain
        temp = find(A.annotations(selindtrain(j),:)==1);
        if(length(temp)<minvtopic) %% if satisfies minimum number of topics
            invalidindex = [invalidindex j];
        else
            trdata.windex{count} = A.windex{selindtrain(j)};
            trdata.wcount{count} = A.wcount{selindtrain(j)};
            trdata.annotations(count,:) = A.annotations(selindtrain(j),:);
            trdata.classlabels(count,1) = i*selindtrainbinarylabels(j); %% assign zero for missing labels
            %% increase count if a non-zero label is found
            if(trdata.classlabels(count,1)>0)
                tempnzeros = tempnzeros + 1;
                svmvalidindex = [svmvalidindex j];
            end
            trdata.nwordspdoc(count,1) = sum(A.wcount{selindtrain(j)});
            if(min(size(trdata.wcount{count})==0))
                error('no word in document error');
            end
            if(~isempty(find(trdata.wcount{count}==0)))
                trdata.wcount{count}
                error('zero word count in document');
            end
            count = count + 1;
            ndocs = ndocs + 1;          
        end
    end
    
    %% guard against no example in a class
    if(ndocs==0) %% if no doc satisifies min topic condition
        error('need at least one example per class -- error due to mintopic');
    end
    if(tempnzeros==0) %% if all selected docs have missing labels
        error('need at least one example per class -- error due to low p3');
    end
    
    %% selection of data for liblinear SVM
    selindex{i}.selindtrain = selindtrain(svmvalidindex); %% store only the indices that have labels and satisfy min topic requirement
end

%% collect test data
maxnum = 0;
count = 1;
for i=1:testdata.Y
    invalidindex = [];
    if(i<testdata.Y)
        filename = [pathname source_class{i} '_test.mat'];
        A = load(filename);
        p = 1;
    else
        filename = [pathname target_class '_test.mat'];
        A = load(filename);
        p = 1;
    end
    
    N = size(A.wcount,2);
    selindtest = SelRandomVec(N, round(p*N));
    for j=1:length(selindtest)
        temp = find(A.annotations(selindtest(j),:)==1);
        if(length(temp)<minvtopic)
            invalidindex = [invalidindex j];
        else
            testdata.windex{count} = A.windex{selindtest(j)};
            testdata.wcount{count} = A.wcount{selindtest(j)};
            testdata.annotations(count,:) = A.annotations(selindtest(j),:);
            testdata.classlabels(count,1) = i;
            testdata.nwordspdoc(count,1) = sum(A.wcount{selindtest(j)});
            count = count + 1;
        end
    end
    selindtest(invalidindex) = [];
    selindex{i}.selindtest  = selindtest;
    
    if(length(selindtest)>maxnum)
        maxnum = length(selindtest);
    end
end

MCMacc = maxnum/length(testdata.classlabels);


%% for comparing with the code of onlineHDP
%% converttoSLDA(trdata, testdata);

%%getstat(trdata);

end

