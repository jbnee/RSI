;PRO Findlayer
;to find emission layers based on SPR or AUR data
;Key in names for data files input and out put and data paths
; In the last section jy is from 85 to 115

close,/all
table_path="D:\RSI\"
;im_rec=0   ;initial rec #
sp_rec=0
ap_rec=0
N0=128     ;total record
step=4    ;d is the step
sx=N0/step ;size of array to creat in rpixl and tpixl
kl=0       ; loop counter
datecode=0L
datecode=20041015   ;Date code
datecode=string(datecode, format="(I8.8)")
rpixl=fltarr(100,sx+1)
tpixl=fltarr(sx+1,100)
DATAIN='0'
Icode=string(sx)                ;file code

;**** loop start

For k=0,N0,step Do begin   ;run for all record
kl=kl+1
im_rec=k
;datain=k


dist=0.
reg_x=intarr(516)
reg_y=intarr(516)
cdf_path="D:\RSI\AUR\"

event=0
;while not eof(u1) do begin
;readf, u1, datecode, im_rec, sp_rec, ap_rec, dist
event=event+1

cdf_file=cdf_path+"is_k0_aur_"+datecode+".cdf"

cdf=sddc_read_cdf(cdf_file, rec_start=im_rec, rec_read=1)

TPA=interpol_TPA(cdf)
TPA1=get_cdf_TPA(cdf,1)
TPA2=get_cdf_TPA(cdf,2)


; left edge (TPA1)
GLL=fltarr(3)
GLL[2]=1
ptn=0
  X=4.0
  Y=0.0
while GLL[2] ne 0 do begin
  GLL=Proj_LL_TPA(TPA1, X,Y, 87.0)
  if GLL[2] ne 0 then begin
    if ptn eq 0 then begin
          L1_Lon=[GLL[0]]
          L1_Lat=[GLL[1]]
    endif else begin
          L1_Lon=[L1_Lon,GLL[0]]
          L1_Lat=[L1_Lat,Gll[1]]
    endelse
    ptn=ptn+1
  endif
  Y=Y+1.0
endwhile
LY=Y-1.0

; limb (TPA1)
T1_LON=L1_LON[n_elements(L1_LON)-1]
T1_LAT=L1_LAT[n_elements(L1_LON)-1]
Y=LY
for x=5, 520 do begin
  GLL=Proj_LL_TPA(TPA1, X,Y, 87.0)
  if GLL[2] ne 0 then begin ;  left half
    while GLL[2] ne 0 do begin
      P_GLL=GLL
      Y=Y+1.0
      GLL=Proj_LL_TPA(TPA1, X,Y, 87.0)
    endwhile
      T1_Lon=[T1_Lon,P_GLL[0]]
      T1_Lat=[T1_Lat,P_Gll[1]]
      y=y-1.0
  endif else begin       ; right half
      while GLL[2] eq 0 do begin
      P_GLL=GLL
      Y=Y-1.0
      GLL=Proj_LL_TPA(TPA1, X,Y, 87.0)
    endwhile
      T1_Lon=[T1_Lon,GLL[0]]
      T1_Lat=[T1_Lat,Gll[1]]
  endelse
  ;print, x,y
        reg_x(x-5)=x
      reg_y(x-5)=y
endfor                     ;x

    temp=size(cdf.trigger_time, /type)
    if temp ne 0 then time=cdf.trigger_time else time=cdf.buffer_switch_time

Lon=[L1_LON, T1_LON]
LAT=[L1_LAT, T1_LAT]

corr_y=intarr(516)
for i=0,515 do begin
 corr_y(i)=max(reg_y)-reg_y(i)
endfor

t=intarr(524,128)
for i=262,523 do t(i,*)=+18

pixl=fltarr(524, 128+max(corr_y))

;rotate images
img0=rotate(cdf[0].img0,3)
img0=img0-t
for i=5,520 do begin
pixl[i, corr_y(i-5):corr_y(i-5)+127]=img0[i,*]
;print, i, i-5
endfor   ;i

;window, 1, xsize=524, ysize=128+max(corr_y)
;tv, bytscl(pixl, 350,900)

;endwhile
;stop
; print IMG data
IMGIN=''          ;IMGIN is a string
OUT_path="C:\RSI\O1D\"
    ;Input file name
nfil='F3_1015'
;READ, nfil, PROMPT='Enter filename  : '
xf=OUT_path+nfil+".txt"
outfil=strcompress(xf)

X0=150   ; horizontal initial X pos. to sum singal
Y0=30    ; starting height
VL=100   ;Height layer
HL=25    ; X width

;first get the background signals for 5 levels above top layer of Y0(115)
; Next we calculate signals at each vertical level (jy)

   bpixl=mean(pixl(x0:x0+19,Y0-10:Y0-6))   ; Background level

for jy=0,VL-1 do begin
   ly=Y0+jy           ; layer
   spixl=mean(pixl(X0:X0+HL,ly))
      ;d_sig=spixl-bpixl
      ;if d_sig LT 0 then begin
      ; rpixl(jy,kl-1)=0
      ; endif else begin
      ;rpixl(jy,kl-1)=spixl-bpixl
      ;endelse
    rpixl(jy,kl-1)=spixl
         hgt=2*ly+40
  ; print, ly,hgt, spixl,bpixl,rpixl(jy,kl-1)
 endfor;      jy loop
 endfor    ;   k
 kl=0      ; reset loop counter
tpixl=transpose(rpixl)
openw, 4, outfil
 printf,4, tpixl, Format= '(33(F6.2,2X))'
 close, 4
Read,prompt='Initial and final latitude degree (-8): ',L2,L2
Lat=L1+Findgen(sx+1)*(L2-L1)/sx
Ht=Findgen(99)*2.5+40
Er=fltarr(100)
;&&&&&&&&&&&&&&  plot profile
;window, 2, xsize=500, ysize=128
for lp=0, sx do begin
xp=tpixl(lp,*)
Er=smooth(xp, 5)
x=Er
y=Ht
plot,x,y
endfor

;contour,  tpixl, Lat, Ht, XTitle='Latitude', YTitle='Height km' ,background=getcolor('white',23),color=getcolor('red',44) ,/fill

;write_bmp, 'outplt.bmp',TVRD()
stop
end
