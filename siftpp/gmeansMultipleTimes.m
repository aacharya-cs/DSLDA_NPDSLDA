function [] = gmeansMultipleTimes (T, p, k)

%% T: number of iterations
%% p: fraction of data
%% k: number of clusters

for t=1:T
 QuantizeSIFT(p, k, t);
end

end


% ./gmeans /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_200_0.1_1 -a e -c 200 -O /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_results_200_0.1_1
% genclustercenters(0.1, 200, 1);
% gmeans_assign_clusters(200, 0.1, 1);

% ./gmeans /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_200_0.1_2 -a e -c 200 -i f /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/clusterseeds_200_0.1_1.txt -O /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_results_200_0.1_2
% genclustercenters(0.1, 200, 2);
% gmeans_assign_clusters(200, 0.1, 2);

% ./gmeans /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_200_0.1_3 -a e -c 200 -i f /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/clusterseeds_200_0.1_2.txt -O /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_results_200_0.1_3
% genclustercenters(0.1, 200, 3);
% gmeans_assign_clusters(200, 0.1, 3);

% ./gmeans /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_200_0.1_4 -a e -c 200 -i f /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/clusterseeds_200_0.1_3.txt -O /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_results_200_0.1_4
% genclustercenters(0.1, 200, 4);
% gmeans_assign_clusters(200, 0.1, 4);

% ./gmeans /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_200_0.1_5 -a e -c 200 -i f /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/clusterseeds_200_0.1_4.txt -O /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_results_200_0.1_5
%% done til here
% genclustercenters(0.1, 200, 5);
% gmeans_assign_clusters(200, 0.1, 5);


% ./gmeans /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_200_0.8_1 -a e -c 200 -O /lusr/u/ayan/MLDisk/LabelMeData/gmeans_files/LabelMe_results_200_0.8_1

