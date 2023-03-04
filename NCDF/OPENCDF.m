source='E:\RSI\NCDF\SO2_merra2_nc.nc'

dir(source) %check data


ncdid=netcdf.open(source)  %get ncdid

%ncdid =        65536

varInd=0;
Xdata=netcdf.getVar(ncdid,varInd)