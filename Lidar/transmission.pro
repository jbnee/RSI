function Transmission,dz0,z0
 ; dz0=0.024,z0=24 in km
 ;
  Sr=8*!pi/3; lidar ratio for air
  bin=z0/dz0;
  tao=fltarr(bin)
   Trm=fltarr(bin)
   kextinc=fltarr(bin)
   beta_r=Rayleigh_beta(160,bin)

   kextinc=Sr*beta_r   ;Rayleigh extinction
   tao[bin-1]=kextinc[bin-1]*dz0*1000
 for j=bin-2,1,-1 do begin
    tao[j]=(kextinc[j]+kextinc[j-1])*dz0*1000/2+tao[j+1]
    Trm[j]=exp(-2*tao[j])
endfor
Trm[0]=Trm[1]
Trm[bin-1]=Trm[bin-2]
Return,Trm

end