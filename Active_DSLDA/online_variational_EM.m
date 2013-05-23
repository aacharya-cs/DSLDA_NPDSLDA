function [model, perfval] = online_variational_EM (data, MAXCOUNT, MAXESTEPITER, MAXMSTEPITER, MaxFun,  p, K, option, phase, model, epsilon, svmcval)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% main code for running active online variational EM on DSLDA
% @ Ayan Acharya, Date: 05.28.2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model     = online_init_params(data, K, data.V, p, option, 1, epsilon, svmcval);
maxvalue  = -1e50;
poolempty = 1;
countVEM  = 1;

while (poolempty==1) %% there is still unlabeled training data
    
    disp('count from V-EM');
    countVEM
   
    %% E step
    model     = select_labeled_data (model,data, MAXESTEPITER, maxvalue, option, countVEM);
    %%     value1   = cal_liKelihood(model, data)
    %%     if (compareval(value1, maxvalue))
    %%         maxvalue = value1;
    %%     else
    %%         error('Incorrect after E step');
    %%     end
    
    %% M step
    model     = M_step(model,data, MAXMSTEPITER, MaxFun, maxvalue);
    %% value2   = cal_liKelihood(model, data);
    %% if (compareval(value2, maxvalue))
    %%    maxvalue = value2;
    %% else
    %%    error('Incorrect after M step');
    %% end
    
    %% check whether the training pool is empty or not
    poolempty = isemptytrpool(data);
    countVEM  = countVEM + 1;
    
    %% calculate the accuracy on the training set
    [accval, confmat] = cal_accuracy(model, data);
    perfval.accval  = accval;
    perfval.confmat = confmat;
    perfval.multiclassacc = sum(diag(confmat))/sum(sum(confmat));
    
end


end
