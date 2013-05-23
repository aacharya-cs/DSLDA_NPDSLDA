function [] = prepconfdata(maxtags)

fullpath1 = '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/confdatamat/ndtag/';
fullpath2 = '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/confdatamat/abstract/';
fullpath3 = '/lusr/u/ayan/Documents/ONRATLCODE/mccfiles/savedfiles/Ayans/confdatamat/tagdistribution/';

%% maxtags;  %% maximum number of tags allowed

confname = {'cikm', 'dac', 'glsvlsi', 'icml', 'ISPD', 'kdd', 'sigir', 'spaa', 'www'};
forbiddentags = {'algorithm', 'perform', 'design', 'experiment'}; %% tags that are common across conferences and should not be allowed

readtagandabstract(forbiddentags, fullpath1, fullpath2, fullpath3, maxtags, confname);

end

