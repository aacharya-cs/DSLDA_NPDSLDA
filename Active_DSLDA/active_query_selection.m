function [model] = active_query_selection (model, Nunlabeled, batchsz)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Nunlabeled: size of unlabeled data
%% batchsz: size of each batch -- ideally should be 1 but has to be more than 1 for ease of computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(BatchDataInd)
    tempmodel = online_E_step(model, data, BatchDataInd{i}, MAXESTEPITER);
    temp      = expected_entropy_reduction(tempmodel);
    if(minval<temp)
        minval   = temp;
        optmodel = tempmodel;
    end
end
model = optmodel;

end
