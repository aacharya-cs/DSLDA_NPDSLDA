function [] = collecttags(fullpath)

addpath(fullpath);
tags = [];
tags = readtags('cikm_tagdistribution.txt');
save('cikm_tags.mat','tags');

tags = [];
tags = readtags('dac_tagdistribution.txt');
save('dac_tags.mat','tags');

tags = [];
tags = readtags('glsvlsi_tagdistribution.txt');
save('glsvlsi_tags.mat','tags');

tags = [];
tags = readtags('icml_tagdistribution.txt');
save('icml_tags.mat','tags');

tags = [];
tags = readtags('kdd_tagdistribution.txt');
save('kdd_tags.mat','tags');

tags = [];
tags = readtags('sigir_tagdistribution.txt');
save('sigir_tags.mat','tags');

tags = [];
tags = readtags('www_tagdistribution.txt');
save('www_tags.mat','tags');


end
