%% First, run files to load training data
% try run('readingdeadlift.m');catch end
% try run('readingsp.m');catch end
% try run('readingsquat.m');catch end
% try run('readingNone.m');catch end
% try run('combiningdata.m');catch end

%% Live Testing

%initiating results
result=0;
squat_num=0;
press_num=0;
deadlift_num=0;

L_window=80;
Fs=30;
test=zeros(80,6);
test_features=zeros(1,48);
while true % 
    importdata('/Users/dorsimon/Desktop/machine learning project/New Data Set/Workout/Workout.txt');
    L_file=size(ans,1); % length of file 
    for i = 0:79
    test(80-i,1:6)=ans(L_file-i,1:6);
    end
    %test(:,:)=normc(test(:,:)); %normalizing
    test(:,:)=sgolayfilt(test(:,:),5,9); %smoothing with MA window

    for i = 1:6 % mean feature
        test_features(1,i)=mean(test(1:end,i)); 
    end
    
    for i = 1:6 % standart deviation feature
        test_features(1,i+6)=std(test(1:end,i)); 
    end
    
    for i = 1:6 % rms feature
        test_features(1,i+12:i+17)=rms(test);
    end
    
    for i = 1:6 % fft feature
        Y=fft(test(1:end,i));
        f = Fs*(0:(L_window/2))/L_window;
        P2 = abs(Y/L_window);
        try P1 = P2(1:L_window/2+1); catch end
        try P1(2:end-1) = 2*P1(2:end-1); catch end
        try pks= findpeaks(P1); catch end
        try test_features(1,i+18)=pks(1,1); catch end %j-3 because j starts from 4, and taking 2 first peaks
        % test_features(1,i+19)=pks(2,1);
    end
    
    for i = 1:6 % pwelch feature
        col=test(:,i);
        try pxx=pwelch(col); catch end % because need at least length of 8 to do pwelch
        try pks= findpeaks(pxx); catch end
        try test_features(1,i+24)=pks(1,1); catch end %j-3 because j starts from 4, and taking 2 first peaks
    end
    
    for i = 1:6 % kurtosis feature
        test_features(1,i+30)=kurtosis(test(1:end,i)); %j-3 because j starts from 4, i+1 because of timestamp in first column
    end
    
    for i = 1:6 % autocorrlation feature, count number of lags bigger than upper bound
        [acf,lags,bounds]=autocorr(test(1:end,i));
        count=sum(acf>bounds(1));
        test_features(1,i+36)=count; %j-3 because j starts from 4, i+1 because of timestamp in first column
    end
    
    for i = 1:6 % varience feature
        test_features(1,i+42)=var(test(1:end,i)); %j-3 because j starts from 4, i+1 because of timestamp in first column
    end

    result=trainedClassifier.predictFcn(test_features);
    test_features % printing test_features to check they are indeed
    % changeing
switch result
    case 1
        squat_num=squat_num+1;
        disp('squat')
    case 2
        press_num=press_num+1;
        disp('shoulder press')
    case 3
        deadlift_num=deadlift_num+1;
        disp('deadlift')
    otherwise
        disp('resting')
end
    result_vector=[result,squat_num,press_num,deadlift_num];
    csvwrite('results.csv',result_vector);
    pause(2.5);
end




