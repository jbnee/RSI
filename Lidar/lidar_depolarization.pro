pro lidar_depolarization
;;;plot data based on betaM or betaD
;;; backscattering coefficients are calculated by Fernald_lidar_m and
;;;;;Fernald_lidar_d
;;;;;Producing data files in F:\RSI\Fernald\Aerosol\Ja15D_beta
;;;;;;;;Using Hamming filter to smooth,BKM and BKD files for beta_m and beta_m
;;;;;;;;;;;depolarization ratio is calculate by beta_d/beta_m
;;;;;;;;;;;;Rebin to 1/10 smaller (dep2) then expand back to average image (dep3)


  dz=7.5     ;160 ns for SR430 bin width
  year=2009;   year\month
  yr=strtrim(year,2);  remove white space
  fnm=''
    ;fnm=strmid(dnm,0,4)

  Read, fnm, PROMPT='Enter filename fnm as ja15;'   ; Enter date+code
  data_path='f:\RSI\lidar\Fernald\aerosol\';
  ;data_path='E:\lidar_files\depolar\2009_out\aerosol\';
  data1=data_path+fnm+'M_beta.txt'
  data2=data_path+fnm+'D_beta.txt'
  close,/all
  openr,1,data1
  hd1=''
  readf,1,hd1
    print,hd1
   colx=strmid(hd1,22,2)
  rawy=strmid(hd1,32,4)
  hd2=''
  readf,1,hd2
  print,hd2
  b1=strmid(hd2,0,2)
  b2=strmid(hd2,3,6)

  BackscattM=fltarr(colx,rawy)
  BackscattD=fltarr(colx,rawy)
  readf,1,BackscattM
   close,1
 openr,2,data2
 readf,2,hd
 readf,2,hd
 readf,2,BackscattD

  close,2
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;constants;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  dz=7.5/1000
  bnum=1000
  ht=dz*indgen(bnum)
  h1=b1*dz
  h2=b2*dz
  ;read,h2,prompt='height range as 5 (km) '
  ;b1=0
  ;b2=ceil(h2/dz)
  H=ht[b1:b2]*dz
  nx=colx


NH=20
k=hanning(NH)
BKM=1.e6*convol(BackscattM,k,/edge_truncate,/normalize);  Mm

BKD=1.e6*convol(BackscattD,k,/edge_truncate,/normalize); convert to Mm

read,fbk,promp='input normalization for d channel from pro dmratio: '

BKd=bkd/fbk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ERASE
close,/all
device, decomposed=0

!p.multi=[0,1,2]
!p.background=255
 loadct,39
plot,[0,10],[-1,1],COLOR = 0
plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
oplot,[0,20],[1.5,1.5],COLOR = 50


 plot_position1 = [0.1,0.15,0.90,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.90,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.95,0.2,0.98,0.45]
 BAR_POSITION2=[0.95,0.7,0.98,0.95]

;;;;;;;;;;;;;contour plot;;;;;;;;;;;;;;;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'f:\RSI\hues.dat'
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



  col = 240 ; don't change it

  cmax=1.5*max(bkm[nx/2,10:200]);400;1500;500;./2
  cmin=cmax/10; cmax/10;min(pr2m[nf-ni-nx/2,0:200])

  nlevs_max =30. ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

 col = 240 ; don't change it
 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white



  x=findgen(nx)
  y=ht[b1:b2-1]
                                      ;file:'+s1+'_'+s2;used to print title
 ctitle=fnm
 contour,BKM,x,y,xtitle='Parallel channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position1

    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     ;xname = [' ',' ',' ']
      xname='|| mM-1'
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION1,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase


 stop





 cmax=1*max(bkd[nx/2,10:200]);
  cmin=cmax/10;

  nlevs=10
  nlevs_max =10.
  cint = (cmax-cmin)/nlevs_max ;
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar
  cint = (cmax-cmin)/nlevs_max
 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

  cint = (cmax-cmin)/nlevs_max
  C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
  c_index(NLEVS-1) = 1 ; missing data = white


 contour,BkD,x,y,ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position2,title='Perpen-'+yr+fnm
    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     ;xname = [' ',' ',' ']
     xname='1/mM'

     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION2,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase
      stop
      out_path='f:\RSI\lidar\Fernald\out\'
      out_file1=out_path+fnm+'contour.png'
      write_png,out_file1,tvrd(/true)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;plot,depolarization ratio;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


 ;BKM=backscattM[*,50:b2]

 dep_ratio=(BKD/fbk)/BkM
 dep2=rebin(dep_ratio,10,44)
 dep3=rebin(dep2,40,440)

 !P.multi=[0,1,1]
  plot, dep3[0,*],y,yrang=[0,h2],background=-2,color=2,title=fnm+'depolar ratio'

  For i=1,Nx-1 do begin
     oplot,dep3[i,*],y,color=5*i
  endfor
  stop



 plot_position0 = [0.1,0.15,0.90,0.90]
  BAR_POSITION0=[0.95,0.5,0.99,0.95]


  cmax=0.02;
  cmin=cmax/20
 nlevs_max =30. ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

 col = 240 ; don't change it
 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white


  contour,dep3,x,y,xtitle=' time',ytitle='km',yrange=[0,3],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,title=yr+fnm,position=plot_position0

   zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase,position=bar_position0

stop

fout2=out_path+fnm+'depolar_dep3.png'
write_png,fout2,tvrd()

File2=out_path+fnm+'depolar3.txt'
openw,1,file2
printf,1,dep3
close,1

stop

end