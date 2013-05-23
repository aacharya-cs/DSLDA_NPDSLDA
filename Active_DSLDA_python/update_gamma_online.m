function [model] = update_gamma_online(model, BatchDataInd, data)

Nsz         = length(BatchDataInd);
alphaterm1  = [repmat(model.alpha1, Nsz, 1) zeros(Nsz, model.K-model.k1)];
alphaterm2  = [zeros(Nsz, model.k1) repmat(model.alpha2, Nsz, 1)];
term1       = alphaterm1 + alphaterm2;
term2       = sum_phi_online(model, data, BatchDataInd);
model.gamma = (term1+term2);

if (model.phase==1) %% only in training phase
    ind1 = find(data.annotations==0); %% since latent topics are appended as extra columns; does not make a difference in indexing
    model.gamma(ind1) = 0; %% zero out indices which are not active among supervised topics
end

end
