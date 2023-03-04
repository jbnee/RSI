Pro NC_READ
;path='D:\Himawari\HIMA_NC_data\'
path='E:\RSI\NCDF\';

All_Files=file_search(path+'*')
print,all_files
stop
filename='SO2_merra2_nc.nc''

Filex=path+filename



help,filex
stop


fid=NCDF_open(Filex)
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