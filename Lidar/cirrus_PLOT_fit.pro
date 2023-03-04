Pro cirrus_plot_fit
loadct=5
device, decomposed=0

;
close,/all
fd=''
dnm=''
T=findgen(4000)
sig1=fltarr(4000)
sig2=fltarr(4000)
bw=0.0075  ; bin width in km
;c=3.e8  ;speed of light
;dz=bw*c/2
ht1=3.0E8*50.E-9*T/2./1000.0+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
;ht1=2*7.5*T/1000  ; ht in km with resoluton 7.5m
year=2009
 ;read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')

;bpath='d:\Lidar_files\depolar\'+yr+'\'
 ; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 bpath='f:\Lidar_data\'+yr+'\'   ;Raman lidar\'
; fpath=bpath+yr+'\'+month+'\'
  read,dnm,prompt='data file such as jy100050'
 month=strmid(dnm,0,2)
 fx=bpath+month+'\'+dnm+'.'
 ;fx=bpath+fnm+'.'
  h1=14
  h2=20
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

     pr2m[j,*]=smooth(sigxm[j,*],10);*(ht1^2) ;


    ; datab=read_ascii(fn1)

    ;pr2m[j,*]=smooth(sig1,10);*ht^2

    maxa=max(Pr2m[j,*])
    dv=maxa/nx
    s1=strtrim(fix(ni),2)
    s2=strtrim(fix(nf),2)
   S=dnm+'                                       file:'+s1+'_'+s2;used to print title
    plot,pr2m[j,*],ht1, background=-2,color=2 ,xrange=[0,.3*maxa],yrange=[h1,h2],xtitle='pll channel',ytitle='km' ,title=S
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
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2m[j,*]+dv*j/3,ht1,color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

close,2
  ENDFOR
  close,2

  ;stop
   opath='f:\RSI\lidar\data_list\'

   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  c1 =opath+dnm+s2+'-m.png
WRITE_png, c1, TVRD()
 ;;;;;;;;;;;;;;d file;;;;;;;;;;;;;;;;;;
     j2=0
    fn2=fx+strtrim(fix(ni),2)+'d'
    openr,3,fn2
    readf,3,sig2
    ; datab=read_ascii(fn1)
    minb=mean(sig2[3800:3999]);n2: n2+500])   ;background  [n1:n2])
    sigxd[j2,*]=sig2-minb;
     pr2d[j2,*]=smooth(sigxd[j2,*],10);*(ht1^2) ;
     maxb=max(Pr2d[j2,*])
     dv2=maxb/nx
    plot,pr2d[j2,*],ht1, background=-2,color=2,xrange=[0,0.1*maxb],yrange=[h1,h2],xtitle='d channel',ytitle='km' ,title=S
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

     pr2d[j2,*]=smooth(sigxd[j2,*],10);*(ht1^2) ;
     ;maxb=max(Pr2d[j2,*])
    ; dv2=maxb/nx
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2d[j2,*]/5+dv2*j2/5,ht1,color=2;
   j2=j2+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

close,2
  ENDFOR
  close,2

;stop


   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  c2 =opath+dnm+'s2-d.bmp
WRITE_bmp,c2,TVRD()
stop
read,h1,h2,prompt='PR2m bottom and top ht in km 10:20 km:'
bin1=round(h1/bw);
bin2=round(h2/bw)
dbin=bin2-bin1
print,'bin1, bin2, dbin:',bin1,bin2,dbin
htc=ht1[bin1:bin2]
SPR2M=total(Pr2m,1)
S=max(SPR2m[bin1:bin2])
plot,htc,spr2m[bin1:bin2],color=2,background=-2;xrange=[h1,h2]
stop

;;;;;;;;;;;;;;store file;;;;;;;;;;;;;
c3=opath+dnm+'Tm_pr2m.txt'
Tpr2m=fltarr(2,bin2-bin1+1)
Tpr2m[0,*]=htc
Tpr2m[1,*]=spr2m[bin1:bin2]
openw,1,c3
printf,1,Tpr2m
close,1
;stop
;;;;;;;Below for fitting by interpol

read,y1,y2,y3,prompt='fitting range in km as y1(16),y2(16.8) extending to y3(18.0) :  '
bx1=round(y1/bw)  ;bin for y1
bx2=round(y2/bw)  ;bin for y2
bx3=round(y3/bw)  ;bin for y3print,dbx

dbx=bx2-bx1
print,bx1,bx2,bx3,dbx

;
c4 =opath+dnm+'cirrus.bmp'
WRITE_bmp,c4,TVRD()
stop
Uht=ht1[bx1:bx3]
htd=ht1[bx1:bx2]
B=smooth(total(Pr2m[*,bx1:bx2],1),10)
plot,uht,B,color=2,background=-2,yrange=[0,s]
A=linfit(htd,B)
YB=a[0]+A[1]*htd
oplot,YB,htd,color=20
;stop

P=Interpol(YB,htd,Uht)
oplot,Uht,P,psym=4,color=120
;stop
oplot,uht,spr2m[bx1:bx3],color=145
stop
  c5 =opath+dnm+'_fit.bmp
WRITE_bmp,c2,TVRD()
c6=opath+dnm+'fit,txt'
sz=size(P)
Cx=fltarr(3,sz[1])
Cx[0,*]=uht
Cx[1,*]=P
Cx[2,*]=spr2m[bx1:bx3]
openw,1,c6
printf,1,Cx
stop
end





