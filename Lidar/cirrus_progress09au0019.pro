 Pro cirrus_Progress09au0019
; This program find progess of cirrus and then find the peak height

!p.multi=[0,1,2]
;!p.background=255
 plot_position1 = [0.1,0.15,0.93,0.45];
 plot_position2 = [0.1,0.6,0.93,0.94];
  bpath='d:\Lidar_systems\lidarPro\depolar\'
 ;bpath='d:\Lidar systems\Raman lidar\2009\ja\'
;path='d:\LidarPro\Raman2009\532_0314\';'d:\Lidar systems\Raman lidar\20090314\532_0314\'
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
 ig=floor(nx/avex)  ;group number id

sig1=fltarr(ig-1,4000)
sig2=fltarr(ig-1,4000)
tmp_a=fltarr(4000)
tmp_b=fltarr(4000)
pr2m=fltarr(ig,4000)
pr2d=fltarr(ig,4000)
;stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; read the first data and plot
      sn=1
      sigx1=fltarr(4000)
      sigx2=fltarr(4000)
     fn1= fx+strtrim(sn,2)+'m'   ;;;sprintf('%s\\%s\\%s.%d%s',path,fam(1:2),fam(1:8),f,'m');
    ; fn2= fx+strtrim(sn,2)+'d'
      openr,1,fn1
      readf,1,sigx1
      close,1
     ; openr,2,fn2
     ; readf,2,sigx2
    ; close,2
   ;stop


   pr2m[0,*]=(smooth(sigx1,10))/avex ;*ht^2
   minx=min(pr2m[0,*])
   maxx=max(pr2m[0,*])
  ; pr2d[0,*]=(smooth(sigx2,10))/avex ;*ht^2
  plot,pr2m[0,*],ht1,yrange=[h1,h2],xrange=[minx,10*maxx],position=plot_position1,color=2,background=-2$
     ,title=s,xtitle='no profiles',ytitle='km';
     ;plot,pr2d[0,*],ht1,yrange=[h1,h2],position=plot_position2,color=2,background=-2;

  ;stop
 j=0
FOR ng=0,ig-2 do begin   ;      ni+1,nf do begin

     jset=[ng*avex+ni, (ng+1)*avex+ni];  % j is the jth set of data for averaging given by ave
     tmp_a=0

 FOR nm =jset[0],jset[1] do begin ;addition within the group

      sn=strtrim(fix(nm),2)
      fn1= fx+strtrim(sn,2)+'m'   ;;;sprintf('%s\\%s\\%s.%d%s',path,fam(1:2),fam(1:8),f,'m');
     ; fn2= fx+strtrim(sn,2)+'d'
      ;print,fn1,fn2
      openr,1,fn1
      readf,1,sigx1
      close,1
     ; openr,2,fn2
     ; readf,2,sigx2
     ; close,2
      tmp_a=tmp_a+sigx1
     ; tmp_b=tmp_b+sigx2
  endfor; nm
 pr2m[ng,*]=(smooth(tmp_a,10))/avex ;*ht^2
; pr2d[ng,*]=(smooth(tmp_b,10))/avex ;*ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'

  ; pr2d[ig,*]=(smooth(tmp_b,10))/avex ;*ht^2

   oplot,pr2m[ng,*]+avex*j*1.75,ht1,color=2;

   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

 endfor ; ng
  stop

;;;d files  ;;;;%%%%%%%%%%%%%%%%%%%%%###################&&&&&&&&&&&&&&

 fn2= fx+strtrim(sn,2)+'d'

      openr,2,fn2
      readf,2,sigx2
     close,2
 pr2d[0,*]=(smooth(sigx2,10))/avex ;*ht^2
 maxd=max(pr2d[0,*])
     plot,pr2d[0,*]/5,ht1,xrange=[0,maxd*5],yrange=[h1,h2],position=plot_position2,color=2,background=-2,$
     title=dnm,xtitle='number',ytitle='km';
   j2=0
 FOR kg=0,ig-2 do begin   ;      ni+1,nf do begin

     ;jdset=[mg*avex+1, mg*avex+ni];  % j is the jth set of data for averaging given by ave
      jdset=[kg*avex+ni, (kg+1)*avex+ni];  % j i
     tmp_b=0

 FOR mf =jdset[0],jdset[1] do begin ;addition within the group
      sn=strtrim(fix(mf),2)
      ;;;sprintf('%s\\%s\\%s.%d%s',path,fam(1:2),fam(1:8),f,'m');
      fn2= fx+strtrim(sn,2)+'d'

      openr,2,fn2
      readf,2,sigx2
      close,2

      tmp_b=tmp_b+sigx2
  endfor; nf

 pr2d[kg,*]=(smooth(tmp_b,10))/avex ;*ht^2

   oplot,pr2d[kg,*]/5+avex*j2,ht1,color=2;,position=plot_position2;
   j2=j2+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

 endfor ;mg
stop
 DEVICE, DECOMPOSED=0
  opath='d:\Lidar_systems\lidarPro\depolar\cirrus plots\2009\'

   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  cntrname =opath+dnm+'.bmp'

stop
WRITE_bmp, cntrname, TVRD()
stop
read,n,prompt='plot file for nth data ;'
a=max(pr2m[n,*])
b=max(pr2d[n,*])
plot,smooth(pr2m[n,*],10),color=2,background=-2
plot,smooth(pr2d[n,*],10),color=2,background=-2;xrange=[0,b/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='parallel'
;cntrname =cntrname+'_plt.bmp
;WRITE_bmp, cntrname, TVRD()
stop
read, npk, prompt='peak file location such as 2000: '
a1=fltarr(ig)
b1=fltarr(ig)
z1=fltarr(ig)
z2=fltarr(ig)
for ip=1,ig-1 do begin
a1[ip-1]=max(Pr2m[ip-1,npk-500:npk+500])
b1[ip-1]=max(pr2d[ip-1,npk-500:npk+500])
z1[ip-1]=where(pr2m[ip-1,*] eq a1[ip-1])
z2[ip-1]=where(pr2d[ip-1,*] eq b1[ip-1])
endfor
!p.multi=[0,1,1]
plot,ht1[z1],yrange=[h1,h2],xrange=[0,ig],color=2,background=-2,psym=7,xtitle='number',ytitle='km',title=dnm
oplot,ht1[z2],psym=1
stop
pkf1 =opath+dnm+'pk.bmp'
WRITE_bmp, pkf1, TVRD()
pkf2=opath+dnm+'_pkht.txt'
openw,1,pkf2
printf,1,ht1[z1]
close,1
plot,ht1[z1]-ht1[z2],yrange=[-0.1,0.1],xrange=[0,ig],color=2,background=-2,psym=7,xtitle='number',ytitle='km',title='pk m/d difference'
stop

a=max(ht1[z1])*1000
b=min(ht1[z1])*1000
plot,ht1[z1]*1000,yrange=[b,a],psym=2,color=2,backgorund=-2,ytitle='height (m)',xtitle='time'

cloudpk=opath+dnm+'pkm.bmp'
write_bmp,cloudpk,tvrd()
stop
end



