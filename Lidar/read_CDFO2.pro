Pro read_cdfO2
;Oxy06a=sddc_read_cdf("d:\RSI\cdf2006\2006015_R04.cdf")
device, decomposed=0

rgb = bytarr(3,256)
close,/all
openr,2,'d:\rsi\hues.dat'

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
close, /all

;file="D:\ISUAL_program\14orb\spr_200809\spr_20080905_01_3.cdf"
file='d:\RSI\cdf2006\2006053_R07.cdf'
cdfs=sddc_read_cdf(file)
stop
; Select event number, in this case, event 0

image=5 ;this is record number

cdf=cdfs[image]
tvcdf=rotate(CDF.img0,3);
plot,tvcdf(250,*),color=2,background=-2
stop
maxi=max(tvcdf)
mini=min(tvcdf)
tv,bytscl(tvcdf,mini,maxi)
;tv,cdf
stop

;start with a colour table, read in from an external file hues.dat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
col = 240 ; don't change it
cmax=max(tvcdf);
cmin=min(tvcdf)/2;

nlevs_max =40. ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240. ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white
 plot_position= [0.1,0.15,0.93,0.93];
 ;plot_position2 = [0.1,0.6,0.93,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION=[0.95,0.6,0.97,0.95]

x=findgen(524)
y=findgen(128)
bg=median(tvcdf[100:400,90:120])
 contour,tvcdf-bg,x,y,xtitle='latitude',ytitle='km',xrange=[0,500], title='O2 airglow',LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position
 ;xyouts,500,5,'fn1',color=1,charsize=2
 stop
 ; plot a color bar, use the same clevs as in the contour
    nlevs=40
    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE,position=BAR_POSITION, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase


 stop

end
