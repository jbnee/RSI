clear
clf
clc
%load('e:\Matlab\FFT\sunspot2011.txt');
%Path1='E:\radiosonde\Taal\'
Path1='E:\Matlab\Taal_GW\';
F1='ANMT_0101.txt';
F2='ANMT_0201.txt'
F3='ANMT_0208.txt'
%F1='98433_Jan01z12_2020.txt';
%F2='98433_Feb01z12_2020.txt'
%F3='98433_Feb08z12_2020.txt';
file1=strcat(Path1,F1)
file2=strcat(Path1,F2)
file3=strcat(Path1,F3) 
date1='0201' ; %strcat(filex,31,4);'0208'; strmid(filex,24,4);
date2='0101';
date3='0208';
%%%%%%*********** Feb01 *********************
A1=load(file1);

km1=A1(:,1);
b1=min(find(km1 > 3.0));  %km>3000 m 13
b2=min(find(km1 >9.0));  %km<8000 mb  29
km1=km1(b1:b2);
Tanm1=A1(b1:b2,2);
 

%[Power1,freq1]=plomb(T11,km1);
% Period1=1./freq1;
figure (1)
plot(Tanm1,km1,'x')
hold
%plot(q1,km1)
 
[Power1,freq1]=plomb(Tanm1,km1);
 Period1=1./freq1;
 figure (2)
 plot(Period1,Power1)
 title(F1)
%**************************Feb1  *********************** 
A2=load(file2); %readmatrix(file2);
km2=A2(:,1);
%b21=8;  b22=36;
b21=min(find(km2 > 3.0));  %km>3000 m 13
b22=min(find(km2 >9.0));
km2=km2(b21:b22);
Tanm2=A2(b21:b22,2);
 
%[Power2,freq2]=plomb(T2,km2);
%Period2=1./freq2;
figure (3)
%plot(Tanm2,km2,'-x')
 hold
 %Tanm2=Tanm2-q2;
[Power2,freq2]=plomb(Tanm2,km2);
 Period2=1./freq2;
 plot(Period2,Power2);
 figure (4)
 hold
 plot(Period2,Power2)
 title(F2)
 %Interpolation of data 2 using q1
  
%T22=Tanm2-q12;
 
%****************Feb 08 **************************
A3=load(file3); %readmatrix(file3);
 %b13=16; b23=56;
km3=A3(:,1);
 b31=min(find(km3 > 3.0));  %km>3000 m 13
b32=min(find(km3 >9.0));
km3=km3(b31:b32);
Tanm3=A3(b31:b32,2);
%p3=polyfit(km3,T3,3);
%q3=polyval(p3,km3);
%[Power3,freq3]=plomb(T3,km3);
% Period3=1./freq3;

  
[Power3,freq3]=plomb(Tanm3,km3);
 Period3=1./freq3;
 figure (5)
 plot(Period3,Power3);
title(F3)
 figure (6)

hold
plot(Period1,Power1,'g');
plot(Period2,Power2,'r');
plot(Period3,Power3);
%plot(Period22,Po22)
 xlabel('Period (km)');
ylabel('Power')
title('Lomb Scargle spectra')