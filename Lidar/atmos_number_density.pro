Pro atmos_number_density
;P in Pa =101300 Pa ground level
;T in K
;km=findgen(100)
 read,P,T,Prompt= 'P,T in Pa, K= '
k=1.38e-23
 N=  P/(T*k)
 print,'P,T,N=  ',P,T,N
 ;1.E25*(2.4498-0.22114*km+0.00701*km^2-7.75225E-5*km^3)  ;ht in km; density in molec/m3
 end