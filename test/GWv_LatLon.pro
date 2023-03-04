 PRO GWv_LatLon
 close,/all
;table_path="E:\RSI\test\"
datecode=''

READ, datecode, PROMPT='Enter  DATE code eg.20041021: '
datecode=string(datecode, format="(I8.8)")
Read, Ir, Prompt='Enter record number: '
Ic1=string(Ir,format='(I3.3)')
cdf_path="E:\RSI\SPR\"
file1=cdf_path+"is_k0_spr_"+datecode+".cdf"
;readf, u1, datecode, im_rec
outz='E:\RSI\temp\'+'GWZ'+Ic1+'.txt'
outx='E:\RSI\temp\'+"GWx"+Ic1+'.txt'
outy='E:\RSI\temp\'+"GWy"+Ic1+'.txt'
print, file1
cdfmm=sddc_read_cdf(file1)
 ;irc = string(ir,format='(i3.3)')
  ;tvmm = rotate(mm(im-1).img0,3) ; rotate 270 deg. to make image file as (524,128)
   tvmm=rotate(cdfmm(ir-1).img0,3)
   tv,bytscl(tvmm,350,425)
read, Ix1,Ix2, prompt='Ix range: 400,500; or other values:  '
Read,Iy1,Iy2, prompt='Iy range: 0,100 : '
   pxmm=tvmm[Ix1:Ix2,Iy1:Iy2]
;Read, ht1,ht2,Prompt='Enter heights h1,h2 range:0-300 km as, 60,200 '

close,1
ht=95.0
Lat_range=(Ix2-Ix1+1)*(Iy2-Iy1+1)
Long_range=(Ix2-Ix1+1)*(Iy2-Iy1+1)

Alt=fltarr(lat_range)
aln=fltarr(long_range)
;Aln=make_array((Iy2-Iy1+1), /float)
;For IR=0,100,25 DO Begin
  openw,3,outx
  openw,4,outy
  Openw,1,outz
 n=0
  For Iy=0,(Iy2-Iy1) do Begin
  For Ix=0,(Ix2-Ix1) do begin
       ll=interpol_proj_ll(cdfmm[IR],IX,IY,Ht); for IRth record of the file
     L2=ll(2)
      IF (L2 EQ 1) THEN BEGIN
       ;format='5(F7.4)'

       Alt[n]=ll(1)
       Aln[n]=ll(0)
       z[Ix,Iy]=pxmm[Ix,Iy]
       ;PRINT, Ix,Iy,ll(0),ll(1)
       ;Printf,3,ll(0)
       ;printf,4,ll(1)
      ENDIF
   n=n+1
   ;m=m+1

   ENDFOR           ;end Iy

   ENDFOR           ;end Ix
      printf,3,Alt
      printf,4,Aln
      printf,1,z
;ENDFOR           ;Ir
close,/all
end