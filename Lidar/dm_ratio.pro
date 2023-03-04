 Pro dm_ratio
; calculate normalization factor for d/m channel, should 0.0104
year=2009
 ;read,year, prompt='year as 2003: ?  '
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
  j=0
  k=0
  bnum=4000
  datab=fltarr(bnum)
  datad=fltarr(bnum)
  T=findgen(bnum)
  pr2m=fltarr(nx,bnum)
  pr2d=fltarr(nx,bnum)
  mbk=fltarr(nx)
  ht=3.0E8*50E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:bnum/2-1]
   pk=fltarr(2,nf-ni+1)
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'
   fn2=fnm+strtrim(sn,2)+'d'
  ; datab=read_binary(fn1,DATA_TYPE=2)
  ; datad=read_binary(fn2,DATA_TYPE=2)
   openr,1,fn1
   readf,1,datab
   openr,2,fn2
   readf,2,datad
   close,/all

   sigm=datab[0:bnum-1]
    bk1=mean(datab[bnum-100:bnum-1])

   sigd=datad[0:bnum-1]
     bk2=mean(datad[bnum-100:bnum-1])
   pr2m[j,*]=sigm*ht^2
   pr2d[j,*]=sigd*ht^2
   mbk[j]=bk2/bk1
   j=j+1

  ENDFOR

 plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 ;BAR_POSITION1=[0.97,0.2,0.99,0.45]
 ;BAR_POSITION2=[0.97,0.7,0.99,0.95]

 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title

   ; DEVICE, DECOMPOSED=0
   ;fnmc=''
  ; read,fnm,prompt='filename to output'
    ;cntrname =opath+fnm+dnm+'.tiff'

   ;WRITE_tiff, cntrname, TVRD(/TRUE)

    s0=strtrim(fix(ni),2)

   ; read,hx,prompt='input height of  cloud presence as 2 km: '
    ;ichn=round(hx/0.0075)  ; chnn number

    plot,pr2d[0,*],color=2,background=-2,position=plot_position1
    oplot,pr2m[0,*],color=2
    for ix=1,nf-ni do begin
    ;sn=strtrim(fix(ix1),2)

    oplot,pr2d[ix,*],color=2
    ;wait,2
    endfor;ix
    ;stop
     dmratio=fltarr(nx)
    dmratio=pr2d[*,bnum-500:bnum-1]/pr2m[*,bnum-500:bnum-1]
    ;plot,smooth(dmratio0,5),color=2,position=plot_position2;yrange=[0,0.2]
    plot,dmratio,color=2,background=-2
    oplot,mbk,color=100

    print, 'mean bk: ',mean(mbk)
     print,'mean ratio: ',mean(dmratio)
    print,'normalizatin: ',mean(dmratio)/0.0104;
    print,'STD dev: ', stddev(dmratio)
    print,'STD/mean:  ',stddev(dmratio)/mean(dmratio)


    end