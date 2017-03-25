%%
% run('/Users/dorsimon/Desktop/machine learning project/Data Set/Deadlift/readingdeadlift.m');
% run('/Users/dorsimon/Desktop/machine learning project/Data Set/SP/readingsp.m');
% run('/Users/dorsimon/Desktop/machine learning project/Data Set/Squat/readingsquat.m');
% run('/Users/dorsimon/Desktop/machine learning project/Data Set/None/readingNone.m');

feature_size=49;

%% Dataset for ML
none_size=size(Nonedata,1);
squat_size=size(squatdata,1);
sp_size=size(spdata,1);
deadlift_size=size(deadliftdata,1);
dataset_size=none_size + squat_size + sp_size + deadlift_size;

dataset_ml=zeros(dataset_size,feature_size);

dataset_ml(1:squat_size,:)=squatdata;

dataset_ml(squat_size+1:squat_size+sp_size,:)=spdata;

dataset_ml(squat_size+sp_size+1:squat_size+sp_size+deadlift_size,:)=deadliftdata;

dataset_ml(squat_size+sp_size+deadlift_size+1:dataset_size,:)=Nonedata;

%% Dataset for DL
% dataset_dl_x=zeros(395,48);
% dataset_dl_x(1:98,1:48)=squatdata(1:98,1:48);
% dataset_dl_x(99:196,1:48)=spdata(1:98,1:48);
% dataset_dl_x(197:296,1:48)=deadliftdata(1:100,1:48);
% dataset_dl_x(297:395,1:48)=Nonedata(1:99,1:48);
% 
% %label deadlift=3
% %label press=2
% %label squat=1
% %label None=0
% 
% dataset_dl_y=zeros(395,4);
% dataset_dl_y(297:395,1)=1; %None
% dataset_dl_y(1:98,2)=1; %Squat
% dataset_dl_y(99:196,3)=1; %Press
% dataset_dl_y(197:296,4)=1; %Deadlift



