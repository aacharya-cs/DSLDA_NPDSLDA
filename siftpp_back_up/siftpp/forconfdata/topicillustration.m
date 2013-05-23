function = topicillustration()

tagList = load('tagList.mat');
vocabList = save('vocabList.mat');

A = load(modelfilename);
testmodelmedLDAova = A.testmodelmedLDAova;
testmodelmedLDA    = A.testmodelmedLDA;
testmodelLLDA      = A.testmodelLLDA;
testmodel          = A.testmodel;

class_topic_correlation(testmodelmedLDA, vocabList, tagList);
class_topic_correlation(testmodelLLDA, vocabList, tagList);
class_topic_correlation(testmodel, vocabList, tagList);

end
