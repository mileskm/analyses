function b = analyse_pupil2(input_filename,trial_size,ID,ii)
% This function averages pupil data trials according to user defined conditions.
%
% The code is run by :
% output = analyse_pupil('input_filename',trial_length,trial_ID)
%
% where input_filename has to be a '.mat' file
% the trial_length is in samples (and NOT in seconds)
% the trial_ID is defined by including the TTL_ID between square brackets, 
% each separated by space  
%
% e.g
% p = analyse_pupil('temp.mat',6001,[101 102 103 104 105]);
%
% This code will generate three files:
% 1. An .xls file which contain the average of the accepted interpolated trials
% 2. An .xls file which contain the average of the accepted non-interpolated trials
% 3. An .txt file which contain the number of accepted and rejected trials

% INFO ::: data input structure MUST be in the following format:
% data_structure consisted of 7 cols:
% 1: Subject No
% 2: Time Stamp
% 3: Pupil Diameter
% 4: Trial No
% 5: TTL
% 6: Right Blink/Saccade
% 7: Right Blink/Saccade


s = load(input_filename);
oooo = cat(2,'s.',input_filename(1:end-4));

%initialisation
test_orig = eval(oooo);
trialNO_col = 4;
TTL = 5;
data_col = 3;
test = test_orig;
for y = 1:length(ID),
    accept{y} = [];
    reject{y} = [];
end
accept1 = [];
reject1 = [];
trial_indicator = [];
% do the following for the no. of trials
for trials = 1:test(end,trialNO_col),
    i = find(test(:,trialNO_col)==trials); % get the trial that will be analysed 
    me = mean(test(i,data_col)); % Find the mean of the current trial
    stdev = std(test(i,data_col)); % Find the standard deviation of the current trial
    i1 = find(test(i,data_col)< (me - 3*stdev)); % find the points in the trial that is less that 3std
    i2 = find(test(i,data_col)==0);
    
    i_tot = [i1+i(1)-1];% i2+i(1)-1];
    
    %debugging code : trying to identify the length of the zero values
%     length(i_tot)
%     length(i2)
%     length(i)
    
    test(i_tot,data_col) = 0; %set to zero all the trials that deviates from 3 std from the mean
    if 0.15*length(i)>(length(i_tot)+length(i2)), %Check trial - whether we accept of reject
        trial_indicator = [trial_indicator; 1];
        accept1 = [accept1 trials];
        for y = 1:length(ID),
            if test(i(1),TTL) == ID(y)
                accept{y} = [accept{y} trials];
            end
        end
    else
        trial_indicator = [trial_indicator; 0];
        reject1 = [reject1 trials];
        for y = 1:length(ID),
            if test(i(1),TTL) == ID(y)
                reject{y} = [reject{y} trials];
            end
        end
    end
end

reject1
% figure(1) % plotting the cont data before and after the nullifying process
% plot(test_orig(:,data_col),'r');hold on
% plot(test(:,data_col),'g');
% hold off;

%%%%%%%%%%%%%%%%%%%%%
%Interpolation Code %
%%%%%%%%%%%%%%%%%%%%%

t = test(:,data_col); % get the nullified data
t1 = t;
%Finding the zero points
i = find(t==0);
samp1 = 66; % reference to the 66 pts behind the zeros
samp2 = 132; % reference to the 132 pts after the zeros


t_2 = [flipud(t(1:samp1-1)); t; flipud(t(end - samp2+1:end))];

% Trying to find the length of the zero points 
a1 = [i; 0];
a2 = [0; i];
ind = find((a1-a2)~=1);

% trying to see whether the zeros start and end points are even as
% otherwise process only up the last matching start and end points
a = mod(length(ind),2);


for tau = 1:length(ind)-1-a, %loop for the number of matched start and end points
    %filling the points -66 : 00000 : 132 with the interpolated line ->
    %using equation y-y0 = m(x-x1)
    t_2(a1(ind(tau))-samp1+samp1-1:a1(ind(tau+1)-1)+samp2+samp1-1) = (t_2(a1(ind(tau+1)-1)+samp2+samp1-1)-t_2(a1(ind(tau))-samp1+samp1-1))/(i(ind(tau+1)-1)+samp2+samp1-1-(i(ind(tau))-samp1+samp1-1))*((i(ind(tau))-samp1+samp1-1:i(ind(tau+1)-1)+samp2+samp1-1)-(i(ind(tau))-samp1+samp1-1))+t_2(i(ind(tau))-samp1+samp1-1);
end
t1 = t_2(samp1:end-samp2);
ty = t1;
if ii == 1,
    samp1t = 166; % reference to the 66 pts behind the zeros
    samp2t = 232; % reference to the 132 pts after the zeros
    tt = ty;
    for trials = 1:test(end,trialNO_col),
        i = find(test(:,trialNO_col)==trials); % get the trial that will be analysed
        me = mean(tt(i)); % Find the mean of the current trial
        stdev = std(tt(i)); % Find the standard deviation of the current trial
        i1t = find(tt(i)< (me - 3*stdev)); % find the points in the trial that is less that 3std
        i2t = find(tt(i)==0);
        
        i_tott = [i1t+i(1)-1];% i2+i(1)-1];
        
        %debugging code : trying to identify the length of the zero values
        %     length(i_tot)
        %     length(i2)
        %     length(i)
        
        tt(i_tott) = 0; %set to zero all the trials that deviates from 3 std from the mean
    end
    it = find(tt==0);
    a1t = [it; 0];
    a2t = [0; it];
    indt = find((a1t-a2t)~=1);
    at = mod(length(ind),2);
    
    t_2t = [flipud(tt(1:samp1t-1)); tt; flipud(tt(end - samp2t+1:end))];
    for tau = 1:length(indt)-1-at, %loop for the number of matched start and end points
        %filling the points -66 : 00000 : 132 with the interpolated line ->
        %using equation y-y0 = m(x-x1)
        t_2t(a1t(indt(tau))-samp1t+samp1t-1:a1t(indt(tau+1)-1)+samp2t+samp1t-1) = (t_2t(a1t(indt(tau+1)-1)+samp2t+samp1t-1)-t_2t(a1t(indt(tau))-samp1t+samp1t-1))/(it(indt(tau+1)-1)+samp2t+samp1t-1-(it(indt(tau))-samp1t+samp1t-1))*((it(indt(tau))-samp1t+samp1t-1:it(indt(tau+1)-1)+samp2t+samp1t-1)-(it(indt(tau))-samp1t+samp1t-1))+t_2t(it(indt(tau))-samp1t+samp1t-1);
    end
    t1 = t_2t(samp1t:end-samp2t);
end

figure(5)
plot(tt,'b');hold on;
plot(ty,'r');
plot(t1,'g');hold off;
legend('nulled','interp_passed1','interp_passed2');

% %Uncomments below if you need to plot before and after the linear
% %interpolations

figure(2) % Compare the between the interpolated cont data and the nullified data
plot(t);hold on;
plot(t1,'r')
hold off;

%%%%%%%%%%%%%%
% Smoothing
%%%%%%%%%%%%%%

S = 83; % setting the number of smoothing points
smoo = ones(1,S);
% performing edge correction
t2 = [flipud(t1(end-floor(S/2)+1:end)); t1;  flipud(t1(1:floor(S/2)))];

t3 = conv(t2,smoo/S,'same');
res = t3(floor(S/2)+1:end - floor(S/2));

figure(4) %Plotting between the smoothed interp and non-smoothed interp cont. data
plot(t1,'r');hold on
plot(res);hold off


%%%%%%%%%%%%%%%%%%%'
% CODE for extracting the parameters
%%%%%%%%%%%%%%%%%%%'

% Col No.
% 1 Mean value of Baseline 0-1 s
% 2 Mean value Baseline 1-2 s
% 3. Maximum Amplitude
% 4. Maximum Latency
% 5. Trial Indicator (whether accept == 1 or reject == 0)
% 6. Trial Mean Value
% 7. Trial codes
% 8. Gradient from baseline 1
% 9. Gradient from baseline 2


param_stor = [];
codeID = [];
for trials= 1:test(end,trialNO_col),
    i = find(test(:,trialNO_col)==trials); % get the trial that will be analysed 
    param_stor = [param_stor res(i)]; 
    codeID = [codeID; test(i(1),5)];
end

base1 = 1:1000;
base2 = 1001:2000;
base3 = 2001:6001;

[ymax,imax] = max(param_stor(base3',:),[],1);

temp = [mean(param_stor(base1',:),1)' mean(param_stor(base2',:),1)' ymax' imax' trial_indicator codeID mean(param_stor(base3',:),1)' (ymax'-mean(param_stor(base1',:),1)')./(imax'-500) (ymax'-mean(param_stor(base2',:),1)')./(imax'-1500)];

save TRIAL_fileDONE param_stor;
xlswrite('outputpar_DONE.xls',temp);

a='OK';