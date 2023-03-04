%
clear
clf
%load data from IDL calculation of 816 data
%file1='E:\RSI\MISC\Mei_index.txt';
%fid1=fopen(file1)
%L=fgetl(fid1)
%A=fscanf(fid1,'%f',[13,68]);
B=load('E:\airglow\5.5year\ENSO_MEI.txt');
A=B';
V=A(1,:);
MEI=A(2,:)
L=length(MEI)
%MMid=A(2:13,:);

%A=load('E:\airglow\5.5year\Qmei.txt');
format bank;
%Iyr=1951:2017;

figure (1)
plot(V,MEI,'k')
hold
a1=[1950,2020];
b1=[1,1];
b2=[-1,-1];
plot(a1,b1,'b');
plot(a1,b2,'b');
title('Mei index 1951-2017')

 
Y = fft(MEI);
Y(1)=[];

%A graph of the distribution of the Fourier coefficients (given by Y) in the complex plane is pretty, but difficult to %interpret. We need a more useful way of examining the data in Y.
figure (2)
plot(Y,'ro')
title('Fourier Coefficients in the Complex Plane');
xlabel('Real Axis');
ylabel('Imaginary Axis');

%The complex magnitude squared of Y is called the power, and a plot of power versus frequency is a "periodogram".

n=length(Y);
power = abs(Y(1:floor(n/2))).^2;
nyquist = 1/2;
freq = (1:n/2)/(n/2)*nyquist;
% also analyze data prior to year 2000
MEI_2000=MEI(1:600)
Y2= fft(MEI_2000);
Y2(1)=[];
n2=length(Y2);
power2 = abs(Y2(1:floor(n2/2))).^2;
nyquist = 1/2;
freq2 = (1:n2/2)/(n/2)*nyquist;


figure (3)
plot(freq,power)
xlabel('cycles/year')
title('Periodogram')

%The scale in cycles/year is somewhat inconvenient. We can plot in years/cycle and estimate the length of one cycle.
figure (4)
plot(freq ,power)
xlabel('cycles/year')

%Now we plot power versus period for convenience (where period=1./freq). As expected, there is a very prominent cycle with a %length of about 11 years.
figure (5)
subplot(2,1,1)
period=1./freq;
Yr=period/12;
plot(Yr,power);
ylabel('Power');
xlabel('Period (Years)');
title('MEI 1950-2018')
subplot(2,1,2)
period2=1./freq2;
Yr2=period2/12
plot(Yr2,power2);
ylabel('Power');
xlabel('Period (Years)');
title('MEI 1950-2000')
% Finally, we can fix the cycle length a little more precisely by picking out the strongest frequency. The red dot locates %this point.
figure (6)

hold on;
index=find(power==max(power));
mainPeriodStr=num2str(period(index));
plot(period(index),power(index),'r.', 'MarkerSize',25);
text(period(index)+2,power(index),['Period = ',mainPeriodStr]);
hold off;
%find peak years:
qmax=find(MEI > 1.0);
Ymax=V(qmax)