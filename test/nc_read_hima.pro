Pro NC_READ_HIMA
path='D:\Himawari\HIMA_NC_data\'
Filex=path+'H08*
Fs=file_search(Filex)

help,Fs
stop


fid=NCDF_open(Fs[3])
Fx=Fs[3]

print,fid

Result = NCDF_INQUIRE(fid)

print,Result
help,Result,/structure


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