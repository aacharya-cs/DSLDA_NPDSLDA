function [] = disp_accuracy_mod_labelme()


clc;
clear;

%% change the settings here
%%savepaths{1} = ['/lusr/u/ayan/MLDisk/LabelMeData/LabelMeResults_09_Oct_2012/'];
savepaths{1} = ['/lusr/u/ayan/MLDisk/LabelMeData/LabelMeResults_11_Oct_2012/'];

otherindex = 'hahabigrun';
classfilenameprefix = '/lusr/u/ayan/Documents/DSLDA_SDM/DSLDA/labelme_classnames';
p1mat = [0.1:0.1:0.5];
p2mat = p1mat;
k2mat = [100:25:300];
classnum = 8;
option = 4;
troption = 0;
svmoptionval = 4;
svmcval = 1;
minvtopic = 4;
%% path where the files are saved
dirname = '/lusr/u/ayan/MLDisk/LabelMeData/hahabigrun/';
mdirstr = ['mkdir ' dirname(1:end-1)];
if(~exist(dirname(1:end-1)))
    system(mdirstr);
end


addpath(genpath('/lusr/u/ayan/Documents/DSLDA_SDM/DSLDA'));
%% add paths of the saved .mat files

for i=1:length(savepaths)
    addpath(genpath(savepaths{i}));
end

savedstat    = zeros(length(p1mat), length(k2mat), 5);
savedstatstd = zeros(length(p1mat), length(k2mat), 5);

for arg3=1:length(k2mat)
    for arg1=1:length(p1mat)
        
        macc = zeros(classnum,5);
        count = 0;
        indcount = [];
        
        for i=1:classnum
            
            classfilename = [classfilenameprefix num2str(i) '.txt'];
            B = textread(classfilename, '%s');
            
            tempfile = zeros(classnum,1);
            for ss=1:classnum
                savefilename{ss} = [savepaths{1} B{end} '_' num2str(minvtopic) '_' num2str(p1mat(arg1)) '_' num2str(p2mat(arg1)) '_' num2str(k2mat(arg3)) '_' num2str(option) '_' num2str(troption) '_' num2str(svmoptionval)];
                savefilename{ss} = [savefilename{ss} '_' num2str(svmcval) '_labelme_' otherindex '.mat'];
                tempfile(ss) = exist(savefilename{ss});
            end
            
            %%savefilename{1}
            %%tempfile
            %%pause;
            if(sum(tempfile)>0)
                
                indcount = [indcount i];
                sfilename = savefilename{find(tempfile>0)};
                A = load(sfilename);
                savefilename;
                count = count + 1;
                p = [];
                
                %% SVM
                macc(count, 1) = sum(diag(A.svmperf.confmat_test))/sum(sum(A.svmperf.confmat_test));
                %% medLDA-MTL
                macc(count, 2) = A.testperfmedLDA.multiclassacc;
                %% DSLDA-OSST
                macc(count, 3) = 0; %%A.testperfDSLDAOSST.multiclassacc;
                %% DSLDA-NSLT1
                macc(count, 4) = A.testperfDSLDANSLT1.multiclassacc;
                %% DSLDA
                macc(count, 5) = A.testperf.multiclassacc;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%macc
                %%pause
            end
        end
        if(count>0)
            meanval = mean(macc(indcount,:),1);
            stdval  = std(macc(indcount,:),1); 
            savedstat(arg1,arg3,:) = meanval';
            savedstatstd(arg1,arg3,:) = stdval';
        end
    end
end


for arg3=1:length(k2mat)
    errorbar(p1mat', savedstat(:,arg3,1), savedstatstd(:,arg3,1), 'b.-'); hold on;
    errorbar(p1mat', savedstat(:,arg3,2), savedstatstd(:,arg3,2), 'g*-'); hold on;
    errorbar(p1mat', savedstat(:,arg3,3), savedstatstd(:,arg3,3), 'k+-'); hold on;
    errorbar(p1mat', savedstat(:,arg3,4), savedstatstd(:,arg3,4), 'ro-'); hold on;
    errorbar(p1mat', savedstat(:,arg3,5), savedstatstd(:,arg3,5), 'ms-'); hold on;
    legend('svm','medldaMTL','DSLDA-OSST','DSLDA-NSLT1','DSLDA'); grid on; hold off;
    savefilename = [dirname num2str(k2mat(arg3)) '_.jpg'];
    saveas(gcf,savefilename);
end

save([dirname otherindex],'savedstat');
save([dirname otherindex '_std'],'savedstatstd');

end

