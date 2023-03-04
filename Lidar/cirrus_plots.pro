 Pro cirrus_Plots_MK
; This program find progess of cirrus and then find the peak height

!p.multi=[0,1,2]
;!p.background=255
 plot_position1 = [0.1,0.15,0.93,0.45];
 plot_position2 = [0.1,0.6,0.93,0.94];
  bpath='D:\Lidar_data\'

close,/all
fd=''
dnm=''
T=findgen(4000)
sig1=fltarr(4000)
sig2=fltarr(4000)
dt=50 ;ns time resolution
ht1=3.0E8*dt*1.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
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
 fx=bpath+yr+'\'+month+'\'+dnm+'.'
 ;fx=bpath+fnm+'.'

;read,h1,h2,prompt='Initial and final height as ,1,5 km:'
  h1=14.
  h2=18.
 n1=round(h1*1000./7.5)  ;channel number
 n2=round(h2*1000./7.5)  ;ch

 read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
  s1=strtrim(fix(ni),2)
  s2=strtrim(fix(nf),2)
  S='                                       file:'+s1+'_'+s2;used to print title

read,avex, prompt='how many files to  average? '
 GI=floor(nx/avex)  ;group number id

sig1=fltarr(GI,4000)
sig2=fltarr(GI,4000)
tmp_a=fltarr(4000)
tmp_b=fltarr(4000)
pr2m=fltarr(GI,4000)
pr2d=fltarr(GI,4000)
bkm=fltarr(GI)
bkd=fltarr(GI)
;stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; read the first data and plot
      sn=1
      sigx1=fltarr(4000)
      sigx2=fltarr(4000)
     fn1= fx+strtrim(sn,2)+'m'   ;;;sprintf('%s\\%s\\%s.%d%s',path,fam(1:2),fam(1:8),f,'m');


       IM=0

 FOR i1=0,GI-2 do begin   ;      ni+1,nf do begin

     jset=[i1*avex+ni, (i1+1)*avex+ni];  % j is the jth set of data for averag given by ave
     tmp_a=0

   FOR nm =jset[0],jset[1] do begin ;sum to get average in within the group

      sn=strtrim(fix(nm),2)
      fn1= fx+strtrim(sn,2)+'m'   ;;;sprintf('%s\\%s\\%s.%d%s',path,fam(1:2),fam(1:8),f,'m');

      openr,1,fn1
      readf,1,sigx1
      close,1

      tmp_a=tmp_a+sigx1

   ENDFOR; nm
 pr2m[i1,*]=(smooth(tmp_a,10))/avex ;*ht^2
 bkm[i1]=total(pr2m[i1,3900:3999],2)/100;  background
 pr2m[i1,*]=pr2m[i1,*]-bkm[i1];

   IM=IM+1

ENDFOR; i1
  minx=min(pr2m[0,*])
  maxx=max(pr2m[0,*])


 plot,pr2m[0,*],ht1,yrange=[h1,h2],xrange=[0,2*maxx],position=plot_position1,color=2,background=-2$
     ,title=s,xtitle='no profiles',ytitle='km';


 for i2=1,GI-1 do begin
  oplot,pr2m[i2,*]+avex*i2*4,ht1,color=2;
 endfor

  stop

;; ;;;;;;;;priocess d files %###################&&&&&&&&&&&&&&

 fn2= fx+strtrim(sn,2)+'d'

 JD=0
 FOR j1=0,GI-2 do begin   ;      ni+1,nf do begin


      jdset=[j1*avex+ni, (j1+1)*avex+ni];  % j i
     tmp_b=0

 FOR j2 =jdset[0],jdset[1] do begin ;addition within the group
      sn=strtrim(fix(j2),2)
      ;;;sprintf('%s\\%s\\%s.%d%s',path,fam(1:2),fam(1:8),f,'m');
      fn2= fx+strtrim(sn,2)+'d'

      openr,2,fn2
      readf,2,sigx2
      close,2

      tmp_b=tmp_b+sigx2
  ENDFOR; j2

 pr2d[j1,*]=(smooth(tmp_b,10))/avex ;*ht^2
 bkd[j1]=total(pr2d[j1,3900:3999],2)/100;  background
 pr2d[j1,*]=pr2d[j1,*]-bkd[j1];

 JD=JD+1


 ENDFOR ;j1

  maxd=max(pr2d[0,*])
  plot,pr2d[0,*]/5,ht1,xrange=[0,maxd*2],yrange=[h1,h2],position=plot_position2,color=2,background=-2,$
     title=dnm,xtitle='number',ytitle='km';

for K2=1,GI-1 do begin
   oplot,pr2d[K2,*]/5+avex*k2*4,ht1,color=2;,position=plot_position2;
endfor;

stop
 DEVICE, DECOMPOSED=0
  opath='f:\lidar_data\2009\plots\'

   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  cntrname =opath+dnm+'.bmp'

stop
WRITE_bmp, cntrname, TVRD()
stop
read,n,prompt='plot file for nth data ;'
a=max(pr2m[n,*])
b=max(pr2d[n,*])
plot,smooth(pr2m[n,*],10),color=2,background=-2,xtitle='bin number'
plot,smooth(pr2d[n,*],10),color=2,background=-2,xtitle='bin number';xrange=[0,b/10],yrai1e=[h1,h2],xtitle='count',ytitle='km',title='parallel'
;cntrname =cntrname+'_plt.bmp
;WRITE_bmp, cntrname, TVRD()
stop
p1=max(pr2m[n,1200:3000]) ;find pk at height >10 km
q1=where(pr2m[n,2000:300] eq p1)
print,'peak position= ',q1;
read, npk, prompt='peak file location such as 2000: '
a1=fltarr(GI)
b1=fltarr(GI)
z1=fltarr(GI)
z2=fltarr(GI)
for ip=1,GI-1 do begin
a1[ip-1]=max(Pr2m[ip-1,npk-500:npk+500])
b1[ip-1]=max(pr2d[ip-1,npk-500:npk+500])
z1[ip-1]=where(pr2m[ip-1,*] eq a1[ip-1])
z2[ip-1]=where(pr2d[ip-1,*] eq b1[ip-1])
endfor
!p.multi=[0,1,1]
plot,ht1[z1],yrai1e=[h1,h2],xrange=[0,GI],color=2,background=-2,psym=7,xtitle='number',ytitle='km',title=dnm
oplot,ht1[z2],psym=1
stop
pkf1 =opath+dnm+'pk.bmp'
WRITE_bmp, pkf1, TVRD()
pkf2=opath+dnm+'_pkht.txt'
openw,1,pkf2
printf,1,ht1[z1]
close,1
plot,ht1[z1]-ht1[z2],yrange=[-0.1,0.1],xrange=[0,GI],color=2,background=-2,psym=7,xtitle='number',ytitle='km',title='pk m/d difference'
stop

a=max(ht1[z1])*1000
b=min(ht1[z1])*1000
plot,ht1[z1]*1000,yrange=[b,a],psym=2,color=2,backgorund=-2,ytitle='height (m)',xtitle='time'

cloudpk=opath+dnm+'pkm.bmp'
write_bmp,cloudpk,tvrd()
stop
end



