function [] = StoreInMatFormat(filename)

fid = fopen(filename,'r');
tline = fgetl(fid);
while ischar(tline)
    tline
    binfilename = [tline(1:end-4) '.desc'];
    fp = fopen(binfilename,'r');
    A = fread(fp);
    fclose(fp);
    sz2 = 128;
    sz1 = length(A)/sz2;
    A = reshape(A, sz2, sz1);
    A = A';
    opfilename = [tline(1:end-4) '.mat'];
    save(opfilename,'A');
    tline = fgetl(fid);
end
fclose(fid);

end
