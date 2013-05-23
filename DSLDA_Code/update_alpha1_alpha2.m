function [model] = update_alpha1_alpha2 (model, data, MaxFun)

options = optimset('LargeScale', 'on', 'Algorithm', 'interior-point', 'GradObj', 'on', 'MaxFunEvals', MaxFun, 'Display', 'off');

if(model.phase==1)
    M = [data.annotations ones(model.N, model.K-model.k1)];
else
    M = [ones(model.N, model.K)];
end

if(model.phase==1 && model.option==5) %% only for DSLDA-NSLT
    ind2  = ones(model.N,model.k1);
    ind2  = [ind2 2*ones(model.N,model.K-model.k1)];
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
    M(ind3) = 0; % zero out indices which are not active among latent topics
end

x0      = [model.alpha1 model.alpha2];
D       = length(x0);
lb      = model.MINVALUE*ones(1,D);
temp    = fmincon(@L_alpha1_alpha2, x0, [], [], [], [], lb, [], [], options, model.gamma, M);
model.alpha1 = temp(1:model.k1);
model.alpha2 = temp(model.k1+1:end);

end
