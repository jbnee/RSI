Pro Licel_cirrus_Plt_MD123


;!p.multi=[0,1,2]
!p.background=255

  bpath='E:\Lidar_data\2009\'
  ;bpath='f:\Lidar_data\2008_9_Raman\MCA_n2\2009\';   lidarPro\depolar\'
 ;bpath='d:\Lidar systems\Raman lidar\2009\ja\'
;path='d:\LidarPro\Raman2009\532_0314\';'d:\Lidar systems\Raman lidar\20090314\532_0314\'
close,/all
fd=''
dnm=''
T=findgen(4000)
sig1=fltarr(4000)
sig2=fltarr(4000)
dz=3.0E8*50.E-9/2 ;binwidth 50 meter
Ht=dz*T/1000.+0.001   ;convert ht to km and starting 1meter
;Ht=2*7.5*T/1000  ; ht in km with resoluton 7.5m
year=2009
 ;read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')


 ; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 ;bpath='d:\Lidar systems\Raman lidar\'
; fpath=bpath+yr+'\'+month+'\'
  read,dnm,prompt='data file such as mr142042'
 month=strmid(dnm,0,2)
 fx=bpath+month+'\'+dnm+'.'
 Fn=fx+'*'
 file_num=file_search(Fn)
 NF=n_elements(file_num)/2
 print,'number of files: ',NF
 ;fx=bpath+fnm+'.'
  h1=6.
  h2=20.
 ;read,h1,h2,prompt='Initial and final height as ,1,5 km:'

 n1=round(h1*1000./7.5)  ;channel number
 n2=round(h2*1000./7.5)  ;ch

 read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title
sigxm=fltarr(nx,4000);n2-n1+1)
sigxd=fltarr(nx,4000)
pr2m=fltarr(nx,4000);n2-n1+1)
pr2d=fltarr(nx,4000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    j=0

    fn1=fx+strtrim(fix(ni),2)+'m'

    openr,1,fn1;/get_lun
    readf,1,sig1
   ; dataM=read_binary(fn1,DATA_TYPE=2);reading SR430
   ; sig1=dataM[0:3999]


    ;readf,1,sig1
    close, 1;
   ;sigsm=smooth(sig1,10)
   ;datab=read_binary(fn,DATA_TYPE=2)
    mina=mean(sig1[3800:3999])   ;background  [n1:n2])
    sigxm[j,*]=sig1-mina;[n1:n2]-mina

     pr2m[j,*]=smooth(sigxm[j,*],10);*(Ht^2) ;


    ; datab=read_ascii(fn1)

    ;pr2m[j,*]=smooth(sig1,10);*ht^2

    maxa=max(Pr2m[j,*])
    dv=maxa/nx
    s1=strtrim(fix(ni),2)
    s2=strtrim(fix(nf),2)
   S=dnm+'                   file:'+s1+'_'+s2;used to print title
    plot,pr2m[j,*],Ht, background=-2,color=2 ,xrange=[0,.3*maxa],yrange=[h1,h2],$
    xtitle='pll channel',ytitle='km' ,title=S+'PR2m'
     ;position=plot_position1,

   j=1

   FOR n=ni+1,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fx+strtrim(sn,2)+'m'
   openr,2,fn1
   readf,2,sig1
   mina=mean(sig1[3900:3999]);  [n2:n2+500])   ;background  [n1:n2])
   sigxm[j,*]=sig1-mina;[n1:n2]-mina

   pr2m[j,*]=smooth(sigxm[j,*],2);*ht^2
   ;oplot,sig+50*j,Ht, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   ;oplot,pr2m[j,*]+dv*j/3,Ht,color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1
   close,2

  ENDFOR  ;n

   for n2=ni+1,nf,10 do begin
    oplot,pr2m[n2,*]+dv*n2/3,Ht,color=2
   endfor;n2

  close,2

  stop
   opath=bpath+'\output\'

   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

 ; cntrname =opath+dnm+s2+'-m.png
;WRITE_png, cntrname, TVRD()
 ;;;;;;;;;;;;;;d file;;;;;;;;;;;;;;;;;;
     j2=0
    fn2=fx+strtrim(fix(ni),2)+'d'
    openr,3,fn2
    readf,3,sig2
    ; datab=read_ascii(fn1)
    minb=mean(sig2[3800:3999]);n2: n2+500])   ;background  [n1:n2])
    sigxd[j2,*]=sig2-minb;
     pr2d[j2,*]=smooth(sigxd[j2,*],10);*(Ht^2) ;
     maxb=max(Pr2d[j2,*])
     dv2=maxb/nx
    plot,pr2d[j2,*],Ht, background=-2,color=2,xrange=[0,maxb],yrange=[h1,h2],$
    xtitle='d channel',ytitle='km' ,title=S+'PR2D'
     ;position=plot_position2,
  close,3
  FOR nd=ni+1,nf do begin
   sn2=strtrim(fix(nd),2)
  ;ln=strlen(sn)

   fn2=fx+strtrim(sn2,2)+'d'
   openr,2,fn2
   readf,2,sig2
    minb=mean(sig2[n2:n2+500])   ;background  [n1:n2])
    sigxd[j2,*]=sig2-minb;[n1:n2]-mina

     pr2d[j2,*]=smooth(sigxd[j2,*],10);*(Ht^2) ;
     ;maxb=max(Pr2d[j2,*])
    ; dv2=maxb/nx
   ;oplot,sig+50*j,Ht, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   ;oplot,pr2d[j2,*]+dv2*j2/5,Ht,color=2;
   j2=j2+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

close,2
  ENDFOR;nd
 stop
for n3=ni+1,nf,10 do begin
    oplot,pr2d[n3,*]+n3*dv2/3.,Ht,color=2
endfor;n3


  close,2

stop
Tm=total(pr2m,1)/NF
Td=total(PR2D,1)/NF

plot,TM
oplot,TD,psym=3
stop
DP=TD/Tm
IDP=TM/TD
XDP=DP
stop
print,'Select XDP=DP/IDP)'
plot,smooth(XDP,50),ht,xrange=[0,10],color=2,background=-2,title='perpen/parall ratio'

stop

  opath=bpath+yr+'_licel\output\'

   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

;  cntrname =opath+yr+dnm+'s2-d.bmp
;   WRITE_bmp, cntrname, TVRD()
stop

 end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;

