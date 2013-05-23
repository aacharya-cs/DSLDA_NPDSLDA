function [model] = online_E_step(model, data, BatchDataInd, MAXESTEPITER)

%% E step of online DSLDA with batch sample selected in active step

count = 0;
Nsz   = length(BatchDataInd);
labeleddata = data.annotations(BatchDataInd,:); 

disp('E step starts');

while(count<MAXESTEPITER)
    %% disp('count from E-step');
    count  = count+1;
    %% update of phi
    [model.phi model.ss_topicword model.ss_topic] = update_phi_cpp(model, data, psi(model.gamma), option, 4, [labeleddata ones(Nsz, model.k2)]);
    %% update of gamma
    model  = update_gamma_online(model, BatchDataInd, data);
end

end

