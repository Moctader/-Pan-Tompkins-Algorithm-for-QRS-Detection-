%% 1
ECG=load('ECG.txt');
fs=200;
time=1/fs;
ECG_1=ECG-ECG(1)
time_1=linspace(0,length(ECG_1)/fs,length(ECG_1))
fig=figure(1)
subplot(6,1,1)

plot(time_1,ECG_1);

%% 2
%low_pass_filter=lowpass(ECG_1,11,200);
%subplot(6,1,2);
%plot(time_1(1:200),low_pass_filter(1:200));

b_l=(1/32)*[1 0 0 0 0 0 -2 0 0 0 0 0 1]
a_l=[1 -2 1]
low_pass_filtered_signal=filter(b_l,a_l,ECG_1);
subplot(6,1,2);
plot(time_1,low_pass_filtered_signal);
ylabel('lowpass')


%% 3
%High_pass_filter=highpass(low_pass_filter,5,200);
b_h=[-1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 -32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
a_h=[1 -1]*32
High_pass_filtered_signal=filter(b_h,a_h,low_pass_filtered_signal)
subplot(6,1,3);
plot(time_1,High_pass_filtered_signal);
ylabel('bandpass')


%% 4 derivative filter
b_deri=(1/8)*[1 2 0 -2 -1]
a_der=[1]
Derivative_filtered_signal=filter(b_deri,a_der,High_pass_filtered_signal)
subplot(6,1,4);
plot(time_1,Derivative_filtered_signal);
ylabel('deivative')

%% squaring
squared_signal=Derivative_filtered_signal.^2;
b_in=1/30*ones(1,30);
a_in=[1];
integrated_signal=filter(b_in,a_in,squared_signal)
subplot(6,1,5)
plot(time_1,integrated_signal);
ylabel('integration')

%% ecg
subplot(6,1,6)
ECG_1=ECG-ECG(1)
plot(time_1,ECG_1);
%% Next step
[QRSStart, QRSEnd] = findQRS(integrated_signal,50,409,2612);
subplot(6,1,5)
hold on
plot(time_1(QRSStart),integrated_signal(QRSStart),'r*');
hold on
plot(time_1(QRSEnd),integrated_signal(QRSEnd),'ro');

subplot(6,1,6)
hold on
plot(time_1(QRSStart-21),ECG_1(QRSStart-21),'r*');
hold on
plot(time_1(QRSEnd-21),ECG_1(QRSEnd-21),'ro');




