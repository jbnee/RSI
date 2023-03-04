Pro Himawari_NC_AOT;¥¼§¹
;, filename, variable_names, $
;	tagnames=tagnames, $
;	read_variables=read_variables, $
;	fillval=fillval, silent=silent
erase
;oquiet = !quiet
;path='D:\Himawari\DATA_L3_ARP\';
path='D:\Himawari\HIMA_L3_ARP\';  L3_ARP\';
files=path+'\H08*'
Quefile=file_search(files)
filename0=quefile(0)

cid = ncdf_open(filename0)
p1=ncdf_varid(cid,'latitude')
p2=ncdf_varid(cid,'longitude')
VARX=ncdf_inquire(cid)
print,VARX


ncdf_varget,cid,p1,Lat;
ncdf_varget,cid,p2,Lon;
help,lat,lon;

Lat1=min(where(Lat le 12.0))+1
Lat2=max(where(Lat GE 16.0))+1;
Lon1=max(where(Lon LE 119.0))+1
Lon2=min(where(Lon GE 123.0))+1;

print,lat1,lat2,lon1,lon2

stop
AOT3=fltarr(82)
AOT4=fltarr(82)
AOT7=fltarr(82)
AOT8=fltarr(82)

j=0
for i_file=10,40 do begin

;stop
;filename='E:\Himawari\DATA_L3_ARP\H08_20200112_0000_1DARP031_FLDK.02401_02401.nc'
;filename='E:\matlab\Taal_GW\Songkhla_MPL\MPL_5050_202002030406.nc'

filename=quefile(i_file)
 da=strmid(filename,32,4)

cid = ncdf_open(filename)
print,cid
VARX=ncdf_inquire(cid)
print,VARX

;ncdf_varget,cid,p5,AEp5; _L2
;ncdf_varget,cid,p6,AEp6
p2=ncdf_varid(cid,'AOT_Merged');
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

ncdf_varget,cid,p3,AOTp3;  MAOTL2
ncdf_varget,cid,p4,AOTp4;


ncdf_varget,cid,p7,AOTp7; mgAOTL3
ncdf_varget,cid,p8,AOTp8;
AOT2=MAOTL2[lon1:lon2,Lt2:Lt1]
AOT3=mgAOTL3[lon1:lon2,Lt2:Lt1]
;AOT3[j]=[j,AOTp3[lon1:lon2,lat2:lat1]]
;AOT4[j]=[j,AOTp4[lon1:lon2],[lt2:lt1]]
;AOT7[j]=[j,AOTp7[lon1:lon2],[lat2:lat1]]
;AOT8[j]=[j,AOTp8[lon1:lon2],[lt2:lt1]]
j=j+1
stop
endfor
stop
mn=size(AOT3); ;; remove -32768 or nan
for i2=0,mn[1]-1 do begin
   for j2=0,mn[2]-1 do begin
    if (AOT2[i2,j2] LE 0) then AOT2[i2,j2]=0;

    if (AOT3[i2,j2] LE 0) then AOT3[i2,j2]=0;

endfor;i2
endfor






stop
end