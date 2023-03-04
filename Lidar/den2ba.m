function ba=den2ba(den,wl)
%這一部分計算空氣(Rayleigh scattering) backscattering coeff beta based on last eq
%in this program
%Br=Br1(z1_km_bin:fix((z2_km+1)/0.024))/1e3;
%'Br'(Rayleigh backscattering coefficient) artificial 
%made in order to later calculation ,and the relation 
%between 'Br' 'ref' & 'N' can be found from document.
% den:1/m^3; 
%where Br:1/m-sr

if ~exist('wl')
    wl=532;
end
ba=den*5.45*(550/wl)^4*1e-32;  
