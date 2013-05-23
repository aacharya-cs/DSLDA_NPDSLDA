function  [paths, countimg] = sampledataUIUC()

%%%% Data subsampling

nperclass = 10;
nimages = [194   198   137   235   181   250   189   190];


%% 1st: rockclimbing correct
%% 2nd: badminton .JPG
%% 3rd: bocce  correct
%% 4th: croquet .JPG
%% 5th: polo  .JPG
%% 6th: rowing correct

ind1 = ceil(nimages(1)*rand(nperclass,1)); 
ind2 = ceil(nimages(2)*rand(nperclass,1)); 
ind3 = ceil(nimages(3)*rand(nperclass,1)); 
ind4 = ceil(nimages(4)*rand(nperclass,1)); 
ind5 = ceil(nimages(5)*rand(nperclass,1)); 
ind6 = ceil(nimages(6)*rand(nperclass,1)); 
ind7 = ceil(nimages(7)*rand(nperclass,1)); 
ind8 = ceil(nimages(8)*rand(nperclass,1)); 

A = load('UIUCclasses.mat');
countimg = 1;
for i=1:nperclass
 paths{countimg} = A.class1{ind1(i)}; 
 countimg = countimg + 1;
end
for i=1:nperclass
 paths{countimg} = A.class2{ind2(i)}; 
 countimg = countimg + 1;
end
for i=1:nperclass
 paths{countimg} = A.class3{ind3(i)}; 
 countimg = countimg + 1;
end
for i=1:nperclass
 paths{countimg} = A.class4{ind4(i)}; 
 countimg = countimg + 1;
end
for i=1:nperclass
 paths{countimg} = A.class5{ind5(i)}; 
 countimg = countimg + 1;
end
for i=1:nperclass
 paths{countimg} = A.class6{ind6(i)}; 
 countimg = countimg + 1;
end
for i=1:nperclass
 paths{countimg} = A.class7{ind7(i)}; 
 countimg = countimg + 1;
end
for i=1:nperclass
 paths{countimg} = A.class8{ind8(i)}; 
 countimg = countimg + 1;
end


end
