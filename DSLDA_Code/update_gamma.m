function [model] = update_gamma(model, data)

if(model.option>=4)
    alphaterm1 = [repmat(model.alpha1, model.N, 1) zeros(model.N, model.K-model.k1)];
    alphaterm2 = [zeros(model.N, model.k1) repmat(model.alpha2, model.N, 1)];
    term1      = alphaterm1 + alphaterm2;
else
    term1 = repmat(model.alpha, model.N, 1);
end

term2 = sum_phi(model, data);
model.gamma = term1+term2;

if (model.phase==1 && (model.option==2||model.option>=4)) % only in training phase and for option labeled LDA and my model
    ind1 = find(data.annotations==0); %% since latent topics are appended as extra columns; does not make a difference in indexing
    model.gamma(ind1) = 0; %% zero out indices which are not active among supervised topics
    if(model.option==5)    %% DSLDA-NSLT
        ind2  = ones(model.N,model.k1);  %% supervised topics
        ind2  = [ind2 2*ones(model.N,model.K-model.k1)]; %% unsupervised topics
        ind21 = repmat(data.classlabels-1,1,(model.k2/data.Y))*(model.k2/data.Y);
        ind22 = repmat([1:(model.k2/data.Y)],model.N,1);
        ind23 = ind21+ind22+model.k1;
        ind24 = (ind23-1)*model.N + repmat([1:model.N]',1,size(ind23,2));
        %% for handling missing data
        missingdata = find(data.classlabels==0); %% get the missing data
        ind24(missingdata,:) = [];
        ind2(ind24(:)) = 0;
        ind2(missingdata,:) = 3;                 %% separate the missing data; don't zero any unsupervised component of them
        %% correction for missing data ends
        ind3 = find(ind2==2);
        model.gamma(ind3) = 0; % zero out indices which are not active among latent topics
    end
end


end
