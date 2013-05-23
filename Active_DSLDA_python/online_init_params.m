function [model] = online_init_params(data, epsilon, svmcval)

%% Random Initialization of model and variational parameters
randind       = 1;
model.N       = size(data.wcount,2);
model.V       = data.V;
model.k1      = data.k1;
model.k2      = data.k2;
model.epsilon = epsilon;  %% weight of supervised topics
model.alpha1  = randind*ones(1,model.k1)/model.k1;   %% the supervised topics are shared across DSLDA and DSLDA with no shared latent topic
model.K       = (model.k1+model.k2);
model.alpha2  = randind*ones(1,model.k2)/model.k2;
%% new initialization of gamma
tmp1          = ones(model.N, model.K)/model.K;
tmp2          = repmat(data.nwordspdoc,1,model.K)/model.K;
model.gamma   = tmp1 + tmp2;
model.tauzero = 2;
model.kappa   = 5;
model.rho     = power(model.tauzero, - model.kappa);

%% no need to initialize phi in advance; will do it at the start of every small batch of documents
model.MINVALUE = 1e-100;
model.Y   = data.Y;
model.C2  = svmcval;
model.C1  = 1;
model.mu  = randind*zeros(model.N,model.Y);  %% N*Y  dual variables // zero because we have no idea of the duals right now
model.eta = randind*ones(model.Y,model.K);   %% Y*K  svm weights

%% random initialization of sufficient statistics
model.ss_topicword = 10*ones(model.K, model.V) + rand([model.K, model.V]);
model.ss_topic = sum(model.ss_topicword,2)';
%% initialization of beta based on sufficient statistics
model.log_beta = update_beta_cpp (model);

end
