Pro ncdf_read_XX
;, filename, variable_names, $
;	tagnames=tagnames, $
;	read_variables=read_variables, $
;	fillval=fillval, silent=silent

;oquiet = !quiet
filename='D:\Himawari\Hima_L3_ARP\H08_20200112_0000_1DARP031_FLDK.02401_02401.nc'
;filename='E:\matlab\Taal_GW\Songkhla_MPL\MPL_5050_202002030406.nc'
;filename='E:\RSI\NCDF\g4.areaAvgTimeSeries.M2T1NXAER_5_12_4_TOTSCATAU.20200101-20200228.119E_12N_123E_16N.nc'


f = file_test(filename, /regular)
if f eq 0 then begin
	print, 'File not found: '+filename
;	return, -1
endif
stop
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

stop
ncdf_varget,cid,p1,Lat;
help,Lat

ncdf_varget,cid,p3,Mean_AOTL2
help,Mean_AOTL2
stop
end