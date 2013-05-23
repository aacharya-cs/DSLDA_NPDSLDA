function [colptr, rowptr, nzrs] = getnzs_for_gmeans(A)

%% A is of the format m*n where m is the number of features and n is the number of data points
%% returns CCS format

ind   = find(A>0);
[i,j] = ind2sub(size(A),ind);

B = [i j A(ind)];
[~, index] = sort(B(:,2));
C = B(index,:);

[~,temp,~] = unique(C(:,2),'first');

colptr = temp-1;
rowptr = C(:,1)-1;
nzrs   = C(:,3);

end
