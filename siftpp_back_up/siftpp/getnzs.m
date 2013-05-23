function [C] = getnzs(A)

ind   = find(A>0);
[i,j] = ind2sub(size(A),ind);

B = [i j A(ind)];
[~, index] = sort(B(:,1));
C = B(index,:);

end
