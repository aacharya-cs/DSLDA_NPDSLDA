function [trdata, testdata, selindex, classnames, MCMacc] = prep_ayahoo(pathname, p1, p2, p3, classfilename, k2, minvtopic)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% treats the last file name as the target class
%% p1: percentage or number of instances from the source data in training
%% p2: percentage or number of instances from the target data in training
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pathname
classfilename
classnames   = textread(classfilename,'%s\n');
for i=1:size(classnames,1)-1
    source_class{i} = classnames{i};
end
target_class = classnames{end};

trdata.k2   = k2;  %% number of latent topics
testdata.k2 = k2;

[M N] = size(classnames);
trdata.Y    = max(M,N);  %% number of classes
testdata.Y  = max(M,N);

trdata.V    = 250; %% code book size or vocabulary size
testdata.V  = 250;

trdata.k1   = 64;  %% maximum number of visible topics
testdata.k1 = 64;

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
    selindtrain = SelRandomVec(N, round(p*N));

    %% select only a subset of training data to have labels
    Ntrain = length(selindtrain);
    selindtrlabels = SelRandomVec(Ntrain, round(p3*Ntrain));
    selindtrainbinarylabels = zeros(1,Ntrain);
    selindtrainbinarylabels(selindtrlabels) = 1;
    %% selection done

    tempnzeros = 0;
    ndocs = 0;
    invalidindex = [];
    svmvalidindex = [];

    for j=1:length(selindtrain)
        if(sum(A.annotations(selindtrain(j),:))<minvtopic)
            invalidindex = [invalidindex j];
        else
            if(sum(A.wcount{selindtrain(j)})==0)
            else
                trdata.windex{count} = A.windex{selindtrain(j)};
                trdata.wcount{count} = A.wcount{selindtrain(j)};
                trdata.annotations(count,:) = A.annotations(selindtrain(j),:);
                trdata.classlabels(count,1) = i*selindtrainbinarylabels(j); %% assign zero for missing labels;
                trdata.nwordspdoc(count,1) = sum(A.wcount{selindtrain(j)});
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
                ndocs = ndocs + 1;
                count = count + 1; 
                %%error('problem in words');
            end
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
        if(sum(A.annotations(selindtest(j),:))<minvtopic)
            invalidindex = [invalidindex j];
        else
            if(sum(A.wcount{selindtest(j)})==0)
            else
                testdata.windex{count} = A.windex{selindtest(j)};
                testdata.wcount{count} = A.wcount{selindtest(j)};
                testdata.annotations(count,:) = A.annotations(selindtest(j),:);
                testdata.classlabels(count,1) = i;
                testdata.nwordspdoc(count,1) = sum(A.wcount{selindtest(j)});
                count = count + 1; %% to avoid docs without words
                %%error('problem in words');
            end
        end
    end
    if(~isempty(invalidindex))
        %% remove images with visible topic less than threshold
        selindtest(invalidindex) = [];
    end
    selindex{i}.selindtest  = selindtest;

    if(length(selindtest)>maxnum)
     maxnum = length(selindtest);
    end

end

MCMacc = maxnum/length(testdata.classlabels);

%% getstat(trdata)

end

