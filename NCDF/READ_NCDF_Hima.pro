Pro READ_NCDF_Hima
;, filename, variable_names, $
;	tagnames=tagnames, $
;	read_variables=read_variables, $
;	fillval=fillval, silent=silent
erase
;oquiet = !quiet
path='D:\Himawari\HIMA_NC_DATA\';  L3_ARP\';
files=path+'\H08*'
Quefile=file_search(files)
stop
i_file=12
;for i_file=23,32 do begin;10,31 do begin
;stop
;filename='E:\Himawari\DATA_L3_ARP\H08_20200112_0000_1DARP031_FLDK.02401_02401.nc'
;filename='E:\matlab\Taal_GW\Songkhla_MPL\MPL_5050_202002030406.nc'
 filename=quefile(i_file)
f = file_test(filename, /regular)
if f eq 0 then begin
	print, 'File not found: '+filename
;	return, -1
endif
;stop
 da=strmid(filename,29,8)

cid = ncdf_open(filename)
print,cid
VARX=ncdf_inquire(cid)
print,VARX


p1=ncdf_varid(cid,'latitude')
p2=ncdf_varid(cid,'longitude')
p3=ncdf_varid(cid,'AOT_L2_Mean')
p4=ncdf_varid(cid,'AOT_L2_Num')
p5=ncdf_varid(cid,'AE_L2_Mean')
p6=ncdf_varid(cid,'AE_L2_Num')
p7=ncdf_varid(cid,'AOT_L3_Merged_Mean')
p8=ncdf_varid(cid,'AOT_L3_Merged_Num')
p9=ncdf_varid(cid,'AE_L3_Merged_Mean')
p10=ncdf_varid(cid,'AE_L3_Merged_Num')
print,p1,p2,p3,p4,p5,p6
print,p7,p8,p9,p10

;stop
ncdf_varget,cid,p1,Lat;
ncdf_varget,cid,p2,Lon;
help,lat,lon;

ncdf_varget,cid,p3,MAOTL2
ncdf_varget,cid,p7,mgAOTL3
help,MAOTL2,mgAOTL3


;stop
;;;******** define Taal latitude and longitude ********
Lt1=min(where(Lat le 12.0))+1
Lt2=max(where(Lat GE 16.0))+1;


;;;;;;;
Lon1=max(where(Lon LE 119.0))+1
Lon2=min(where(Lon GE 123.0))+1;

print,lt1,lt2,lon1,lon2

AOT2=0.0002*(MAOTL2[lon1:lon2,Lt2:Lt1]);
AOT3=0.0002*mgAOTL3[lon1:lon2,Lt2:Lt1]

;*********** remove nan **************************

mn=size(AOT2); ;; remove -32768 or nan
for i2=0,mn[1]-1 do begin
   for j2=0,mn[2]-1 do begin
    if (AOT2[i2,j2] LE 0) then AOT2[i2,j2]=0;

   if (AOT3[i2,j2] LE 0) then AOT3[i2,j2]=0;

endfor;
endfor

;;***********contour plot

plot_position = [0.1,0.15,0.90,0.95];
 BAR_POSITION=[0.95,0.2,0.98,0.95]


erase

device, decomposed=0

!p.background=255
 loadct,39

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

nx=lt1-lt2+1;
ny=lon2-lon1+1

  col = 240 ; don't change it
  cmax=max(max(AOT2))/2
  cmin=0
  ;cmax=max(AOT2)-min(AOT2);400;1500;500;./2
  ;cmin=cmax/20; cmax/10;min(pr2m[nf-ni-nx/2,0:200])

  nlevs_max =80. ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels


 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white

  x=indgen(nx)+lt2

  y=indgen(ny)+lon1

                                      ;file:'+s1+'_'+s2;used to print title
 ylat=lat(x);
 xlon=lon(y)
 contour,AOT2,Xlon,Ylat,xrange=[119,123],yrange=[12,16],xtitle=' longitude',ytitle='latitude',title=da+'AOT_L2',$
    LEVELS = CLEVS, /FILL,C_COLORS = C_INDEX, color=2,/FOLLOW,$
    position=plot_position

    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     ;xname = [' ',' ',' ']
      xname='AOT'

 CONTOUR, zb, xb(0:1), yb(0:nlevs-1),$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase,position=bar_position

;loadct,10
 ; plot,x,y,color=25,background=-2
outpath='E:\RSI\NCDF\output\'
outplot=outpath+da+'xx.png'
;write_png,outplot,tvrd(/true)
print,i_file
wait,1
;endfor  ; i_file
window,1
 contour,AOT3,Xlon,Ylat,xrange=[119,123],yrange=[12,16],xtitle=' longitude',ytitle='latitude',title=da+'AOT_L3_Merged mean',$
    LEVELS = CLEVS, /FILL,C_COLORS = C_INDEX, color=2,/FOLLOW,$
    position=plot_position

    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     ;xname = [' ',' ',' ']
      xname='AOT'

 CONTOUR, zb, xb(0:1), yb(0:nlevs-1),$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase,position=bar_position
stop
;loadct,10
 ; plot,x,y,color=25,background=-2
outpath='E:\RSI\NCDF\output\'
outplot=outpath+da+'xx.png'
;write_png,outplot,tvrd(/true)
print,i_file
wait,1




stop
end