pro read_hdf_wfc_1ns,path,FNAME           ;DPC RELEASE VERSION 3.4
;
;This is a simple read program for the CALIPSO Wide Field Camera (WFC)
; Level 1 Data Products, including assignments to variables contained in the
; WFC 1km Native Science Common (WFC_1NS_COMMON.pro)
; The user can comment out any assignments not required for their application.
; This Reader Version 3.2v1 corresponds to the Data Products Catalog Release 3.4.
; The DP Catalog is available on the CALIPSO public web site:
;     http://www-calipso.larc.nasa.gov/resources/project_documentation.php
; This reader corresponds to DPC Tables 18 and 20.
;
; There are 2 string inputs to this program:
;   1) the path (i.e. 'C:\') containing the data
;   2) the filename of the WFC Level 1 1km Native Science HDF file to be read.
;
; Also provided is a corresponding Checkit_W1NS program to verify that all variables
;   have been read and assigned. It is called at the end of this program.
;
; March 8, 2006         PLL (Science & Technology Corp.)   Initial Release
; December 8, 2006      PLL (Science Systems & Applications, Inc.)  Data Release
; August 16, 2007	PLL (Science Systems & Applications, Inc.)  Interim Release
; December 3, 2007	PLL (Science Systems & Applications, Inc.)  Data Release
; March 16, 2010        Science Systems & Applications, Inc.        Read Software update only
; September 16, 2010    Science Systems & Applications, Inc.        Data Release
; February 28, 2011     Science Systems & Applications, Inc.        Read Software update only
; December 20, 2011     Science Systems & Applications, Inc.        DPC version udpate
;
; NOTE: Pease modify lines in code that meet your system's requirements.

; For Unix and using the IDLDE for Mac
; Include the full path before the WFC_1NS_COMMON called routine.
; An example would be @/full/path/WFC_1NS_COMMON
; Otherwise, if routine in same working directory as main routine, full 
; path is not needed.
@WFC_1NS_COMMON

dsets=0
attrs=0

; Uncomment/comment out the correct lines to ensure that the paths are 
; interpreted correctly for your computer system.

; For Windows
;print,'opening ',path + '\' + FNAME
; For Unix
print,'opening ',path + '/' + FNAME

; For Windows
;fid=hdf_open(path + '\' + FNAME,/read)
; For Unix
fid=hdf_open(path + '/' + FNAME,/read)

; For Windows
;SDinterface_id = HDF_SD_START( path + '\' + FNAME , /READ  )
; For Unix
SDinterface_id = HDF_SD_START( path + '/' + FNAME , /READ  )

HDF_SD_Fileinfo,SDinterface_id,dsets,attrs

; Retrieve the names of the sds variables
for k=0,dsets-1 do begin
    sds_id=HDF_SD_SELECT(SDinterface_id,k)
    HDF_SD_GETINFO,sds_id,name=var,dims=dimx,format=formx,hdf_type=hdft,unit=unitx;,range=xrng
    print,'sds_id=',sds_id,'   var=',var,'   dimx=',dimx,'   formx=',formx,'   hdft=',hdft,'   unitx=',unitx


;TABLE 20 PARAMETERS

if var eq 'Scan_Time' then HDF_SD_GETDATA,sds_id,W1NS_SCAN_TIME
if var eq 'Scan_UTC_Time' then HDF_SD_GETDATA,sds_id,W1NS_SCAN_UTC
if var eq 'Latitude' then HDF_SD_GETDATA,sds_id,W1NS_LAT
if var eq 'Longitude' then HDF_SD_GETDATA,sds_id,W1NS_LON
if var eq 'Radiance' then HDF_SD_GETDATA,sds_id,W1NS_RADNC
if var eq 'Reflectance' then HDF_SD_GETDATA,sds_id,W1NS_RFLTNC
if var eq '1km_Homogeneity' then HDF_SD_GETDATA,sds_id,W1NS_1KM_HMGEN
if var eq 'Solar_Zenith' then HDF_SD_GETDATA,sds_id,W1NS_SOL_ZNTH
if var eq 'Solar_Azimuth' then HDF_SD_GETDATA,sds_id,W1NS_SOL_AZMTH
if var eq 'Viewing_Zenith' then HDF_SD_GETDATA,sds_id,W1NS_VW_ZNTH
if var eq 'Viewing_Azimuth' then HDF_SD_GETDATA,sds_id,W1NS_VW_AZMTH
if var eq 'CCD_Temperature' then HDF_SD_GETDATA,sds_id,W1NS_CCD_TEMP
if var eq 'BasePlate_Temperature' then HDF_SD_GETDATA,sds_id,W1NS_BASPLT_TEMP
if var eq 'Reflectance_Bins' then HDF_SD_GETDATA,sds_id,W1NS_RFLT_BINS
if var eq 'Pixel_QC_Flag' then HDF_SD_GETDATA,sds_id,W1NS_PXL_QC_FLAG

HDF_SD_ENDACCESS,sds_id

endfor

HDF_SD_END,SDinterface_id

;Retrieve the Vdata information
vds_id = HDF_VD_LONE(fid)
vdata_id=HDF_VD_ATTACH(fid,vds_id,/read)

HDF_VD_GET,vdata_id,name=var,count=cnt,fields=flds,size=sze,nfields=nflds


;TABLE 18 PARAMETERS

nrec = HDF_VD_READ(vdata_id,W1NS_PROD_ID,fields='Product_ID')
nrec = HDF_VD_READ(vdata_id,W1NS_DAT_TIM_START,fields='Date_Time_at_Granule_Start')
nrec = HDF_VD_READ(vdata_id,W1NS_DAT_TIM_END,fields='Date_Time_at_Granule_End')
nrec = HDF_VD_READ(vdata_id,W1NS_DAT_TIM_PROD,fields='Date_Time_of_Production')
nrec = HDF_VD_READ(vdata_id,W1NS_GD_125_REC,fields='Number_of_Good_125m_Records')
nrec = HDF_VD_READ(vdata_id,W1NS_BAD_125_REC,fields='Number_of_Bad_125m_Records')
nrec = HDF_VD_READ(vdata_id,W1NS_GD_1KM_REC,fields='Number_of_Good_1km_Records')
nrec = HDF_VD_READ(vdata_id,W1NS_BAD_1KM_REC,fields='Number_of_Bad_1km_Records')
nrec = HDF_VD_READ(vdata_id,W1NS_INIT_SUBSAT_LAT,fields='Initial_Subsatellite_Latitude')
nrec = HDF_VD_READ(vdata_id,W1NS_INIT_SUBSAT_LON,fields='Initial_Subsatellite_Longitude')
nrec = HDF_VD_READ(vdata_id,W1NS_FINAL_SUBSAT_LAT,fields='Final_Subsatellite_Latitude')
nrec = HDF_VD_READ(vdata_id,W1NS_FINAL_SUBSAT_LON,fields='Final_Subsatellite_Longitude')
nrec = HDF_VD_READ(vdata_id,W1NS_ORB_NUM_GRAN_START,fields='Orbit_Number_at_Granule_Start')
nrec = HDF_VD_READ(vdata_id,W1NS_ORB_NUM_GRAN_END,fields='Orbit_Number_at_Granule_End')
nrec = HDF_VD_READ(vdata_id,W1NS_ORB_NUM_CHANG_TIM,fields='Orbit_Number_Change_Time')
nrec = HDF_VD_READ(vdata_id,W1NS_PATH_NUM_GRAN_START,fields='Path_Number_at_Granule_Start')
nrec = HDF_VD_READ(vdata_id,W1NS_PATH_NUM_GRAN_END,fields='Path_Number_at_Granule_End')
nrec = HDF_VD_READ(vdata_id,W1NS_PATH_NUM_CHANG_TIM,fields='Path_Number_Change_Time')
nrec = HDF_VD_READ(vdata_id,W1NS_EPHM_FILES_USED,fields='Ephemeris_Files_Used')
nrec = HDF_VD_READ(vdata_id,W1NS_ATT_FILES_USED,fields='Attitude_Files_Used')
nrec = HDF_VD_READ(vdata_id,W1NS_VIC_CAL_USED,fields='Vicarious_Calibration_File_Used')
nrec = HDF_VD_READ(vdata_id,W1NS_RAD_1KM_COEFS,fields='1km_Radiance_Calibration_Coefficients')
nrec = HDF_VD_READ(vdata_id,W1NS_RAD_125_COEFS,fields='125m_Radiance_Calibration_Coefficients')
nrec = HDF_VD_READ(vdata_id,W1NS_COL_NUM_CTR_PXL,fields='Column_Number_of_Center_Image_Pixel')
nrec = HDF_VD_READ(vdata_id,W1NS_ROW_NUM_CTR_PXL,fields='Row_Number_of_Center_Image_Pixel')
nrec = HDF_VD_READ(vdata_id,W1NS_FRM_TIME,fields='Frame_Time')
nrec = HDF_VD_READ(vdata_id,W1NS_INTEG_TIME,fields='Integration_Time')
nrec = HDF_VD_READ(vdata_id,W1NS_POSS_DAY_PKTS,fields='Total_Poss_Day_Packets')
nrec = HDF_VD_READ(vdata_id,W1NS_PROC_DAY_PKTS,fields='Total_Proc_Day_Packets')
nrec = HDF_VD_READ(vdata_id,W1NS_PROC_NIGHT_PKTS,fields='Total_Proc_Night_Packets')
nrec = HDF_VD_READ(vdata_id,W1NS_REFL_BINS_MIN,fields='Reflectance_Bins_Min')
nrec = HDF_VD_READ(vdata_id,W1NS_REFL_BINS_MAX,fields='Reflectance_Bins_Max')
nrec = HDF_VD_READ(vdata_id,W1NS_SOL_ZNTH_BINS_MIN,fields='Solar_Zenith_Bins_Min')
nrec = HDF_VD_READ(vdata_id,W1NS_SOL_ZNTH_BINS_MAX,fields='Solar_Zenith_Bins_Max')

HDF_VD_DETACH,vdata_id

HDF_CLOSE,fid

; For Unix and using IDLDE for Mac
; Include the full path before the Checkit_W1NS called routine.
; An example would be
; @/full/path/Checkit_W1NS
; Otherwise, if routine in same working directory as main routine, full
; path is not needed.
@Checkit_W1NS

; Below are two examples of printing out the parameters from a data file.

; The print statement below prints out the file name which is: FNAME, the
; W1NS_PROD_ID which is the Product_ID, and the W1NS_DAT_TIM_PROD which is the Date_Time_of_Production.
product_id = string(W1NS_PROD_ID)
w1nsprodtim = string(W1NS_DAT_TIM_PROD)
print,FNAME,'     ',product_id,'     ',w1nsprodtim

print,'Orbit_Number_at_Granule_Start = ', W1NS_ORB_NUM_GRAN_START
print,'Orbit_Number_at_Granule_End = ', W1NS_ORB_NUM_GRAN_END
print,'Orbit_Number_at_Change_Time= ', W1NS_ORB_NUM_CHANG_TIM
print,'Path_Number_at_Granule_Start = ', W1NS_PATH_NUM_GRAN_START
print,'Path_Number_at_Granule_End = ', W1NS_PATH_NUM_GRAN_END
print,'Path_Number_at_Change_Time= ', W1NS_PATH_NUM_CHANG_TIM

; The print statement below prints ou the W1NS_PXL_QC_FLAG which is the Pixel_QC_Flag
;print,'W1NS_PXL_QC_FLAG = ',W1NS_PXL_QC_FLAG

;close,/all

;stop

end
