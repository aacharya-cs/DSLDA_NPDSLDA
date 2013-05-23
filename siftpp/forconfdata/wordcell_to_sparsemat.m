function [wordmatsparse] = wordcell_to_sparsemat(filename, vocabsz)

%% converts word cells to sparse matrix

%% example input: wordcell_to_sparsemat("kdd_data.mat",4000)

A = load(filename);
A = A.w;
wordmat = [];
[M N]= size(A);

for i=1:max(M,N)
 ind = A{i};
 ind = sort(ind);
 B = hist(ind, unique(ind));
 temp = zeros(1,vocabsz);
 temp(ind) = B;
 wordmat = [wordmat; temp];
end

wordmatsparse = sparse(wordmat);
%% feed this to the liblinear package

end

