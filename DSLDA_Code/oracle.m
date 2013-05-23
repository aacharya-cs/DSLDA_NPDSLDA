function [] = oracle(testmodel, testdata, trmodel, trdata)

%% get the uncertainty for class labels in test data
temp        = sum_phi(trmodel, trdata);
sigmoid_eta = 1./1+exp(-testmodel.eta*testdata.temp');
prob_est_tr = sigmoid_eta./repmat(sum(sigmoid_eta,1),testmodel.Y,1); %% according to liblinear normalization scheme
%% smoothing the probabilities to avoid zero
prob_est_tr(find(prob_est_tr==0)) = trmodel.MINVALUE; 
tr_entropy  = sum(sum(prob_est_tr.*log(prob_est_tr))); 

%% get the uncertainty for class labels in test data
temp          = sum_phi(testmodel, testdata);
sigmoid_eta   = 1./1+exp(-testmodel.eta*testdata.temp');
prob_est_test = sigmoid_eta./repmat(sum(sigmoid_eta,1),testmodel.Y,1); %% according to liblinear normalization scheme
%% smoothing the probabilities to avoid zero
prob_est_tr(find(prob_est_tr==0)) = trmodel.MINVALUE; 
test_entropy  = sum(prob_est_tr.*log(prob_est_tr),1);

total_entropy = tr_entropy + 

end
