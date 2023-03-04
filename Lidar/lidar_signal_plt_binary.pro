Pro Lidar_signal_Plt_binary

!P.MULTI = [0,1,2]
   plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
  plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
   plot_postion0=[0.1, 0.1,0.9,0.9]
!p.background=255

NBin=6000; total bin number  6000x3.75=22.5 km
T=findgen(NBin)   ; define time
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light
dz=v*BT/2  ;this derive height resolution  3.75m
ht=dz*T/1000.+0.0001   ;convert ht to km and remove 0 as base

FNMD='';  file name
year='2022'
;read,year,prompt='Input year of data as 2019:'
read,FnmD,PROMPT='NAME OF THE FILE AS 0415ASC: '
read,h1,h2,prompt='Initial and final height as ,1,5 km:'
;path='E:\temp\'
mon='Dec'
;path='E:\LiDAR_DATA\'+year+'\ASC\';
 path='D:\Lidar_DATA\'+year+'\';
 da=strmid(fnmd,0,4);
 bpath=path+FNMD;  bpath='G:\0425B\'
  fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
    Fno=Sf[1]
    T0=strmid(fls[0],41,5)
    T9=strmid(fls[Fno-1],41,5)
  ; SEARCH files of the day, starting with 0
  JF=0

da=strmid(fnmd,0,4)

print,da  ;day of data


    nx=Sf[1]


    bn1=round(h1*1000./dz)  ;define range of interest bn1 is the lower bin number
    bn2=round(h2*1000./dz)  ;upper bin
   ;s1=strtrim(fix(ni),2)   ; starting file number
   ;s2=strtrim(fix(nf),2)   ;ending file number
   ;Sw ='      file:'+s1+'_'+s2;used to print title
    sigxm=fltarr(nx,Nbin);   signal count in with range bn2-bn1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,Nbin)
    pr2d=fltarr(nx,Nbin)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

    NF=sf[1]   ; number of files
    ;nf1=4         ;LICEL data format inital file number is 5 ignore first 5 data
    ;nf2=NF-1
    Read,nf1,nf2,prompt=' starting and ending file nf1mnf2: '
     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular

    DATAB=FLTARR(2,Nbin)
    Ps=fltarr(m,Nbin) ;Ps photon counting signal
    PSB=fltarr(m); background
    AS0=fltarr(m,Nbin) ;original As  Analog signal
    AS=fltarr(m,Nbin); treated AS signal
    BAS=fltarr(m);  AS background
    close,/all
    J=0;nf1-1
    read,ap, prompt='input 0 for analog,1 for counting:'
    a_p=fix(ap)

   FOR I=nf1-1,nf2-1 DO BEGIN ; open file to read
    OPENR,1,fls[I]

      FOR h=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd

        print,hd
      endfor   ;h
      stop
;;;;;;;;;;;;;;;;;;;; reading data below
      READF,1, DATAB
      AS[J,*]=datab[a_p,*];*(ht*1000)^2; PR2
      BAS[j]=min(AS[J,5500:5999]); background
     ; PS[J,*]=datab[1,*];*(ht*1000)^2  ;bpath='f:\Lidar_data\';   lidarPro\depolar\'
   close,1
    J=J+1
   ENDFOR;

 opath= bpath+'output\'
close,/all
fd=''
dnm=''
T=findgen(4000)
sig1=fltarr(4000)
sig2=fltarr(4000)
ht1=3.0E8*50.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
;ht1=2*7.5*T/1000  ; ht in km with resoluton 7.5m
year=2009
 ;read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')

 month=''
 ; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 ;bpath='d:\Lidar systems\Raman lidar\'
; fpath=bpath+yr+'\'+month+'\'
 read,dnm,prompt='data file such as mr142042'
 month=strmid(dnm,0,2)
 fx=bpath+month+'\'+dnm+'.'
 ;fx=bpath+fnm+'.'

 read,h1,h2,prompt='Initial and final height as ,1,5 km:'

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

    fn1=fx+strtrim(fix(ni),2)+'m'
    openr,1,fn1;/get_lun
    ;readf,1,sig1
    sig1=read_binary(fn1,data_type=2)
    close, 1;
   ;sigsm=smooth(sig1,10)
   ;datab=read_binary(fn,DATA_TYPE=2)
    mina=mean(sig1[3800:3999])   ;background  [n1:n2])


    j=0
    sigxm[j,*]=sig1[0:3999]-mina;[n1:n2]-mina

     pr2m[j,*]=smooth(sigxm[j,*],20);*(ht1^2) ;

    maxa=max(Pr2m[j,*])
    dv=maxa/nx
    s1=strtrim(fix(ni),2)
    s2=strtrim(fix(nf),2)
   S=dnm+'                                       file:'+s1+'_'+s2;used to print title
    ;;plot,pr2m[j,*],ht1, background=-2,color=2 ,xrange=[0,.3*maxa],yrange=[h1,h2],xtitle='pll channel',ytitle='km' ,title=S
     ;position=plot_position1,

    plot,smooth(sigxm[j,*],20),ht1, background=-2,color=2 ,xrange=[0,.3*maxa],yrange=[h1,h2],xtitle='pll channel',ytitle='km',$
    position=plot_position1,title=S
    pr2m[j,*]=sigxm[j,*]*ht1^2
    plot,smooth(pr2m[j,*],20),ht1, background=-2,color=2 ,yrange=[h1,h2],xtitle='pll channel',ytitle='km',$
    position=plot_position2,title=S

    j=1
    stop
   FOR n=ni+1,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fx+strtrim(sn,2)+'m'
   openr,2,fn1
   ;readf,2,sig1
   sig1=read_binary(fn1,data_type=2)
   mina=mean(sig1[3900:3999]);  [n2:n2+500])   ;background  [n1:n2])
   sigxm[j,*]=sig1[0:3999]-mina;[n1:n2]-mina

   pr2m[j,*]=smooth(sigxm[j,*],20)*ht1^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   ; oplot,pr2m[j,*]+dv*j/3,ht1,color=2;
   ;oplot,smooth(sigxm[j,*],20)+dv*j/3,ht1,color=2
   ;wait,1
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

   close,2
  ENDFOR
   AV_PR2M=total(pr2m,1)/nx
   oplot,AV_PR2m,ht1,color=2,thick=2,background=-2,xrange=[0,1000],yrange=[0,5], $
   position=plot_position2,title='N2'
  close,2

  stop
   opath=bpath+yr+'\output\'

   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  cntrname =opath+yr+dnm+'-m-'+s2+'.bmp'
;WRITE_bmp, cntrname, TVRD()
stop
 ;;;;;;;;;;;;;;d file;;;;;;;;;;;;;;;;;;


 end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;

