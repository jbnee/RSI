%
clear
clf
 
%file1='E:\RSI\MISC\Mei_index.txt';
%fid1=fopen(file1)
%L=fgetl(fid1)
%A=fscanf(fid1,'%f',[13,68]);
A=load('E:\airglow\5.5year\ENSO_ 
yr=A(1,:);
%MMid=A(2:13,:);
 
n0=12*68
 
 
for y=1:68 ;
I=y-1;
A_MMID(I*12+1:I*12+12)=A(2:13,y);

end

%A=load('E:\airglow\5.5year\Qmei.txt');
format bank;
%Iyr=1951:2017;
b=[(1:9)/10,(10:12)/100];
k=1
for I=1950:2017;
    V(k:k+11)=I+b;
    k=k+12;
    end

figure (1)
plot(V,A_MMID)
title('Mei index 1950-2017')
pause
 
Y = fft(A_MMID);
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
period=1./freq;

plot(period,power);
ylabel('Power');
xlabel('Period (Years/Cycle)');

% Finally, we can fix the cycle length a little more precisely by picking out the strongest frequency. The red dot locates %this point.

hold on;
index=find(power==max(power));
mainPeriodStr=num2str(period(index));
plot(period(index),power(index),'r.', 'MarkerSize',25);
text(period(index)+2,power(index),['Period = ',mainPeriodStr]);
hold off;