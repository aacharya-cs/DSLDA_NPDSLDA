function [] =  compile_mcc_ayahoo (MAXCOUNTmat, MaxFunmat, MAXESTEPITERmat, MAXMSTEPITERmat, filename, p1mat, p2mat, p3mat, k2mat, option, troption, numexp, svmoptionval, svmcval, minvtopic, pathname, otherindex, iternum, epsilonmat)

%% for compiling matlab code with mcc..
%% @ Ayan Acharya, Date: Dec 15, 2012..

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compile_mcc_ayahoo ([3], [3], [3], [3], 'ayahoo_classnames.txt', [0.2], [0.2], [0.8], [100], 4, 0, 6, 4, 10, 4, '/lusr/u/ayan/MLDisk/ayahoo_files/', 'trial_run_ayahoo', 1, 0.8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% iternum: number of experiments per configuration -- used to get a good estimate of variance

addpath(genpath('/v/filer4b/software/matlab-2011a/bin/glnxa64'));
createclassfiles (filename, numexp);

if (strcmp('GLNXA64', computer()))
    mcc -m /v/filer4b/v35q001/ayan/Documents/DSLDA_SDM/DSLDA/mainfile_ayahoo.m...
        -a /v/filer4b/v35q001/ayan/Documents/DSLDA_SDM/DSLDA/liblinear-v0.1/matlab/*.mexa64...
        -a /v/filer4b/v35q001/ayan/Documents/DSLDA_SDM/DSLDA/*.txt...
        -a /v/filer4b/v35q001/ayan/Documents/DSLDA_SDM/DSLDA/*.mat...
        -a /v/filer4b/v35q001/ayan/Documents/DSLDA_SDM/forconfdata/*.mat...
        -I /v/filer4b/v35q001/ayan/Documents/DSLDA_SDM/DSLDA/...
        -d /v/filer4b/v35q001/ayan/Documents/DSLDA_SDM/mccfiles...
        -o mainfile_ayahoo
end


for arg1=1:length(MAXCOUNTmat)
    for arg2=1:length(MaxFunmat)
        for arg3=1:length(MAXESTEPITERmat)
            for arg4=1:length(MAXMSTEPITERmat)
                for arg5=1:length(p1mat)
                    for arg6=1:length(p3mat)
                        for arg7=1:length(k2mat)
                            for arg8 = 1:iternum
                                for arg9 = 1:length(epsilonmat)
                                    for i=1:numexp
                                        params.MAXCOUNT = MAXCOUNTmat(arg1);
                                        params.MaxFun = MaxFunmat(arg2);
                                        params.MAXESTEPITER = MAXESTEPITERmat(arg3);
                                        params.MAXMSTEPITER = MAXMSTEPITERmat(arg4);
                                        params.classfilename = ['/v/filer4b/v35q001/ayan/Documents/DSLDA_SDM/DSLDA/' filename(1:end-4) num2str(i) '.txt'];
                                        params.p1 = p1mat(arg5);
                                        params.p2 = p2mat(arg5);
                                        params.p3 = p3mat(arg6);
                                        params.k2 = k2mat(arg7);
                                        params.option = option;
                                        params.troption = troption;
                                        params.svmoptionval = svmoptionval;
                                        params.svmcval = svmcval;
                                        params.minvtopic = minvtopic;
                                        params.pathname = pathname;
                                        params.otherindex = otherindex;
                                        params.i = i;
                                        params.iter = arg8;
                                        params.epsilon = epsilonmat(arg9);
                                        writescript_ayahoo(params);
                                    end
                                    condorscript = ['./condorsubmit_ayahoo.sh ' num2str(numexp) ' mainfile_ayahoo'];
                                    system(condorscript);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end



end

