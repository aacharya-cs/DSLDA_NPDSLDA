function [freq] = prophist(temp, ind)

[M N] = size(temp);

if(M~=N)
    freq = hist(temp,ind);
elseif(M==1 && N==1)
    freq = 1;
else
    error('something wrong inside prophist');
end

end