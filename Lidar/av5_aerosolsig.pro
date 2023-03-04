Pro AV5_Aerosolsig
close,/all
 !P.MULTI = [0, 1, 2]
 plot_position1=[0.1,0.15,0.95,0.45]
  plot_position2=[0.1,0.6,0.95,0.95]
 read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')
 dnm=''
 month=''
  read,dnm,prompt='data filename as mr022018'
  month=strmid(dnm,0,2)

 bpath='F:\Lidar_data\';   systems\depolar\'
 fpath=bpath+yr+'\'+month+'\'

 fnm=fpath+dnm+'.'
 read,zkm,prompt='top height km:  '
 z=zkm*1000.
 bin_z=round(z/24.)

 read,ni,nf, prompt='Initial and file number as 1,99: '
  nx=nf-ni+1  ;num of files to treat

  T=findgen(1000)
  pr2m=fltarr(nx,1000)

  sig1=fltarr(nx,1000)
  ht1=3.0E8*160.E-9*T/2./1000.   ;convert ht to km

   sn=strtrim(fix(ni),1)
   fn0=fnm+strtrim(sn,1)+'M'
   datab0=read_binary(fn0,DATA_TYPE=2)
  sig1[0,*]=datab0[0:999]
  pr2m[0,*]=smooth(sig1[0,*]*ht1*ht1,10)

  plot,pr2m[0,*],ht1,background=-2,color=2,yrange=[0,zkm],xrange=[0,3000],position=Plot_position1,$
  xtitle='Signal/channel',ytitle='km',title='PR2_M'

  j=1

 FOR nm=ni+1,nf do begin

   sn=strtrim(fix(nm),2)
  ;ln=strlen(sn)

   fn=fnm+strtrim(sn,2)+'M'

   datab=read_binary(fn,DATA_TYPE=2)
   sig1=datab[0:999]

   pr2m[j,*]=smooth(sig1*ht1^2,10)

   oplot,pr2m[j,*]+j*50,ht1,color=2;
  ;xyouts,max(sig1)/2,max(ht1)/2,nm,color=4,charsize=2
  ;wait,1
   j=j+1
 endfor
 ;xyouts,max(sig1)/2,max(ht1)/2,fn,color=4,charsize=1
 stop
;;;;;;calculate standard deviation
 ;read,N,prompt='Total number of data: such as 200:'
 N5=round(nx/5)  ; we average 5 files
 AVSIG=FLTARR(N5,1000)
 ;STDS=fltarr(N5,1000)
 X=fiNdgen(N5)


j2=0
FOR i=0 , nx-5, 5 do begin
For iy=0,999 do begin
AVSig[J2,iy]=MEAN(pr2m[i:i+4,iy])
;STDS[J2,iy]=STDDEV(pr2m[i:i+4,iy])
endfor
j2=j2+1
endfor

plot,AVSig[0,*],ht1,background=-2,color=2,yrange=[0,zkm],$
 position=Plot_position2,xtitle='Ave5 PR2',ytitle='km';

stop
FOR m=1,N5-1 do begin
oplot,AVSig[m,*]+50*m,ht1,color=4
endfor
stop
outnm=dnm+'_av.jpg'
outf='f:\Lidar_data\output2\'+outnm;  systems\LidarPro\depolar\outputplt\STD.jpg'
write_JPEG,outnm,tvrd()
stop
 ;write_bmp,"d:\lidarsystem\Rayleigh\1993\sigse010044.bmp",tvrd()
 end

