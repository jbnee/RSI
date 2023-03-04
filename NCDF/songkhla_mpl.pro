Pro Songkhla_MPL
close,/all
path='E:\volcanos\Songkhla\LiDARData\'
Filex=path+'MPL*
Fs=file_search(Filex)

help,Fs
stop
A=FS[5]
B= SWAP_ENDIAN(A,/swap_if_little_endian)
stop
;X=binary_template(A)
;stop
fid=NCDF_open(B)
;Fx=Fs[3]

print,fid

stop



for i=0,9 do begin

A=NCDF_VARINQ(fid,i)
print,'i, A=',i, A
B=A.(0)

print,NCDF_VARID(fid,B)


endfor

print,A

  Lon = NCDF_VARID(fid,'longitude')
  Lat=NCDF_VARID(fid,'latitude');
  AEid=NCDF_VARID(fid,'AE_L3_Merged_Num')
  AODid=NCDF_VARID(fid,'AOT_L3_Merged_Num')

  Inq_vid=NCDF_VARINQ(fid,'AOT_L3_Merged_Num')
  help,INq_vid,/structure
  print,Inq_vid

;NCDF_ATTGET, fid , Varid] , Name, Value [, /GLOBAL]
print,Lon,Lat,AEid,AODid
stop
end