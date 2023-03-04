Pro md_ratio_depolar

; this program plot ratio of d to m channels in normalized PR2/max-----------------------------
;start with a colour table, read in from an external file hues.dat
;for SR430
device, decomposed=0

   Loadct,5
year=2004;   year\month
 yr=string(year,format='(I4.4)')
;file_basename1='f:\Lidar_data\2009\ja\';  \se\se010044.'
 dnm=''
  Read, dnm, PROMPT='Enter filename dnm as ja152233;'   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4);file_basename1='d:\LidarPro\1997\au\';mr312023.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

 bw=160.e-9  ;bin width=50 ns
 dz=24.0
 bnum=1000
 T=findgen(bnum)
 ht=dz*T/1000

; ht=3.0E8*bw*T/2./1000.   ;convert ht to km


;fx=file_basename1+dnm+'.'
read,n1,n2, prompt='Initial and file number as 1,99: '

read,h1,h2, prompt='height range in km 1,6 km,,,,'
bn1=round(h1*1000./dz)
bn2=round(h2*1000./dz)
dbn=bn2-bn1
  nx=n2-n1+1
 s1=strtrim(fix(n1),2)
 s2=strtrim(fix(n2),2)
 S='                                       file:'+s1+'_'+s2




   !P.multi=[0,1,2]
   plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
   plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]


   cnt_sig1=fltarr(bn2)
   cnt_sig2=fltarr(bn2)

   ;sig2=fltarr(nx-1,bn2)
   data_path='f:\lidar_data\
   out_path='f:\lidar_data\out_2018\'
   close,/all

;;;;;;;;;;;;NORMALIZATION OF D/M SIGNALS ;;;;;;;;;

 pr2m=fltarr(nx,bn2)
  Npr2m=fltarr(nx,bn2)
  pr2d=fltarr(nx,bn2)
  Npr2d=fltarr(nx,bn2)
  dm_ratio=fltarr(nx,dbn)
   bk1=fltarr(nx)
   bk2=fltarr(nx)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fbk=fltarr(nx)
   For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+Jr ;file index starting from n1
      ni=strcompress(fix(jf),/remove_all)
    fn1=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'
    fn2=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'

   ;openr,1,fn1;
   ; readf,1,cnt_sig1;
   ; close,1
    ;openr,2,fn2
    ;readf,2,cnt_sig2;
    ;close,2
     cnt_sig1=read_binary(fn1, DATA_TYPE=2)  ; cnt_sig  ;read binary file
      cnt_sig2=read_binary(fn2, DATA_TYPE=2)

    bk1[jr]=min(cnt_sig1[bnum-100:bnum-1])
    mn1=mean(bk1)
    bk2[jr]=min(cnt_sig2[bnum-100:bnum-1])
    mn2=mean(bk2)
    ;fbk[jr]=(mn2/mn1)/0.014;;;NORMALIZATION FACTOR
    fbk=1
   ;print,'fbk: ',fbk
   ; sig1=cnt_sig1[bn1:bn2-1]-bk1[jr]
     sig1=cnt_sig1-bk1[jr]
     sig2=cnt_sig2-bk2[jr]
   ; sig2=cnt_sig2[bn1:bn2-1]-bk2[jr]

   ; pr2m[jr,bn1:bn2-1]=smooth(sig1,10)*ht^2
   ;pm=where(pr2m[jr,bn1:bn2] LT 0)
    ;pr2d[jr,bn1:bn2-1]=smooth(sig2,10)*ht^2
   ; pd=where(pr2d[jr,bn1:bn2] LT 0)
     sig1=sig1[0:bn2-1]
     sig2=sig2[0:bn2-1]
     ht=ht[0:bn2-1]
    pr2m[jr,*]=smooth(sig1,10)*ht^2
    pm=where(pr2m[jr,*] LT 0)

    pr2d[jr,*]=smooth(sig2,10)*ht^2
    pd=where(pr2d[jr,*] LT 0)

   ; print,jr,PM,PD
  endfor;jr
 ; print,'mean fbk, STDV :',mean(fbk),stddev(fbk)
stop


   ht1=ht[bn1:bn2-1]
    maxa=max(Pr2m[0,bn1:bn2-1])
    maxb=max(Pr2d[0,bn1:bn2-1])
    Npr2m[0,*]=pr2m[0,*]/maxa  ;normalized PR2M
    Npr2d[0,*]=pr2d[0,*]/maxb  ; ;
   ; stop
n5=round(nx/5)
Xm=fltarr(n5,dbn)
Xms=fltarr(n5,dbn)

Xd=fltarr(n5,dbn)
Xds=fltarr(n5,dbn)

;;;;;;;;;;;;;;;;Take signals between the range bins bn1:bn2;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Xm0=pr2m[0,bn1:bn2-1]
plot,XM0,ht1,color=2 ,background=-2,xrange=[0,2000], xtitle='mean Pr2_m',position=plot_position1
    j2=0

FOR im=0 , nx-10, 10 do begin; average10 profiles
For iy=0,bn2-bn1-1 do begin
   Xm[J2,iy]=MEAN(pr2m[im:im+4,iy])

   ;x2[J2,IY]=(X0[i,iy]+x0[i+1,iy]+X0[i+2,iy]+X0[i+3,iy]+X0[i+4,iy])/5
endfor;iy

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Xms[J2,*]=smooth(Xm[J2,*],20);/10
 qm=where(xms[j2,*] LT 0)
 print,j2,qm
oplot,Xms[J2,*]+2*im,ht,color=2
j2=j2+1
endfor;im
stop

;;;;;;;;;;;;;;;;; d channel;;;;;;;;;;;;;;;;;

Xd0=pr2d[0,bn1:bn2-1]
plot,Xd0,ht1,color=2 ,background=-2,xrange=[0,1000],xtitle='mean Pr_d ',position=plot_position2

J3=0
FOR id=0,nx-10, 10 do begin; average 10 profiles

  For iy=0,bn2-bn1-1 do begin

    Xd[J3,iy]=MEAN(pr2d[id:id+4,iy])

  endfor;;;iy

 Xds[J3,*]=smooth(Xd[J3,*],20)
  qd=where(xms[j3,*] lt 0)
 ;print,j3,qd

oplot,Xds[J3,*]+2*id,ht,color=5

j3=j3+1
endfor ;;;;id
stop
 outf1=f:\RSI\lidar\fernald\out\2004fe26\pr2.bmp
  write_bmp,outf1,tvrd()
 ;
  for j4=0,n5-1 do begin
    depolar[j4,*]=(xds[j4,0:bn2-bn1-1]/xms[j4,0:bn2-bn1-1])/mean(fbk)
   endfor; 'j4

    !P.MULTI =0;
    ;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'F:\RSI\hues.dat'
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 col = 240 ; don't change it
  cmax=1.5*max(depolar[n5/2,dbn/2]);400;1500;500;./2
  cmin= cmax/40; cmax/10;min(pr2m[nf-ni-nx/2,0:200])

  nlevs_max =30. ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

 col = 240 ; don't change it
 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white

 plot_position = [0.1,0.15,0.90,0.9];

 BAR_POSITION=[0.94,0.2,0.96,0.9]

 s1=strtrim(fix(n1),2)
 s2=strtrim(fix(n2),2)
 S='                                       file:'+s1+'_'+s2;used to print title
 ctitle=yr+dnm
x=indgen(n5)+1

 contour,depolar,x,ht1[0:83],xtitle='channel time',ytitle='height (km)',title='depolar',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position

 ; plot a color bar, use the same clevs as in the contour

   ; nlevs=40
    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']

  CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase,xtitle='delta'


 stop



    plot,depolar[1,*],ht1,background=1,color=2,xrange=[0,1]
    ; $;position=plot_position3  $
    ; xrange=[0,f*nx],yrange=[10,15],xtitle='m/d ratio',ytitle='km' ,title=dnm+S,charsize=0.75
   stop
   for j5=1,n5-1 do begin
     oplot,depolar[j5,*]+j5*0.01,ht1,color=100
   endfor ;j5
   ;js
   stop





   AVdepolar=total(depolar,1)/n5


   read,z,prompt='height km for average depolarization ratio: '
   bz=z*1000/dz
   mean_depolar=mean(depolar[*,0:dbn-1])
   print,mean_depolar
   A_depolar=depolar[*,dbn-1]
   plot,A_depolar,color=2,background=1,title='ave depolar'

  ;;;;;;

  stop
  S2=s1+'_'+s2

  outnm=dnm+'deplar_'+S2
  write_bmp,out_path+outnm+'.bmp',tvrd()
 ; write_bmp,"f:\lidar systems\lidarPro\depolar\outputpk\1997\"+outnm+'.bmp',tvrd()
  ADp=fltarr(2,n5)
  Nt=indgen(n5)
  ADp[0,*]=Nt
  ADp[1,*]=A_depolar

  outfile=out_path+dnm+'depolar.txt'
   openw,1,outfile
   printf,1,ADp
   close,1


 stop

end