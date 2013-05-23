function [model] =  batch_phi_initialization(model, data, N)

%% N:    batch size
%% data: new data to be added to training pool
%% Nnow: current size of the trainig documents
Nnow = max(size(model.phi));

%% cell array of dimension N*1
%% nth element is of dimension length(windex{n})*K
for n=Nnow+1:N
    temp = randind*ones(max(size(data.windex{n})), model.K); %% uniform initialization of phi's
    temp = temp./repmat(sum(temp,2),1,model.K);
    model.phi{n} = temp;
    if(size(temp,1)==1 && size(temp,2)==1)
        n
        data.windex{n}'
        error('problem in init');
    end
end

end