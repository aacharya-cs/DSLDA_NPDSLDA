function [] =  compile_mcc_confdata (MAXCOUNTmat, MaxFunmat, MAXESTEPITERmat, MAXMSTEPITERmat, filename, p1mat, p2mat, k2mat, option, troption, numexp, svmoptionval, svmcval, minvtopic, pathname, otherindex)

%% for compiling matlab code with mcc..
%% @ Ayan Acharya, Date: Jan 19, 2012..

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% on 2nd May, for full experiments
%% compile_mcc_confdata ([15], [10], [10], [10], 'conferencenames.txt', [0.5:0.1:1], [0.5:0.1:1], [50:25:200], 4, 0, 8, 4, 0.1, 4, '/lusr/u/ayan/Documents/aaaa/forconfdata/', 'bigrun3');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make MEX=/v/filer4b/software/matlab-2011a/bin/mex
%%export LD_LIBRARY_PATH=/v/filer4b/software/matlab-2011a/bin/glnxa64:/v/filer4b/software/matlab-2011a/runtime/glnxa64:/v/filer4b/v35q001/ayan/local/libsvm-3.11/matlab;
%%export PATH=$PATH:/v/filer4b/software/matlab-2011a/bin:/v/filer4b/v35q001/ayan/local/libsvm-3.11/matlab:/v/filer4b/v35q001/ayan/Documents/ONRATLCODE/mccfiles;

addpath(genpath('/v/filer4b/software/matlab-2011a/bin/glnxa64'));
createclassfiles (filename, numexp);

if (strcmp('GLNXA64', computer()))
    mcc -m /v/filer4b/v35q001/ayan/Documents/aaaa/myLDA/mainfile_confdata.m...
        -a /v/filer4b/v35q001/ayan/Documents/aaaa/liblinear-v0.1/matlab/*.mexa64...
        -a /v/filer4b/v35q001/ayan/Documents/aaaa/myLDA/*.txt...
        -a /v/filer4b/v35q001/ayan/Documents/aaaa/forconfdata/*.mat...
        -I /v/filer4b/v35q001/ayan/Documents/aaaa/siftpp/...
        -I /v/filer4b/v35q001/ayan/Documents/aaaa/forconfdata/...
        -I /v/filer4b/v35q001/ayan/Documents/aaaa/myLDA/...
        -d /v/filer4b/v35q001/ayan/Documents/aaaa/mccfiles...
        -o mainfile_confdata
end


for arg1=1:length(MAXCOUNTmat)
    for arg2=1:length(MaxFunmat)
        for arg3=1:length(MAXESTEPITERmat)
            for arg4=1:length(MAXMSTEPITERmat)
                for arg5=1:length(p1mat)
                    %for arg6=1:length(p2mat)
                        for arg7=1:length(k2mat)

                            for i=1:numexp
                                classfilename = ['/v/filer4b/v35q001/ayan/Documents/aaaa/myLDA/' filename(1:end-4) num2str(i) '.txt'];
                                writescript_confdata(MAXCOUNTmat(arg1), MaxFunmat(arg2), MAXESTEPITERmat(arg3), MAXMSTEPITERmat(arg4), classfilename, p1mat(arg5), p2mat(arg5), k2mat(arg7), option, troption, svmoptionval, svmcval, minvtopic, pathname, otherindex, i);
                            end
                            condorscript = ['./condorsubmit.sh ' num2str(numexp) ' mainfile_confdata'];
                            system(condorscript); 
                           
                        end
                    %end
                end
            end
        end
    end
end



end

