 Pro dm_ratio_SR430
; calculate normalization factor for d/m channel, should 0.0104
 ;year=2009
 read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')
 month=''
 dnm=''
 read,dnm,prompt='data filename as mr022018'
 month=strmid(dnm,0,2)


 bpath='F:\Lidar_DATA\';    systems\Depolar\';

 fpath=bpath+yr+'\'+month+'\'

  fpath=bpath+yr+'\'+month+'\'
 fnm=fpath+dnm+'.'; fpath+dnm+'.'
read,ni,nf, prompt='Initial and file number as 1,99: '
read,h1,h2,prompt='Height range in km as 1,5: '
  nx=nf-ni+1
 ;k=0
  bnum=1000
  bwd=160
  datab=fltarr(bnum)
  datad=fltarr(bnum)
  T=findgen(bnum)+1
  pr2m=fltarr(nx,bnum)
  pr2d=fltarr(nx,bnum)
  mbk=fltarr(nx)

  dz=3.0E8*bwd*1.E-9/2;
  ht=dz*T/1000.   ;convert ht to km
   ht1=ht[0:bnum/2-1]
   pk=fltarr(2,nf-ni+1)
  ; stop
  j=0
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'
   fn2=fnm+strtrim(sn,2)+'d'
  datab=read_binary(fn1,DATA_TYPE=2)
   datad=read_binary(fn2,DATA_TYPE=2)
   ;openr,1,fn1
  ; readf,1,datab
  ; openr,2,fn2
   ;readf,2,datad
   close,/all

   sigm=datab[0:bnum-1]
    bk1=mean(datab[bnum-100:bnum-1])

   sigd=datad[0:bnum-1]
     bk2=mean(datad[bnum-100:bnum-1])
   pr2m[j,*]=smooth(sigm,10)*ht^2
   pr2d[j,*]=smooth(sigd,10)*ht^2

   ;pm=where(pr2m[j,*] Le 0)

  ; pd=where(pr2d[j,*] Le 0)

    ;print,j,PM,PD
   mbk[j]=bk2/bk1
   j=j+1

  ENDFOR
   !P.multi=[0,1,2]
   plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
   plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]



   plot,pr2m[0,*],ht,color=2,background=-2,yrange=[h1,h2],position=plot_position1,title='PR2m'



   for i2=1,nf-ni do begin
    ;sn=strtrim(fix(ix1),2)

    oplot,pr2m[i2,*],ht,color=2
   endfor;i2
   stop
  ;plot,pr2d[0,*],color=2,background=-2,position=plot_posi
  plot,pr2d[0,*],ht,color=2,background=-2,yrange=[h1,h2],position=plot_position2,title='PR2d'
    for i3=1,nf-ni do begin
    ;sn=strtrim(fix(ix1),2)

    oplot,pr2d[i3,*],ht,color=2
   endfor;i3
   stop
  plot,mbk,color=2,background=-2,position=plot_position1,title='mbk'


  p1=where(~finite(mbk))  ;remove inf or nan

  if p1 ne -1 then begin
   print,'inf position: ',p1
   mbk[p1]=mbk[p1-1];  replace inf by previous number
   p2=where(~finite(mbk))
   mbk[p2]=mbk[p2-1] ; replace successive inf if there are two do more if there are 3 or more
  endif
  print,'mean background ratio d/m: ',mean(mbk)

  print,'STD dev: ', stddev(mbk)
    print,'STD/mean:  ',stddev(mbk)/mean(mbk)
 stop



    end