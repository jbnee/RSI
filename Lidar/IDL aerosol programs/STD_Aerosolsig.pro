
Pro STD_Aerosolsig
close,/all
path='d:\Lidar systems\Depolar\2002\mr\'
 file = 'Mr080015.'; AP022014.'; jn022058.';  'mr312023.';202312.';192330.'; 192028.';190111.'; 182309.';  ap022014.' ;
 file_basename=path+file
 read,ni,nf, prompt='Initial and file number as 1,99: '
  nx=nf-ni+1  ;num of files to treat
  N5=round(nx/5)  ; we average 5 files
  T=findgen(1000)
  pr2m=fltarr(nx,1000)

  sig1=fltarr(nx,1000)
  ht1=3.0E8*160.E-9*T/2./1000.   ;convert ht to km

   sn=strtrim(fix(ni),1)
   fn0=file_basename+strtrim(sn,1)+'M'
   datab0=read_binary(fn0,DATA_TYPE=2)
   sig=datab0[0:999]
  sig1[0,*]=smooth(sig,10)
  pka=fltarr(2,Nx)
  pkb=fltarr(2,N5)

  pr2m[0,*]=sig1[0,*]*ht1*ht1
  maxs=max(pr2m[0,0:200])  ;max signal below 5 km
  b=maxs/nx
   !P.MULTI = [0, 1, 2]
  plot_position=[0.1,0.15,0.95,0.45]
  plot,pr2m[0,*],ht1,background=-2,color=2,yrange=[1,5],xrange=[0,maxs],position=Plot_position,$
  xtitle='Signal/channel',ytitle='km'

  j=1

 FOR nm=ni+1,nf do begin

   sn=strtrim(fix(nm),2)
  ;ln=strlen(sn)

   fn=file_basename+strtrim(sn,2)+'M'

   datab=read_binary(fn,DATA_TYPE=2)
   sig =datab[0:999]
   sig1=smooth(sig,10)
   pr2m[j,*]=sig1*ht1^2
   pks=max(pr2m[j,*])
   pkht=where(pr2m[j,*] eq pks)
   pka[*,J]=[pks,pkht]
   oplot,pr2m[j,*]+j*b,ht1,color=2;
  ;xyouts,max(sig1)/2,max(ht1)/2,nm,color=4,charsize=2
 ;wait,1
 j=j+1
 endfor
 ;xyouts,max(sig1)/2,max(ht1)/2,fn,color=4,charsize=1
 stop
;;;;;;calculate standard deviation
 ;read,N,prompt='Total number of data: such as 200:'
 ;N5=round(nx/5)  ; we average 5 files
 AVSIG=FLTARR(N5,1000)
 STDS=fltarr(N5,1000)
 X=fiNdgen(N5)

plot_position2=[0.1,0.6,0.95,0.95]
j2=0
FOR i=0 , nx-5, 5 do begin
For iy=0,999 do begin
AVSig[J2,iy]=MEAN(pr2m[i:i+4,iy])
STDS[J2,iy]=STDDEV(pr2m[i:i+4,iy])
endfor
pk2=max(STDS[J2,*])
pkht2=where(STDS[j2,*] eq pk2)
pkb[*,J2]=[pk2,pkht2]
maxs2=max(STDS[0,0:200])
j2=j2+1

endfor

plot,STDS[0,*],ht1,background=-2,color=2,xrange=[0,maxs2],yrange=[1,5],$
 position=Plot_position2,xtitle='St Dev of PR2',ytitle='km';

stop
FOR m=1,N5-1 do begin
oplot,STDS[m,*]+b*m,ht1,color=4
endfor
stop
; write_bmp,"d:\lidar systems\Depolar\2002\MR072150_1_80.bmp",tvrd()
 end

