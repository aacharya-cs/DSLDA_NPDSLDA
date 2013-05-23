function [] = WriteInGmeansFormat(fid1,fid2,fid3,colptr,rowptr,nzrs)

fprintf(fid1,'%d\n',colptr);
fprintf(fid2,'%d\n',rowptr);
fprintf(fid3,'%d\n',nzrs);

end
