function [R, Ba, H]=ra_ratio(sgn,HRES,z1_km,z2_km,Sa,R1,wavl)
% program to calculate backscattering ratio
%  function [R, B, H]=ba_ratio(sgn,z1_km,z2_km,st,ed,Sa,binnum)
%  Backscattering ratio of air to standard atmosphere 

%  by Wei-Nai Chen, Revision: 0.1a $ $Date: 2015/08/12
%
  
binnum=length(sgn);
HRESm=HRES*1000;

Sr=8*pi/3;	%Sr=Gr/Br=8*pi/3  (Refer to the document)

z1_km_bin=ceil(z1_km/HRES)+1;
z2_km_bin=floor(z2_km/HRES);
z1_km=z1_km_bin*HRES;
z2_km=z2_km_bin*HRES;

L=z2_km_bin - z1_km_bin + 1;
if length(Sa)==1
  Sa=ones(1,length(sgn))*Sa;
end

Sa=Sa(z1_km_bin:z2_km_bin);
H=(z1_km_bin:z2_km_bin)*HRES;

load den
den=interp1((1:1291)*24,den,(1:length(sgn))*HRESm);
%den=den15; % 15 m height interval
if ~exist('wavl')
  wavl=532;
end

Br1=den2ba(den,wavl)*1e9;

N=den(z1_km_bin:fix((z2_km+1)/HRES)); %N, number density of air
Br=Br1(z1_km_bin:fix((z2_km+1)/HRES))/1e3;
 %'Br'(Rayleigh backscattering coefficient) artificial 
 %made in order to later calculation ,and the relation 
 %between 'Br' 'ref' & 'N' can be found from document. 		 
 %where Br:1/m-sr

CSr=(8/3)*pi*(Br./N)*10^4;
 %CSr is the total Rayleigh backscattering cross 
 %section in cm2.

kr=(8/3)*pi*Br/100;
%kr is the extinction coefficient of the atmosphere, where kr:1/cm
%----------------------------Integral calculation
X=1:L;	 % X is integral result of Br 			 
X(L)=0;
for j=L-1:-1:1
  X(j)=X(j+1)-HRESm/2*((Sa(j+1)-Sr)*Br(j+1)+(Sa(j)-Sr)*Br(j));
end

T=exp(-2*X);
%T=exp(-2*(Sa-Sr)*X);

%-------------------------------------------------------------------
% Main Calculate (Please understanding the equation first)

%P=sgn(z1_km_bin:z2_km_bin+11);%原本
P=sgn(z1_km_bin:z2_km_bin);



%---------------------Calculate the equation------------------------
%W=P(1:L).*(((1000*H).^2).*T);%原本
W=(P(1:L))'.*(((1000*H).^2).*T); %'W' is the numerator of the eq.
%--------------------------------------Integral calculation
DE1=1:L;	 %'DE1' is first part of denominator of the eq.
DE1(L)=0;
for j=L-1:-1:1
   DE1(j)=DE1(j+1)-(HRESm/2)*2*(Sa(j+1)*W(j+1)+Sa(j)*W(j));
end

%------------------------------------------------------------------
enP1=L-1-1; enP2=L-1+1;
%enL=(z2_km*1000-HRESm*1):HRESm:(z2_km*1000+HRESm*1);
%DE2=mean(P(enP1:enP2).*(enL.^2))/mean(Br(enP1:enP2));
enL=(z2_km*1000);
DE2=P(L).*(enL.^2)/(Br(L));
%DE2=mean(W((L-50):L))/mean(Br((L-50):L));
B=W./(DE2/R1-DE1);	 % This is the final calculation of th eq.
                 % B=Ba+Br---the total backscatterring
R=B./Br(1:L);
R=R+R1-R(end);% R is the "Backscattering RATIO"
Ba=(R-1).*Br(1:L); % where Ba: 1/m-sr
