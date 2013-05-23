function [] =  compile_mcc_labelme (MAXCOUNTmat, MaxFunmat, MAXESTEPITERmat, MAXMSTEPITERmat, filename, p1mat, p2mat, k2mat, option, troption, numexp, svmoptionval, svmcval, minvtopic, pathname, otherindex)

%% for compiling matlab code with mcc..
%% @ Ayan Acharya, Date: Oct 1, 2012..

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% on 2nd May, for full experiments
%% compile_mcc_labelme ([3], [3], [3], [3], 'labelme_classnames.txt', [0.2], [0.2], [150], 4, 0, 8, 4, 50, 4, '/lusr/u/ayan/MLDisk/labelme_files/', 'labelme_dryrun');
%% compile_mcc_labelme ([10], [10], [10], [10], 'labelme_classnames.txt', [0.1:0.1:0.7], [0.1:0.1:0.7], [40:20:200], 4, 1, 8, 4, 1, 4, '/lusr/u/ayan/MLDisk/labelme_files/', 'labelme_firstbigrun');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make MEX=/v/filer4b/software/matlab-2011a/bin/mex
%%export LD_LIBRARY_PATH=/v/filer4b/software/matlab-2011a/bin/glnxa64:/v/filer4b/software/matlab-2011a/runtime/glnxa64:/v/filer4b/v35q001/ayan/local/libsvm-3.11/matlab;
%%export PATH=$PATH:/v/filer4b/software/matlab-2011a/bin:/v/filer4b/v35q001/ayan/local/libsvm-3.11/matlab:/v/filer4b/v35q001/ayan/Documents/ONRATLCODE/mccfiles;

addpath(genpath('/v/filer4b/software/matlab-2011a/bin/glnxa64'));
createclassfiles (filename, numexp);

if (strcmp('GLNXA64', computer()))
    mcc -m /lusr/u/ayan/Documents/DSLDA_SDM/DSLDA/mainfile_labelme.m...
        -a /lusr/u/ayan/Documents/DSLDA_SDM/liblinear-v0.1/matlab/*.mexa64...
        -a /lusr/u/ayan/MLDisk/DSLDA_mccfiles/...
        -a /lusr/u/ayan/Documents/DSLDA_SDM/DSLDA/*.txt...
        -a /lusr/u/ayan/Documents/DSLDA_SDM/DSLDA/...
        -a /lusr/u/ayan/Documents/DSLDA_SDM/forconfdata/*.mat...
        -I /lusr/u/ayan/Documents/DSLDA_SDM/siftpp/...
        -I /lusr/u/ayan/Documents/DSLDA_SDM/forconfdata/...
        -I /lusr/u/ayan/Documents/DSLDA_SDM/DSLDA/...
        -I /lusr/u/ayan/MLDisk/DSLDA_mccfiles/...
        -d /lusr/u/ayan/MLDisk/DSLDA_mccfiles...
        -o mainfile_labelme
end


for arg1=1:length(MAXCOUNTmat)
    for arg2=1:length(MaxFunmat)
        for arg3=1:length(MAXESTEPITERmat)
            for arg4=1:length(MAXMSTEPITERmat)
                for arg5=1:length(p1mat)
                        for arg7=1:length(k2mat)

                            for i=1:numexp
                                classfilename = ['/lusr/u/ayan/Documents/DSLDA_SDM/DSLDA/' filename(1:end-4) num2str(i) '.txt'];
                                writescript_labelme(MAXCOUNTmat(arg1), MaxFunmat(arg2), MAXESTEPITERmat(arg3), MAXMSTEPITERmat(arg4), classfilename, p1mat(arg5), p2mat(arg5), k2mat(arg7), option, troption, svmoptionval, svmcval, minvtopic, pathname, otherindex, i);
                            end
                            condorscript = ['./condorsubmit_labelme.sh ' num2str(numexp) ' mainfile_labelme'];
                            system(condorscript); 
                           
                        end
                end
            end
        end
    end
end



end

