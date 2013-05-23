function [ind]  = SelRandomVec(N,k)

%% N: size of vector, k: number of elements to be chosen

if(k==N)
    ind = [1:N];
else
    permvect = randperm(N);
    ind      = permvect(1:k);
    ind      = sort(ind);
end

end