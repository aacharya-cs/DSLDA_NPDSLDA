function [] = createclassfiles (classfilename, numexp)

filepath = ['/v/filer4b/v35q001/ayan/Documents/aaaa/myLDA/' classfilename];
A = textread(filepath,'%s');
N = size(A,1);

if(N<numexp)
 error('N should be greater than or equal to numexp');
end

for i=1:(N-numexp)
 B{i,:} = A{i,:};
end

ind1 = [N-numexp+1:N];

for i=1:numexp
    ind2 = circshift(ind1',i);
    for j=1:length(ind2)
        B{N-numexp+j,:} = A{ind2(j),:};
    end

    writefilename = ['/v/filer4b/v35q001/ayan/Documents/aaaa/myLDA/' classfilename(1:end-4) num2str(i) '.txt'];
    fp = fopen(writefilename,'w');
    for k=1:N
        fprintf(fp, '%s\n',B{k,:});
    end
    fclose(fp);
end

end
