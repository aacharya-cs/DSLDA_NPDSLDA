function [] = prepdataformyLDA()

fid = fopen('filepaths.txt','r');
tline = fgetl(fid);
while ischar(tline)
    ipfilename = [tline(1:end-4) 'vwords.mat']
    A = load(ipfilename);
    B = [A.histogram A.vwordsind];
    ind = find(A.histogram>0);
    vwords = B(ind,:);   
    opfilename = [ipfilename(1:end-4) '_compact.mat'];
    save(opfilename,'vwords');
end
fclose(fid);

end
