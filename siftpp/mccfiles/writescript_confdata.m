function [] = writescript_confdata (MAXCOUNT, MaxFun, MAXESTEPITER, MAXMSTEPITER, classfilename, p1, p2, k2, option, troption, svmoptionval, svmcval, minvtopic, pathname, otherindex, i) 

numjobs = 1;
scriptname = ['/v/filer4b/v35q001/ayan/Documents/aaaa/mccfiles/run_mainfile_confdata' num2str(i) '.sh'];

fp = fopen(scriptname, 'w');

fprintf(fp, 'universe = vanilla\n');
fprintf(fp, 'getenv = True\n');
fprintf(fp, '+Group = "GRAD"\n');
fprintf(fp, '+Project = "AI_ROBOTICS"\n');
fprintf(fp, '+ProjectDescription = "transfer learning using graphical models"\n');
fprintf(fp, 'requirements = InMastodon\n');
fprintf(fp, 'executable = /v/filer4b/v35q001/ayan/Documents/aaaa/mccfiles/mainfile_confdata\n');

arg1 = num2str(MAXCOUNT);
arg2 = num2str(MaxFun);
arg3 = num2str(MAXESTEPITER);
arg4 = num2str(MAXMSTEPITER);
arg5 = classfilename;
arg6 = num2str(p1);
arg7 = num2str(p2);
arg8 = num2str(k2);
arg9 = num2str(option);
arg10 = num2str(troption);
arg11 = num2str(svmoptionval);
arg12 = num2str(svmcval);
arg13 = num2str(minvtopic);
arg14 = pathname;
arg15 = otherindex;

arg = ['arguments = ' arg1 ' ' arg2 ' ' arg3 ' ' arg4 ' ' arg5];
arg = [arg ' ' arg6 ' ' arg7 ' ' arg8 ' ' arg9 ' ' arg10 ' ' arg11 ' ' arg12 ' ' arg13 ' ' arg14 ' ' arg15]; %% ' ' arg16];
%%arg = [arg ' ' arg17 ' ' arg18 ' ' arg19 ' ' arg20 ' ' arg21];

fprintf(fp, '%s\n', arg);

outfile = ['output = /v/filer4b/v35q001/ayan/Documents/aaaa/mccfiles/condor_log/mainfile_confdata' num2str(i) otherindex '.out'];
%%fprintf(fp, '%s\n', outfile);
err = ['error = /v/filer4b/v35q001/ayan/Documents/aaaa/mccfiles/condor_log/mainfile_confdata' num2str(i) otherindex '.err'];
fprintf(fp, '%s\n', err);
fprintf(fp, 'notification = Never \n');
queue = ['queue ' num2str(numjobs)];
fprintf(fp, '%s\n', queue);
fclose(fp);

end
