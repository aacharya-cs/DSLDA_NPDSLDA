function [] = disp_accuracy_mod_ayahoo()

clc;
clear;

%% change the settings here
savepaths{1} = ['/lusr/u/ayan/MLDisk/ayahoo_15_Dec_2012/'];

otherindex = 'big_run2';
classfilenameprefix = '/lusr/u/ayan/Documents/DSLDA_SDM/DSLDA/ayahoo_classnames';
p1mat = [0.7];
p2mat = p1mat;
p3mat = [0.1:0.1:1];
k2mat = [100];
epsilonmat = [0.5:0.1:0.9];
classnum = 9;
option = 4;
troption = 0;
svmoptionval = 4;
svmcval = 10;
minvtopic = 4;
iternum = 5;

%% path where the files are saved
dirname = '/lusr/u/ayan/MLDisk/ayahoo_results/big_run2/';
mdirstr = ['mkdir ' dirname(1:end-1)];
if(~exist(dirname(1:end-1)))
    system(mdirstr);
end

addpath(genpath('/lusr/u/ayan/Documents/DSLDA_SDM/DSLDA'));
%% add paths of the saved .mat files
for i=1:length(savepaths)
    addpath(genpath(savepaths{i}));
end

savedstat    = zeros(length(epsilonmat), length(p3mat), length(k2mat), 6);
savedstatstd = zeros(length(epsilonmat), length(p3mat), length(k2mat), 6);

for arg5=1:length(epsilonmat)
        for arg3=1:length(k2mat)
            for arg4=1:length(p3mat)
                accval = [];
                for arg2 = 1:iternum

                    macc = zeros(classnum, 6);
                    count = 0;
                    indcount{arg2} = [];
                    
                    for i=1:classnum
                        
                        classfilename = [classfilenameprefix num2str(i) '.txt'];
                        B = textread(classfilename, '%s');
                        
                        tempfile = zeros(classnum,1);
                        for ss=1:classnum
                            savefilename{ss} = [savepaths{1} B{end} '_' num2str(minvtopic) '_' num2str(p1mat(1)) '_' num2str(p2mat(1))];
                            savefilename{ss} = [savefilename{ss} '_' num2str(p3mat(arg4)) '_' num2str(k2mat(arg3)) '_' num2str(option)];
                            savefilename{ss} = [savefilename{ss} '_' num2str(troption) '_' num2str(svmoptionval) '_' num2str(epsilonmat(arg5))];
                            savefilename{ss} = [savefilename{ss} '_' num2str(svmcval) '_' otherindex '_' num2str(arg2) '.mat'];
                            tempfile(ss) = exist(savefilename{ss});
                        end
                        
                        if(sum(tempfile)>0)
                            
                            indcount{arg2} = [indcount{arg2} i];
                            sfilename = savefilename{find(tempfile>0)};
                            A = load(sfilename);
                            savefilename;
                            count = count + 1;
                            p = [];
                            
                            %% SVM
                            macc(i, 1) = 100*sum(diag(A.svmperf.confmat_test))/sum(sum(A.svmperf.confmat_test));
                            %% MedLDA-MTL
                            macc(i, 2) = A.testperfmedLDA.multiclassacc;
                            %% DSLDA-OSST
                            macc(i, 3) = A.testperfDSLDAOSST.multiclassacc;
                            %% DSLDA-NSLT
                            macc(i, 4) = A.testperfDSLDANSLT.multiclassacc;
                            %% DSLDA
                            macc(i, 5) = A.testperf.multiclassacc;
                            %% MedLDA-OVA
                            macc(i, 6) = A.testperfmedLDAova{1}.multiclassaccuracy*100;
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        end
                    end
                    
                    if(count>0)
                        accval = [accval macc(indcount{arg2},:)'];
                    end
                end               

                if(length(accval)>=6) %% the limit is the number of models
                    accval(accval==0)= [];
                    meanval = mean(accval,2);
                    stdval  = (std(accval',1))';
                    savedstat(arg5, arg4, arg3, :) = meanval;
                    savedstatstd(arg5, arg4, arg3,:) = stdval;
                end
                
            end
        end
end

disp('hey here!')

for arg5=1:length(epsilonmat)
    for arg3=1:length(k2mat)
        errorbar(p3mat', squeeze(savedstat(arg5,:,arg3,1)), squeeze(savedstatstd(arg5,:,arg3,1)), 'b.-', 'LineWidth', 2); hold on;
        errorbar(p3mat', squeeze(savedstat(arg5,:,arg3,2)), squeeze(savedstatstd(arg5,:,arg3,2)), 'g.-', 'LineWidth', 2); hold on;
        errorbar(p3mat', squeeze(savedstat(arg5,:,arg3,3)), squeeze(savedstatstd(arg5,:,arg3,3)), 'k.-', 'LineWidth', 2); hold on;
        errorbar(p3mat', squeeze(savedstat(arg5,:,arg3,4)), squeeze(savedstatstd(arg5,:,arg3,4)), 'r.-', 'LineWidth', 2); hold on;
        errorbar(p3mat', squeeze(savedstat(arg5,:,arg3,5)), squeeze(savedstatstd(arg5,:,arg3,5)), 'm.-', 'LineWidth', 2); hold on;
        errorbar(p3mat', squeeze(savedstat(arg5,:,arg3,6)), squeeze(savedstatstd(arg5,:,arg3,6)), 'c*-', 'LineWidth', 2); hold on;
        legend('SVM', 'MedLDA-MTL' , 'DSLDA-OSST', 'DSLDA-NSLT', 'DSLDA', 'MedLDA-OVA'); grid on; hold off;
        savefilename = [dirname num2str(epsilonmat(arg5)) '_' num2str(k2mat(arg3)) '_.jpg'];
        saveas(gcf,savefilename);
    end
end

save([dirname otherindex],'savedstat');
save([dirname otherindex '_std'],'savedstatstd');

end

