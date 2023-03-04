Pro auto_contour_plot_MK
;auto plot all lidar data by search filelist
;also name:contour_aerosol_search_plot
;in the data list, number must follow by name with only one space as Ap082011 230
close,/all
device, decomposed=0

!p.multi=[0,1,2]
!p.background=255
 loadct,39
plot,[0,10],[-1,1],COLOR = 0
plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
oplot,[0,20],[1.5,1.5],COLOR = 50

;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'E:\RSI\hues.dat'
readf,2,rgb
close,2
free_lun,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels
plot_position1 = [0.1,0.15,0.90,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.90,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.97,0.2,0.99,0.45]
 BAR_POSITION2=[0.97,0.7,0.99,0.95]

CLOSE,/ALL
ERASE
bnum=8000; total bin number  6000x3.75=22.5 km
T=findgen(bnum)   ; define time
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light
dz=v*BT/2  ;this derive height resolution  3.75m
ht=dz*T/1000.+0.0001   ;convert ht to km and remove 0 as base

 year=''

  read,year, prompt='year as 2003: ?  '
  yr=string(year,format='(I4.4)')
 PATH0='D:\LIDAR_DATA\'+YEAR+'\';

 FILES=''

 read,FILES,prompt='name of the list file: as FILES2004July.txt'
 PATH1='D:\LIDAR_DATA\DATA_LIST\'+FILEs;
 LN1=''


 READ,Nz, PROMPT='INPUT NUMBER OF FILES AS 9 '
 ;NFLS=STRARR(Nz)
 ;Fik=strarr(2,20)
 fls=strarr(Nz)  ; data name
 YNM=INTARR(nz)  ; number of data
 OPENR,1,path1
  LN1=''

 for ns=0,nz-1 do begin

     READF,1,LN1
      PRINT,LN1
       FLS[ns]=strmid(LN1,0,11);  +'ASC'  ;filename
      YNM[ns]=strmid(LN1,20,3) ;file number


;
     endfor ;Ns
   print,FLS,Ynm
 close,1
 ;STOP

;;;;;;;;$ PART 2 READ DATA ******************************
   datab=fltarr(2,bnum)
read,n0,prompt='starting file as 9'
   HD='';
   FOR i1=n0,NZ-1 DO BEGIN ; open file to read
      ;fx='D:\LIDAR_DATA\2022\'+FLS[i]+'\a*'
      F2=PATH0+FLS[i1]+'\a*'
      ;fNM=PATH0+FLS[NS]
       Px=file_search(F2)  ; FINDING how many data are there
       nx=n_elements(px);


     AS=FLTARR(NX,BNUM)
     PS=FLTARR(NX,BNUM)

     FOR j0=0,nx-1 do begin
      OPENR,1,Px[j0]
         FOR h=0,5 do begin ;;;read licel first 5 head lines
         readf,1,hd
        ;print,hd
         endfor   ;h
;;************ Reading and plot  *****************************
 read,h1,h2,prompt='Height regions meters as 8000 : '

bn1=fix(h1/dz);

bn2=fix(h2/dz);
  month=strmid(Xnm[0],0,2)
  mn=strmid(month,0,2)
 ;read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
stop
    datab=fltarr(2,bnum)
read,n0,prompt='starting file as 9'
   HD='';
   FOR i1=n0,NZ-1 DO BEGIN ; open file to read
      ;fx='D:\LIDAR_DATA\2022\'+FLS[i]+'\a*'
      F2=PATH0+FLS[i1]+'\a*'
      ;fNM=PATH0+FLS[NS]
       Px=file_search(F2)  ; FINDING how many data are there
       nx=n_elements(px);


     AS=FLTARR(NX,BNUM)
     PS=FLTARR(NX,BNUM)

     FOR j0=0,nx-1 do begin
      OPENR,1,Px[j0]
         FOR h=0,5 do begin ;;;read licel first 5 head lines
         readf,1,hd
        ;print,hd
         endfor   ;h
       ;;;;;;;;;;;;;;;;;;;; reading data below
      READF,1, DATAB
     ; AS[J0,*]=datab[1,*];*(ht*1000)^2; PR2
      PS[J0,*]=datab[0,*];*(ht*1000)^2

      close,1
     ENDFOR; J0


 ;
   ;stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
    m=fix(NX/2)
    nbin=bn2-bn1+1
    PS1=fltarr(m/2,Nbin) ; parallel

    PS2=fltarr(m/2,Nbin) ;perpendicular
    J=0;          count file
    for k=0,m-2,2 do begin
     Ps1[J,*]=Ps[k,bn1:bn2]
     bk1=min(PS1[J,nbin-200:nbin-1])
     PS1[j,*]=PS1[j,*]-bk1
     ;PR2m[j,*]=PS1[j,*]*(ht*1000)^2;

     PS2[J,*]=Ps[k+1,bn1:bn2]
     bk2=min(PS2[j,Nbin-200:Nbin-1])
     PS2[j,*]=PS2[j,*]-bk2

     J=J+1
    endfor; k


Total_Ps=total(Ps1,1)+total(PS2,1)
z=ht(bn1:bn2)
z1=h1/1000.
z2=h2/1000.

;oplot,smooth(total_PS1,40),z,color=90
DATA_path='D:\Lidar_data\2022\OUTPUTS_10km\'
     ;out_path=data_Path+'\Aerosol_plots\'; lidarPro\output\yrmn"
     out_file=DATA_path+fls[i1]+'_10km.png'

    write_png,out_file,tvrd(/true)
;stop
endfor;I1
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;s1


xx=indgen(Nx)
yy=ht(bn1:bn2);



;**%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 bpath='D:\lidar_data\';  +yr+'\'+month
 FOR Nj=0,NZ-1 do begin
   dnm=xnm[NJ]
    ; read,dnm,prompt='data filename as mr022018'
   month=strmid(dnm,0,2)

  ; bpath='F:\Lidar_data\';   systems\depolar\'
   fnm=bpath+yr+'\'+month+'\'+dnm+'.';

   ; fnm=FILE_SEARCH(fpath); +'.'
  ;print,size(fnm)
    ;
  ;STOP
  ni=1
  nf=ynm[NJ]

; read,ni,nf, prompt='Initial and file number as 1,99: '
 ;read,h1,h2,prompt='Height range in km as 1,5: '
  nx=nf-ni+1
  j=0
  bnum=1000  ;total bin number
  T=findgen(bnum)
  datab=fltarr(bnum)
  pr2m=fltarr(nx,bnum)
  pr2d=fltarr(nx,bnum)
  ;fbk=fltarr(nx)
  ;dt=50; nanosecond
  dt=160.
  ht=3.0E8*dt*1.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:bnum-1]
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'
   ;openr,1,fn1; data_file;
    ; readf,1,datab
   datab=read_binary(fn1,DATA_TYPE=2)
   sigm=datab[0:bnum-1]
   sigm=smooth(sigm,10)
   bk1=mean(smooth(sigm[bnum-200:bnum-1],20))
   pr2m[j,*]=(sigm-bk1)*ht^2
   x=findgen(nx)
   y=ht1

   j=j+1
   close,1
  ENDFOR;n

  col = 240 ; don't change it

  cmax=1.2*max(pr2m[nx/2,10:200]);400;1500;500;./2
  cmin=cmax/100; cmax/10;min(pr2m[nf-ni-nx/2,0:200])

  nlevs_max =60. ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

 col = 240 ; don't change it
 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white



 ;f1=string(ni,format='(I3.3)')
 ;f2=string(nf,format='(I3.3)')
 ;f3=f1+'--'+f2
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title
 xtitle=yr+dnm
 contour,pr2m,x,y,xtitle='m channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position1,title=S
; xyouts,1.5*max(x),0.2*max(y),f3,/device
 ;stop
 ; plot a color bar, use the same clevs as in the contour

   ; nlevs=40
    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION1,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase


 ;stop
 k=0
 STOP

 FOR nd=ni+1,nf do begin
   sn=strtrim(fix(nd),2)
   fn2=fnm+strtrim(sn,2)+'d'
    ;openr,2,fn2; data_file;
    ; readf,2,datab
   datab=read_binary(fn2,DATA_TYPE=2)
   ;datab=datab[0:bnum-1]
   sigd=datab[0:bnum-1]
   sigd=smooth(sigd,10)

   bk2=mean(smooth(sigd[bnum-200:bnum-1],20))
  ; fbk[nd]=bk2/bk1
   ;print,bk2

  ; pr2d[k,*]=pr2d[k,*]/fbk[nd]
   pr2d[k,*]=(sigd-bk2)*ht^2

   x=findgen(nx)
   y=ht1


   k=k+1
   close,2
  ENDFOR  ;nd

  col = 240 ; don't change it
  cmaxd=2*max(pr2d[nx/2,10:200]);300;   0./5
  cmind=cmaxd/20.
   nlevs_max =10.
  cint = (cmaxd-cmind)/nlevs_max
  CLEVS = CMIND + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar
  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels


   C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
   c_index(NLEVS-1) = 1 ; missing data = white

   ;!x.range=[ni,ni+nf]
   contour,pr2d,x,y,xtitle='d channel time',ytitle='km',title=xtitle, yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position2
   ;xyouts,500,5,'fn',color=1,charsize=2
 ;stop
 ; plot a color bar, use the same clevs as in the contour
    ;nlevs=40
    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmind + cint*k
     xb = [0,1]
     yb = cmind + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION2,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmind,cmaxd],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase
 ; stop

WAIT,2
  ;opath='F:\lidar_data\output\'   ;output path Rayleigh\1995\se\se112342
   opath2='E:\lidar_data\'+yr+'\outputs\';
    cname =opath2+yr+'_'+dnm+'A.png
WRITE_png,cname,TVRD(/TRUE)
;stop
ENDFOR ; NJ

stop
 end



