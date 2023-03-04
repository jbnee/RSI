Pro Depolar_ASC123
close,/all
erase
;  ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   bnum= 8000  ;4km km
   ;constants  for the program
   bT=25     ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light

   dz= bT*ns*(c/2)  ;increment in height is dz=24 m

   dz1000=dz/1000 ;in km

  Ht=dz*findgen(bnum);

  fnm='';  file name
  year='2020'
  read,year,prompt='Input year of data as 2019:'

; fnm='0211ASC'
  read,fnm,PROMPT='NAME OF THE FILE AS 0415ASC: '
  h1=0
  h2=16.0
  print,'height range: ',h1,h2
  ;read,h1,h2,prompt='Initial and final height in km as ,1,5: '
  b1=long(h1/dz1000);
  b2=long(h2/dz1000)
  nb=b2-b1+1

  ;z=findgen(bnum)*dz;+h1  ; height in km
  ; ht=z[0:nb]*1000+h1 ; in meter
  ;plot,ht
  da=strmid(fnm,0,4)

  ;RB=fltarr(16,30)  ; output file type
   ;dnm='0806'

   bpath='d:\LiDAR_DATA\'+year+'\'+fnm;
    ;bpath=path+FNMD;  bpath='G:\0425B\'
   fx=bpath+'\a*'  ;file path
   fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF


  ;Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
 ; month=strmid(dnm,0,2)
;  stop
  ;READ,n1, n2, PROMPT='Intial and final records;eg.10,100 : '
  S1=n_elements(fls);
  read,n1,n2,prompt='starting and ending file number,as 1000,1200 '
  ;n1=S1-200;
  ;n2=S1
  read,m0,prompt='Number of files to average (eg 5) :'
  m0=long(m0)
  ;n1=fix(n1)
  ;n2=fix(n2)
  NF=n2-n1
  ;m0=1; average files to average; default is 5
  n5=round(NF/m0); number of  averaged data files
  m5=long(Nf/(2*m0));
  F1=strtrim(fix(n1),2)
  F2=strtrim(fix(n2),2)
  FS=fnm+'                         file:'+F1+'_'+F2;used to print title
  ;Ftitle=fnm
  ;stop
  ;define arrays
  b0=8000
  DATAB=FLTARR(2,b0)
  ;PS0=fltarr(NF,b0) ;original PS  Analog signal
  PS=fltarr(NF,b0); treated PS signal
  PS1=fltarr(NF/2,b0) ;PS1=fltarr(m/2,Nbin) ; parallel
  PS2=fltarr(NF/2,b0) ; perpendicular

  sg=fltarr(NF/2,b0)
  cnt_sig=fltarr(b0)

  ;read,h1,h2,prompt='height region as 1, 6 km  '
  ; input data

 print,fls[0]
 print,fls[n2-1]
 ;;;;;;;;;;;;;;;;;;;; reading data below

  hd=''
  nc=0  ;file count
   READ,channelx,prompt='0 for analog,1 for counting: '
  FOR I=0,nf-1 DO BEGIN ; open file to read
        Ix=I+n1
       OPENR,1,fls[Ix]

         FOR h=0,5 do begin ;;;read licel first 5 head lines
          readf,1,hd
          ;print,hd
         endfor   ;h

         READF,1, DATAB

      PS[nc,0:b0-30]=DATAB[channelx,29:b0-1]; 1:for photon counting

      close,1

      nc=nc+1

  ENDFOR; I
   print,fls[0],fls[n2-1]

      close,1
   ;plot,DataB[0,*],ht,title='check Analog/Counting'
   ;oplot,DataB[1,*],ht,psym=3
   stop

   PS1=fltarr(NF/2,b0) ;PS1=fltarr(m/2,Nbin) ;
   PS2=fltarr(NF/2,b0) ;
   BK1=fltarr(NF/2)
   BK2=fltarr(NF/2)

    J=0;          count file Separate parall and perpendicular channels

    for k=0,NF-2,2 do begin; alternative PLL/PPD
     PS1[J,*]=PS[k,*]
     PS2[J,*]=PS[k+1,*]
     BK1[J]=mean(PS1[J,b0-2000:b0-1])
     BK2[J]=mean(PS2[J,b0-2000:b0-1])
     PS1[j,*]=PS1[j,*]-bk1[j]
     PS2[j,*]=PS2[j,*]-bk2[j]

     J=J+1
    endfor; k

    J2=0

    na=long(NF/2)
    NC=long(NF/(2*m0))
    bkRatio=fltarr(na)
    ;ps1_5000=fltarr(na)
    ;ps2_5000=fltarr(na)

;;;;;;;;;;;;;;;;;;;;AVERAGE data;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AP1=fltarr(m5,b0)
AP2=fltarr(m5,b0)
;AP3=fltarr(m5,b0)  ; test channel
 j3=0

    FOR i1=0 , NF/2-m0, m0 do begin; average 5 profiles
     For jy=0,b0-1 do begin ;sum 5


       AP1[J3,jy]=total(PS1[i1:i1+m0-1,jy],1)/5;-BK1[j3]
       AP2[J3,jy]=total(PS2[i1:i1+m0-1,jy],1)/5;-BK2[J3]
     ; AP3[J3,jy]=(PS2[i1,jy]+PS2[i1+1,jy]+PS2[i1+2,jy]+PS2[i1+3,jy]+PS2[i1+4,jy])/5 ; test

     ENDFOR  ;i1
   j3=j3+1
 ENDFOR; I

stop
;;********  Check data in four groups ******************
erase
loadct=10
low_bin=indgen(3000)
hi_bin=low_bin+3000
!p.multi=[0,2,2]
 dm5=round(m5/4)

;;;part 1: first 1/4****************************
p0a=total(ap1[0:dm5-1,*],1)/10
p0b=total(ap2[0:dm5-1,*],1)/10

plot,low_bin,p0a[0:3000],color=2,background=-2,xtitle='bin #',title='0:1/4 data, lower level  '
oplot,low_bin,p0b[0:3000],color=-150

plot,hi_bin,p0a[3000:6000],color=2,background=-2,xrange=[3000,6000],xtitle='bin #',title='0:1/4 data,pper level  '
oplot,hi_bin,p0b[3000:6000],color=-150
stop

;;;;;;;;;;;;;;;;;;;;;;part II;;;;;;;;;;;;;;;;;;;;;;;;;;;;
p1a=total(ap1[dm5:2*dm5-1,*],1)/10
p1b=total(ap2[dm5:2*dm5-1,*],1)/10

plot,low_bin,p1a[0:3000],color=2,background=-2,xtitle='bin#', title='1/4:2/4 data lower level'
oplot,low_bin,p1b[0:3000],color=-150

plot,hi_bin,p1a[3000:6000],color=2,background=-2,xrange=[3000,6000],xtitle='bin#',title='1/4:2/4 data,upper level';
oplot,hi_bin,p1b[3000:6000],color=-152

;;;;;;;;;;;;;;;;;;;part III;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
stop
window,1
p2a=total(ap1[2*dm5:3*dm5-1,*],1)/10
p2b=total(ap2[2*dm5:3*dm5-1,*],1)/10

plot,low_bin,p2a[0:3000],color=2,background=-2,xtitle='bin #',title='2/4:3/4 data,lower level  '
oplot,low_bin,p2b[0:3000],color=-150

plot,hi_bin,p2a[3000:6000],color=2,background=-2,xrange=[3000,6000],xtitle='bin #',title='2/4:3/4 data,upprt level '
oplot,hi_bin,p2b[3000:6000],color=-150
stop

;;;;;;;;;;;;;;;;;;;;;;;Part IV ;;;;;;;;;;;;;;;;;;;;;;;;;;;
p3a=total(ap1[3*dm5:4*dm5-1,*],1)/10
p3b=total(ap2[3*dm5:4*dm5-1,*],1)/10

plot,low_bin,p3a[0:3000],color=2,background=-2,xtitle='bin #',title='3/4:4/4 data, lower level  '
oplot,low_bin,p3b[0:3000],color=-150

plot,hi_bin,p3a[3000:6000],color=2,background=-2,xrange=[3000,6000],xtitle='bin #',title='3/4:4/4 data, upper level'
oplot,hi_bin,p3b[3000:6000],color=-150
stop

print,'max size file AP1',m5

read,ra,rb,prompt='Range of data as group 10:40'

PS1A=total(AP1[ra:rb,*],1)/(rb-ra)
PS2A=total(AP2[ra:rb,*],1)/(rb-ra)


;;;determine which is parallel/perpendicular
window,0
loadct=10
!p.multi=[0,2,1]
loadct=5
nd=500

plot,PS1A[0:nd],color=2,background=-2,xtitle='bin #',title=fnm+'  PS1A/PS2A (blue)',position=pos1
oplot,PS2A[0:nd],color=150,psym=3
stop
max1=max(ps1a)
max2=max(ps2a)
max12=round(max([max1,max2]));

ht=ht/1000.
plot,ps1a[0:nd],ht[0:nd],color=2,ytitle='km',xtitle='signal',background=-2,xrange=[0,max12],title='Ave all signals'
oplot,ps2a[0:nd],ht[0:nd],color=150,psym=3
stop
out_name='';
read,out_name,'out file name: '
out_path='D:\lidar_data\2020\outputs\'
ofile=out_path+fnm+out_name+'.png'
write_png,ofile,tvrd(/true)

!p.multi=[0,1,1]
plot,PS1A[0:3000]
oplot,ps1a[0:3000]
stop
DP=PS2A/PS1A
IDP=1/DP
plot,smooth(dp,50),color=2,background=-2,xtitle='DP/IDP',title=fnm+'DP (black)/IDP (color)'
oplot,smooth(IDP,50),color=200;,background=-2,xtitle='IDP'
window,1

out_path='D:\lidar_data\2020\outputs\'
ofile=out_path+fnm+'_depolar.png'
;write_png,ofile,tvrd(/true)

;cp1=mean(DP[nd/2:nd]);-mean(DP[bnum-1000:bnum-1])
;cp2=mean(IDP[nd/2:nd]);-mean(IDP[bnum-1000;bnum-1])
;cp=[cp1,cp2]
;print,cp1,cp2,min(cp)
;CP=min(CP)
!p.multi=[0,1,2]
pos1 = [0.1,0.1,0.40,0.95]; plot_position=[0.1,0.15,0.95,0.45]
pos2 = [0.6,0.1,0.90,0.95];

XDP=DP
!p.multi=[0,1,1]
print,'change to IDP if necessary'
stop
window,1
!p.multi=[0,1,1]
plot,xdp[0:nd],ht[0:nd]/1000,color=2,background=-2,title='depolar ratio'
;read,BK_dp,prompt=' smaller of above
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; determine absolute dp
SDP=smooth(xdp,100,/edge_truncate)
plot,sdp[0:2*nd],ht[0:2*nd],color=2,background=-2,xtitle='smooth depolar',title=fnm
stop
window,0
erase
plot,sdp,title='SDP'

read,x1,x2,prompt='select bin region for average background:x1,x2 '
CP=mean(sdp[x1:x2])
CF=CP/0.015
print,'CF: ',CF
stop
plot,SDP[0:2*nd]/CF,ht[0:2*nd],color=200,background=-2,xtitle='depolar ratio',$
    ytitle='km';, position=pos1


stop
window,0

;;******** Segment depolarization ratio **************
 plot,ps1A[0:2*nd],ht[0:2*nd]/1000,color=2,background=-2,ytitle='km',xtitle='signal',$
   title='PS1A/PS2A (color)'
 oplot,PS2A,ht/1000,color=150

iz=indgen(20)*100;
DPI=fltarr(20)
for i=1,19 do begin
  DPI[i]=mean(PS2A[iz[i-1]:iz[i]])/mean(PS1A[iz[i-1]:iz[i]])
 endfor
 plot,DPI,psym=2


   Fout=out_path+fnm+'_xDP.png'

   write_png,fout,tvrd()
   ;openw,2,fileDP
  ; printf,2,Depolar
  ; close,2

  stop

   end





