Pro MODIS_NC
path='D:\Taal_volcano\Songkhla_MPL\ D:\MODIS MYD08_D3'
files='D:\Taal_volcano\Songkhla_MPL\MODIS MYD08_D3\*.nc'

Result=file_search(files)

m=3
F3='D:\Taal_volcano\Songkhla_MPL\MODIS MYD08_D3\AOD550_Land_Mean.20200205.nc'
F3x='D:\Taal_volcano\Songkhla_MPL\MODIS MYD08_D3\MYD08_D3_6_1_Deep_Blue_Aerosol_Optical_Depth_550_Land_Mean.20200205.nc'

CDFID=Hdf_open(F3)

Q=ncdf_Inquire(cdfid)

print,q
stop
end
