function [] = writescript_ayahoo (params) 

MAXCOUNT = params.MAXCOUNT;
MaxFun = params.MaxFun;
MAXESTEPITER = params.MAXESTEPITER;
MAXMSTEPITER = params.MAXMSTEPITER;
classfilename = params.classfilename;
p1 = params.p1;
p2 = params.p2;
p3 = params.p3;
k2 = params.k2;
option = params.option;
troption = params.troption;
svmoptionval = params.svmoptionval;
svmcval = params.svmcval;
minvtopic = params.minvtopic;
pathname = params.pathname;
otherindex = params.otherindex;
i = params.i;
iter = params.iter;
epsilon = params.epsilon;

numjobs = 1;
scriptname = ['/lusr/u/ayan/MLDisk/DSLDA_mccfiles/run_mainfile_ayahoo' num2str(i) '.sh'];

fp = fopen(scriptname, 'w');

fprintf(fp, 'universe = vanilla\n');
fprintf(fp, 'getenv = True\n');
fprintf(fp, '+Group = "GRAD"\n');
fprintf(fp, '+Project = "AI_ROBOTICS"\n');
fprintf(fp, '+ProjectDescription = "transfer learning using graphical models"\n');
fprintf(fp, 'requirements = InMastodon\n');
fprintf(fp, 'executable = /lusr/u/ayan/Documents/DSLDA_SDM/mccfiles/mainfile_ayahoo\n');

arg1 = num2str(MAXCOUNT);
arg2 = num2str(MaxFun);
arg3 = num2str(MAXESTEPITER);
arg4 = num2str(MAXMSTEPITER);
arg5 = classfilename;
arg6 = num2str(p1);
arg7 = num2str(p2);
arg8 = num2str(p3);
arg9 = num2str(k2);
arg10 = num2str(option);
arg11 = num2str(troption);
arg12 = num2str(svmoptionval);
arg13 = num2str(svmcval);
arg14 = num2str(minvtopic);
arg15 = pathname;
arg16 = otherindex;
arg17 = num2str(iter);
arg18 = num2str(epsilon);

arg = ['arguments = ' arg1 ' ' arg2 ' ' arg3 ' ' arg4 ' ' arg5];
arg = [arg ' ' arg6 ' ' arg7 ' ' arg8 ' ' arg9 ' ' arg10 ' ' arg11 ' ' arg12 ' ' arg13 ' ' arg14];
arg = [arg ' ' arg15 ' ' arg16 ' ' arg17 ' ' arg18];

fprintf(fp, '%s\n', arg);

outfile = ['output = /lusr/u/ayan/MLDisk/DSLDA_mccfiles/condor_log_ayahoo/mainfile_ayahoo' num2str(i) otherindex '.out'];
fprintf(fp, '%s\n', outfile);
err = ['error = /lusr/u/ayan/MLDisk/DSLDA_mccfiles/condor_log_ayahoo/mainfile_ayahoo' num2str(i) otherindex '.err'];
fprintf(fp, '%s\n', err);
fprintf(fp, 'notification = Never \n');
queue = ['queue ' num2str(numjobs)];
fprintf(fp, '%s\n', queue);
fclose(fp);

end
