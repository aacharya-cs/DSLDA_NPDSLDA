function [model] = select_labeled_data (model, data)

BatchData = SampleDataforBatchProcessing(data, 1000);

for i=1:length(BatchData)
    model = online_E_step(model, BatchData);
end

end
