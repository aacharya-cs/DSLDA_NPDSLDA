function BatchDataIndex = SampleDataforBatchProcessing(N, K, sz)

for i=1:sz
    
 BatchDataIndex{i} = randsample(N,K);
end

end