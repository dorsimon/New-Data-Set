%%
Files = dir('/Users/dorsimon/Desktop/machine learning project/New Data Set/Deadlift/Samples/'); 
numfiles = length(Files); 
deadliftdata = zeros(numfiles-3,49); % -4 because of other files in directory (.,..,dbstore,this file and it's temp)
deadliftdata(1:end,49)=3; %label deadlift=3
Fs=30; % 30 Hz smaple rate
T=1/Fs;
avg_length=0;
    
for j = 4:numfiles  % started from 4 because Files contain garbage 1:3
    file=Files(j,1);
    importdata(file.name);
    L=size(ans,1); % length of file (for fft)
    avg_length=avg_length+L;
    t = (0:L-1)*T;      % Time vector
    %ans(1:end,2:7)=normc(ans); %normalizing
    ans(1:end,1:6) = sgolayfilt(ans(1:end,1:6), 5, 9); %filtering / smoothing
    
    for i = 1:6 % mean feature
        deadliftdata(j-3,i)=mean(ans(1:end,i)); %j-3 because j starts from 4, i+1 because of timestamp in first column
    end
    
    for i = 1:6 % standart deviation feature
        deadliftdata(j-3,i+6)=std(ans(1:end,i)); %j-3 because j starts from 4, i+1 because of timestamp in first column
    end
    
     for i = 1:6 % rms feature
        deadliftdata(j-3,i+12:i+17)=rms(ans); %j-3 because j starts from 4, i+1 because of timestamp in first column
    end
    
    for i = 1:6 % fft feature
        Y=fft(ans(1:end,i)); %j-3 because j starts from 4, i+1 because of timestamp in first column
        f = Fs*(0:(L/2))/L;
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        try pks= findpeaks(P1); catch end
        try deadliftdata(j-3,i+18)=pks(1,1); catch end %j-3 because j starts from 4, and taking 2 first peaks
        %spdata(j-3,i+19)=pks(2,1);
    end
    
    for i = 1:6 % pwelch feature
        col=ans(:,i); %j-3 because j starts from 4, i+1 because of timestamp in first column
        try pxx=pwelch(col); catch end % because need at least length of 8 to do pwelch
        
        try pks= findpeaks(pxx); catch end
        try deadliftdata(j-3,i+24)=pks(1,1); catch end %j-3 because j starts from 4, and taking 2 first peaks
        %deadliftdata(j-3,i+19)=pks(2,1);
    end
    
    for i = 1:6 % kurtosis feature
        deadliftdata(j-3,i+30)=kurtosis(ans(1:end,i)); %j-3 because j starts from 4, i+1 because of timestamp in first column
    end
    
    for i = 1:6 % autocorrlation feature, count number of lags bigger than upper bound
        [acf,lags,bounds]=autocorr(ans(1:end,i));
        count=sum(acf>bounds(1));
        deadliftdata(j-3,i+36)=count; %j-3 because j starts from 4, i+1 because of timestamp in first column
    end
    
    for i = 1:6 % varience feature
        deadliftdata(j-3,i+42)=var(ans(1:end,i)); %j-3 because j starts from 4, i+1 because of timestamp in first column
    end
    
end
avg_length=avg_length/(numfiles-4);   

%%
