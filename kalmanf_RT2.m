%adapted and modified from "Learning the Kalman Filter" http://www.mathworks.com/matlabcentral/fileexchange/5377-learning-the-kalman-filter
% T.csv is cleaned version of data downloaded from NYISO, cleaning script
% at bottom of this file
% Column 7 is Hour-Ahead data, Column 8 is Real-Time data

clear s
m.A = 1;
% Settings for Hour-Ahead vs Real-Time data shown in presentation
a=4*24*10+2;
b=a+50;
C = [T((a-(b-a)):(b-(b-a)),7),T((a-(b-a)):(b-(b-a)),8)];
corr_R = corrcoef(C(2:end,:));
corr_R2 = corr_R(1,2);
% No initial state:
m.x= nan;
m.P = nan;
% Process Noise
m.Q = corr_R2/2;
m.H = 1;
% Measurement error 
m.R = corr_R2;
% No control/input functions:
m.B = 0;
m.w = 0;
% Run Kalman Filter.
for t=a:b
   m(end).z = T(t,7); % Hour-Ahead
   m(end+1)=kalmanf(m(end)); % Kalman Filiter
end
%Plot comparisons
figure
hold on
grid on
pz=plot([m(1:end-1).z],'g--o');
pk=plot([m(2:end).x],'b-');
pt=plot(T(a:b,8),'k-');
legend([pz pk pt],'observations','Kalman output','Real Time', 0)
title('Hour Ahead vs Real Time')
xlabel('15 Minute Intervals')
ylabel('LBMP')
hold off

%Find correlations
i = [[m(1:end-1).z]',T(a:b,8)];
j = [[m(2:end).x]',T(a:b,8)];
corr_O = corrcoef(i(2:end,:));
corr_O %hour-ahead correlation
corr_K = corrcoef(j(2:end,:));
corr_K %kalman filtered hour-ahead correlation


% Clean and organize NYISO data
% Match Real-time with hour-ahead
T_ = zeros(length(HR),8);
HR_2=[datevec(HR(:,1)),HR(:,2)];
RT_2=[datevec(RT(:,1)),RT(:,2)];
for t=1:length(HR_2)
    k=HR_2(t,1:6);
    l=k;
    l(1,4)=k(1,4);
    j=datenum(l);
    a = find(RT == j);
        if isempty(a)
            T(t,:)=[];
            continue
        end
        T(t,1:6)=k;
    T(t,7)=HR_2(t,7);
    T(t,8)= RT(a(1,1),2);
end
return