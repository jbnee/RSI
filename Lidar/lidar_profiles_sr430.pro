pro lidar_profiles_SR430
  ; based on betaM or betaD
  close,/all
  dz=24;    ; for SR430 bin width
  year='';
  read,year,prompt='enter year as 2003; '
  yr=strtrim(year,2);  remove white space
  dnm=''
    ;fnm=strmid(dnm,0,4)

  Read, dnm, PROMPT='Enter filename fnm as ja15;'   ; Enter date+code
   month=strmid(dnm,0,2)
  bpath='F:\Lidar_data\';   systems\depolar\'
  fpath=bpath+yr+'\'+month+'\'

  fnm=fpath+dnm+'.'
  read,ni,nf, prompt='Initial and file number as 1,99: '
  read,h1,h2,prompt='Height range in km as 1,5: '
  nx=nf-ni+1
  j=0
  bnum=1000  ;total bin number
  T=findgen(bnum)
  datab=fltarr(bnum)
  pr2m=fltarr(nx,bnum)
  pr2d=fltarr(nx,bnum)
  dt=160; nanosecond
  ;dt=50
  ht=3.0E8*dt*1.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:bnum-1]
 FOR nm=ni,nf do begin
   sn=strtrim(fix(nm),2)
   fn1=fnm+strtrim(sn,2)+'m'

   openr,1,fn1; data_file;

   datab=read_binary(fn1,DATA_TYPE=2)
   sigm=datab[0:bnum-1]
   sigm=smooth(sigm,10)
   bk=min(smooth(datab[bnum-200:bnum-1],20))
   pr2m[j,*]=(sigm-bk)*ht^2
   x=findgen(nx)
   y=ht1

   j=j+1
   close,1
  ENDFOR;nm

!p.multi=[0,2,1]
 plot_position1 = [0.1,0.15, 0.40,0.95]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.6,0.15,  0.90,0.95]; plot_position2=[0.1,0.6,0.95,0.95]

 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='       file:'+s1+'_'+s2;used to print title
 Paral=total(pr2m,1)/nx
 P1=smooth(Paral,10)
 a=max(P1)
 plot,P1/a,ht,color=2,background=-2,position=plot_position1,title=s
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;d channel;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  j=0
 FOR nd=ni,nf do begin

  sn=strtrim(fix(nd),2)
  fn2=fnm+strtrim(sn,2)+'d'

    openr,1,fn1; data_file;

   datab=read_binary(fn2,DATA_TYPE=2)
   sigd=datab[0:bnum-1]
   sigd=smooth(sigm,10)
   bk2=min(smooth(datab[bnum-200:bnum-1],20))
   pr2d[j,*]=(sigd-bk2)*ht^2
  ; x=findgen(nx)
  ; y=ht1

   j=j+1
   close,1
  ENDFOR;n


 perpen=total(pr2d,1)/nx
 P2=smooth(perpen,10)
 b=max(P2)

 plot,P2/b,ht,color=2,background=-2,position=plot_position2,title=dnm

close,/all

stop
end