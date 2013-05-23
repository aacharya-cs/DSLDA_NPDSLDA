function [medLDAperf] = getmedLDAperf(trdata, trlabel, testdata, testlabel)

trfilename   = 'medLDAtrainfile';
testfilename = 'medLDAtestfile';

fp1 = fopen(trfilename, 'w+');
fp2 = fopen(testfilename, 'w+');

N1 = size(trdata,1);
N2 = size(testdata,1);

for i=1:max(N1,N2)
    if(i<=N1)
        str1 = convertToLibSVMformat(trdata(i,:), trlabel(i));
        fprintf(fp1, '%s\n', str1);
    end
    if(i<=N2)
        str2 = convertToLibSVMformat(testdata(i,:), testlabel(i));
        fprintf(fp2, '%s\n', str2);
    end
end
fclose(fp1);
fclose(fp2);

estinfstr = '/v/filer4b/v35q001/ayan/Documents/aaaa/medlda/./medlda MEDsLDAc estinf';
system(estinfstr);

end
