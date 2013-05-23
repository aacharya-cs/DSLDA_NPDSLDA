function [] =  compile_mcc (MAXCOUNTmat, MaxFunmat, MAXESTEPITERmat, MAXMSTEPITERmat, filename, p1mat, p2mat, k2mat, option, troption, numexp, svmoptionval, svmcval, minvtopic, pathname, otherindex)

%% for compiling matlab code with mcc..
%% @ Ayan Acharya, Date: Jan 19, 2012..

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% on 30th Apr, for full experiments
%% compile_mcc ([3], [3], [3], [3], 'ayahoo_classname.txt', [0.2], [0.2], [40], 4, 0, 12, 4, 0.1, '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/ayahoo_files/', 'demorun_ayahoo');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make MEX=/v/filer4b/software/matlab-2011a/bin/mex
%%export LD_LIBRARY_PATH=/v/filer4b/software/matlab-2011a/bin/glnxa64:/v/filer4b/software/matlab-2011a/runtime/glnxa64:/v/filer4b/v35q001/ayan/local/libsvm-3.11/matlab;
%%export PATH=$PATH:/v/filer4b/software/matlab-2011a/bin:/v/filer4b/v35q001/ayan/local/libsvm-3.11/matlab:/v/filer4b/v35q001/ayan/Documents/ONRATLCODE/mccfiles;

addpath(genpath('/v/filer4b/software/matlab-2011a/bin/glnxa64'));
createclassfiles (filename, numexp);

if (strcmp('GLNXA64', computer()))
    mcc -m /v/filer4b/v35q001/ayan/Documents/aaaa/myLDA/mainfile_ayahoo.m...
        -a /v/filer4b/v35q001/ayan/Documents/aaaa/liblinear-v0.1/matlab/*.mexa64...
        -a /v/filer4b/v35q001/ayan/Documents/aaaa/myLDA/*.txt...
        -I /v/filer4b/v35q001/ayan/Documents/aaaa/siftpp/...
        -I /v/filer4b/v16q001/ml/data/Ayans/ayahoo_files/...
        -I /v/filer4b/v35q001/ayan/Documents/aaaa/forconfdata/...
	-I /v/filer4b/v35q001/ayan/Documents/aaaa/myLDA/...
        -d /v/filer4b/v35q001/ayan/Documents/aaaa/mccfiles...
        -o mainfile_ayahoo
end


for arg1=1:length(MAXCOUNTmat)
    for arg2=1:length(MaxFunmat)
        for arg3=1:length(MAXESTEPITERmat)
            for arg4=1:length(MAXMSTEPITERmat)
                for arg5=1:length(p1mat)
                    for arg6=1:length(p2mat)
                        for arg7=1:length(k2mat)
                            
                            for i=1:numexp
                                classfilename = ['/v/filer4b/v35q001/ayan/Documents/ONRATLCODE/' filename(1:end-4) num2str(i) '.txt'];
                                writescript(MAXCOUNTmat(arg1), MaxFunmat(arg2), MAXESTEPITERmat(arg3), MAXMSTEPITERmat(arg4), classfilename, p1mat(arg5), p2mat(arg6), k2mat(arg7), option, troption, svmoptionval, svmcval, minvtopic, pathname, otherindex, i);
                            end
                            condorscript = ['./condorsubmit.sh ' num2str(numexp) ' mainfile_ayahoo'];
                            system(condorscript); 
                           
                        end
                    end
                end
            end
        end
    end
end



end

