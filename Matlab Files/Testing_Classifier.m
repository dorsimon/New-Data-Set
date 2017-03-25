% %% First, run files to load training data
% try run('readingdeadlift.m');catch end
% try run('readingsp.m');catch end
% try run('readingsquat.m');catch end
% try run('readingNone.m');catch end
% try run('combiningdata.m');catch end

%% Testing trained classifier
data_size=size(dataset);
data_size=data_size(1,1);
random=randi([1,data_size]) % taking a random row from dataset
true_result=dataset(random,31) % this is the true result
test=dataset(random,1:30); % test contains the extracted features, without the predicted class
trainedClassifier.predictFcn(test)

