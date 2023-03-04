pro read_hdf_L15,path,FNAME                 ;DPC RELEASE VERSION 3.4
;
; This is a simple read program for the CALIPSO Lidar Level 1.5
; Data Products, including assignments to variables contained in the
; Lidar Level 1.5 Common (L15_COMMON.pro)
; The user can comment out any assignments not required for their application.
; This Reader Version 3.2v1 corresponds to the Data Products Catalog Release 3.4.
; The DP Catalog is available on the CALIPSO public web site:
;     http://www-calipso.larc.nasa.gov/resources/project_documentation.php
; This reader corresponds to DPC Tables 88, 89, and 90.
;
; There are 2 string inputs to this program:
;   1) the path (i.e. 'C:\') containing the data
;   2) the filename of the Lidar Level 1 HDF file to be read.
;
; Also provided is a corresponding Checkit_L15 program to verify that all variables
; have been read and assigned. It is called at the end of this program.
;
;
; May 31, 2011        Science Systems & Applications, Inc.          Data Release
; December 20, 2011   Science Systems & Applications, Inc.          DPC version update
;
; NOTE: Please modify lines in code that meet your system's requirements.

; For Unix and using IDLDE for Mac
; Include the full path before the L15_COMMON called routine.
; An example would be  @/full/path/L15_COMMON
; Otherwise, if routine in same working directory as main routine, full
; path is not needed.
@L15_COMMON

dsets=0
attrs=0

; Uncomment/comment out the correct lines to ensure that the
; paths are interpreted correctly for computer system.

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


;TABLE 90 PARAMETERS - Lidar Profile Science Record

if var eq 'Latitude' then HDF_SD_GETDATA,sds_id,L15_LAT
if var eq 'Longitude' then HDF_SD_GETDATA,sds_id,L15_LON
if var eq 'Profile_Time' then HDF_SD_GETDATA,sds_id,L15_PROF_TIME
if var eq 'Profile_UTC_Time' then HDF_SD_GETDATA,sds_id,L15_PROF_UTC
if var eq 'Profile_ID' then HDF_SD_GETDATA,sds_id,L15_PROF_ID
if var eq 'Day_Night_Flag' then HDF_SD_GETDATA,sds_id,L15_DN_FLAG
if var eq 'Surface_Elevation_Mean' then HDF_SD_GETDATA,sds_id,L15_SURF_ELEV_MEAN
if var eq 'Surface_Elevation_StDev' then HDF_SD_GETDATA,sds_id,L15_SURF_ELEV_STDEV
if var eq 'Samples_Averaged' then HDF_SD_GETDATA,sds_id,L15_SAMP_AVG
if var eq 'Calibration_Constant_Parallel_532' then HDF_SD_GETDATA,sds_id,L15_CAL_CNST_PAR_532
if var eq 'Calibration_Constant_Parallel_Uncertainty_532' then HDF_SD_GETDATA,sds_id,L15_CAL_CNST_532_PAR_UNC
if var eq 'Total_Attenuated_Backscatter_532_Mean' then HDF_SD_GETDATA,sds_id,L15_TOT_BKS_532_MEAN
if var eq 'Total_Attenuated_Backscatter_532_Median' then HDF_SD_GETDATA,sds_id,L15_TOT_BKS_532_MEDIAN
if var eq 'Total_Attenuated_Backscatter_532_StDev' then HDF_SD_GETDATA,sds_id,L15_TOT_BKS_532_STDEV
if var eq 'Total_Attenuated_Backscatter_Uncertaninty_532' then HDF_SD_GETDATA,sds_id,L15_TOT_BKS_UNC_532
if var eq 'Extinction_Coefficient_532_Mean' then HDF_SD_GETDATA,sds_id,L15_EXTINCT_COEFF_532_MEAN
if var eq 'Extinction_Coefficient_532_Median' then HDF_SD_GETDATA,sds_id,L15_EXTINCT_COEFF_532_MEDIAN
if var eq 'Extinction_Coefficient_532_StDev' then HDF_SD_GETDATA,sds_id,L15_EXTINCT_COEFF_532_STDEV
if var eq 'Extinction_Coefficient_Uncertainty_532' then HDF_SD_GETDATA,sds_id,L15_EXTINCT_COEFF_UNC_532
if var eq 'Calibration_Constant_Perpendicular_532' then HDF_SD_GETDATA,sds_id,L15_CAL_CNST_PER_532
if var eq 'Calibration_Constant_Perpendicular_Uncertainty_532' then HDF_SD_GETDATA,sds_id,L15_CAL_CNST_PER_532_UNC
if var eq 'Perpendicular_Attenuated_Backscatter_532_Mean' then HDF_SD_GETDATA,sds_id,L15_PER_BKS_532_MEAN
if var eq 'Perpendicular_Attenuated_Backscatter_532_Median' then HDF_SD_GETDATA,sds_id,L15_PER_BKS_532_MEDIAN
if var eq 'Perpendicular_Attenuated_Backscatter_532_StDev' then HDF_SD_GETDATA,sds_id,L15_PER_BKS_532_STDEV
if var eq 'Perpendicular_Attenuated_Backscatter_Uncertaninty_532' then HDF_SD_GETDATA,sds_id,L15_PER_BKS_UNC_532
if var eq 'Molecular_Number_Density' then HDF_SD_GETDATA,sds_id,L15_MOL_NUM_DEN
if var eq 'Ozone_Number_Density' then HDF_SD_GETDATA,sds_id,L15_OZ_NUM_DEN
if var eq 'Molecular_Model_Attenuated_Backscatter_532' then HDF_SD_GETDATA,sds_id,L15_MOL_MOD_ATT_BKS_532
if var eq 'Temperature' then HDF_SD_GETDATA,sds_id,L15_TEMP
if var eq 'Pressure' then HDF_SD_GETDATA,sds_id,L15_PRESS
if var eq 'L2_Feature_Type' then HDF_SD_GETDATA,sds_id,L15_L2_FEATURE_TYPE


;TABLE 89 PARAMETERS - Static Lidar Data

if var eq 'Lidar_Data_Altitudes' then HDF_SD_GETDATA,sds_id,L15_LID_DATA_ALT
if var eq 'Initial_Lidar_Ratio_Aerosols_532' then HDF_SD_GETDATA,sds_id,L15_INIT_LID_RATIO_AER_532
if var eq 'Initial_Lidar_Ratio_Aerosols_1064' then HDF_SD_GETDATA,sds_id,L15_INIT_LID_RATIO_AER_1064
if var eq 'Rayleigh_Extinction_Cross-section_532' then HDF_SD_GETDATA,sds_id,L15_RAY_EXTINCT_CROSS_532
if var eq 'Rayleigh_Extinction_Cross-section_1064' then HDF_SD_GETDATA,sds_id,L15_RAY_EXTINCT_CROSS_1064
if var eq 'Rayleigh_Backscatter_Cross-section_532' then HDF_SD_GETDATA,sds_id,L15_RAY_BACK_CROSS_532
if var eq 'Rayleigh_Backscatter_Cross-section_1064' then HDF_SD_GETDATA,sds_id,L15_RAY_BACK_CROSS_1064
if var eq 'Ozone_Absorption_Cross-section_532' then HDF_SD_GETDATA,sds_id,L15_OZONE_ABS_CROSS_532
if var eq 'Ozone_Absorption_Cross-section_1064' then HDF_SD_GETDATA,sds_id,L15_OZONE_ABS_CROSS_1064

HDF_SD_ENDACCESS,sds_id

endfor

HDF_SD_END,SDinterface_id

XX = SIZE(L15_PROF_TIME)                    ;Determine Number of Data Records
L15_NUM_RECS = XX(2)

;Retrieve the Vdata information
vds_id = HDF_VD_LONE(fid)
vdata_id=HDF_VD_ATTACH(fid,vds_id,/read)

HDF_VD_GET,vdata_id,name=var,count=cnt,fields=flds,size=sze,nfields=nflds
print,flds

;TABLE 88 PARAMETERS

nrec = HDF_VD_READ(vdata_id,L15_PROD_ID,fields='Product_ID')
nrec = HDF_VD_READ(vdata_id,L15_DAT_TIM_START,fields='Date_Time_at_Granule_Start')
nrec = HDF_VD_READ(vdata_id,L15_DAT_TIM_END,fields='Date_Time_at_Granule_End')
nrec = HDF_VD_READ(vdata_id,L15_DAT_TIM_PROD,fields='Date_Time_of_Production')
nrec = HDF_VD_READ(vdata_id,L15_INIT_SUBSAT_LAT,fields='Initial_Subsatellite_Latitude')
nrec = HDF_VD_READ(vdata_id,L15_INIT_SUBSAT_LON,fields='Initial_Subsatellite_Longitude')
nrec = HDF_VD_READ(vdata_id,L15_FINAL_SUBSAT_LAT,fields='Final_Subsatellite_Latitude')
nrec = HDF_VD_READ(vdata_id,L15_FINAL_SUBSAT_LON,fields='Final_Subsatellite_Longitude')
nrec = HDF_VD_READ(vdata_id,L15_ORB_GRN_STRT,fields='Orbit_Number_at_Granule_Start')
nrec = HDF_VD_READ(vdata_id,L15_ORB_GRN_END,fields='Orbit_Number_at_Granule_End')
nrec = HDF_VD_READ(vdata_id,L15_ORB_CHNG_TIM,fields='Orbit_Number_Change_Time')
nrec = HDF_VD_READ(vdata_id,L15_PATH_NUM_GRN_STRT,fields='Path_Number_at_Granule_Start')
nrec = HDF_VD_READ(vdata_id,L15_PATH_NUM_GRN_END,fields='Path_Number_at_Granule_End')
nrec = HDF_VD_READ(vdata_id,L15_PATH_NUM_CHNG_TIM,fields='Path_Number_Change_Time')
nrec = HDF_VD_READ(vdata_id,L15_GEOS_VER,fields='GEOS_Version')
nrec = HDF_VD_READ(vdata_id,L15_L1_FILENAME,fields='Level1_Filename')
nrec = HDF_VD_READ(vdata_id,L15_L2_VFM_FILENAME,fields='Level2_VFM_Filename')
nrec = HDF_VD_READ(vdata_id,L15_L2_APRO_FILENAME,fields='Level2_APro_Filename')


HDF_VD_DETACH,vdata_id

HDF_CLOSE,fid

; For Unix and using IDLDE for Mac
; Include the full path before the CheckitL1 called routine.
; An example would be
; @/full/path/Checkit_L15
; Otherwise, if routine in same working directory as main routine, full
; path is not needed.
@Checkit_L15

; Below are examples of printing out the parameters from a data file.

; The print statement below prints out the file name whic is: FNAME, the
; L15_PROD_ID which is: Product_ID, and the L15_DAT_TIM_PROD which is the Date_Time_of_Production.
product_id = string(L15_PROD_ID)
datetimeproduction = string(L15_DAT_TIM_PROD)
print,FNAME,'     ',product_id,'    ',datetimeproduction

; The print statement below prints out the L15_OZONE_ABS_CROSS_1064 which is: Ozone Absorption Cross-section 1064
;print,'L15_OZONE_ABS_CROSS_532 = ',L15_OZONE_ABS_CROSS_532

; The print statement below prints out the L15_L2_FEATURE_TYPE which is: 3D Level 2 Feature Type
print,'L15_L2_FEATURE_TYPE = ',L15_L2_FEATURE_TYPE

;close,/all

;stop

end
