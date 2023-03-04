pro read_hdf_iir_track_l2,path,FNAME          ;DPC RELEASE VERSION 3.4

;
; This is a simple read program for the CALIPSO Infrared Imaging Radiometer (IIR)
; Level 2 Track Data Products, including assignments to variables contained in the
; IIR Level 2 Track Science Common (IIR_L2_TRACK_COMMON.pro)
; The user can comment out any assignments not required for their application.
; This reader version 3.2v1 corresponds to the Data Products Catalog Release 3.4.
; The DP Catalog is available on the CALIPSO public web site:
;     http://www-calipso.larc.nasa.gov/resources/project_documentation.php
; This reader corresponds to DPC Tables 46 and 47.
;
; There are 2 string inputs to this program:
;   1) the path (i.e. 'C:\') containing the data
;   2) the filename of the IIR Level 2 Track Science HDF file to be read.
;
; Also provided is a corresponding Checkit_IIR_TRACK program to verify that all variables
;   have been read and assigned. It is called at the end of this program.
;
; May 24, 2011           (Science Systems & Applications, Inc.)  Read Software new code
; December 20, 2011      (Science Systems & Applications, Inc.)  Updated DPC version
;
; NOTE: Please modify lines in code that meet your system's requirements.

; For Unix and using the IDLDE for Mac
; Include the full path before the IIR_L2_TRACK_COMMON called routine.
; An example would be @/full/path/IIR_L2_TRACK_COMMON
; Otherwise, if routine in same working directory as main routine, full 
; path is not needed.
@IIR_L2_TRACK_COMMON

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

;TABLE 47 PARAMETERS
if var eq 'Latitude' then HDF_SD_GETDATA,sds_id,IIRT_LAT
if var eq 'Longitude' then HDF_SD_GETDATA,sds_id,IIRT_LON
if var eq 'Lidar_Shot_Time' then HDF_SD_GETDATA,sds_id,IIRT_LIDAR_SHOT_TIME
if var eq 'IIR_Image_Time_12_05' then HDF_SD_GETDATA,sds_id,IIRT_IMG_TIME_12_05
if var eq 'Brightness_Temperature_08_65' then HDF_SD_GETDATA,sds_id,IIRT_BRIGHT_TEMP_08_65
if var eq 'Brightness_Temperature_12_05' then HDF_SD_GETDATA,sds_id,IIRT_BRIGHT_TEMP_12_05
if var eq 'Brightness_Temperature_10_60' then HDF_SD_GETDATA,sds_id,IIRT_BRIGHT_TEMP_10_60
if var eq 'Effective_Emissivity_08_65' then HDF_SD_GETDATA,sds_id,IIRT_EFFECT_EMISS_08_65
if var eq 'Effective_Emissivity_12_05' then HDF_SD_GETDATA,sds_id,IIRT_EFFECT_EMISS_12_05
if var eq 'Effective_Emissivity_10_60' then HDF_SD_GETDATA,sds_id,IIRT_EFFECT_EMISS_10_60
if var eq 'Effective_Emissivity_Uncertainty_08_65' then HDF_SD_GETDATA,sds_id,IIRT_EFFECT_EMISS_UNCERT_08_65
if var eq 'Effective_Emissivity_Uncertainty_12_05' then HDF_SD_GETDATA,sds_id,IIRT_EFFECT_EMISS_UNCERT_12_05
if var eq 'Effective_Emissivity_Uncertainty_10_60' then HDF_SD_GETDATA,sds_id,IIRT_EFFECT_EMISS_UNCERT_10_60
if var eq 'Emissivity_08_65' then HDF_SD_GETDATA,sds_id,IIRT_EMISS_08_65
if var eq 'Emissivity_12_05' then HDF_SD_GETDATA,sds_id,IIRT_EMISS_12_05
if var eq 'Emissivity_10_60' then HDF_SD_GETDATA,sds_id,IIRT_EMISS_10_60
if var eq 'Emissivity_Uncertainty_08_65' then HDF_SD_GETDATA,sds_id,IIRT_EMISS_UNCERT_08_65
if var eq 'Emissivity_Uncertainty_12_05' then HDF_SD_GETDATA,sds_id,IIRT_EMISS_UNCERT_12_05
if var eq 'Emissivity_Uncertainty_10_60' then HDF_SD_GETDATA,sds_id,IIRT_EMISS_UNCERT_10_60
if var eq 'Particle_Shape_Index' then HDF_SD_GETDATA,sds_id,IIRT_PART_SHAPE_INDEX
if var eq 'Particle_Shape_Confidence' then HDF_SD_GETDATA,sds_id,IIRT_PART_SHAPE_CONFID
if var eq 'Effective_Particle_Size' then HDF_SD_GETDATA,sds_id,IIRT_EFFECT_PART_SIZE
if var eq 'Effective_Particle_Size_Uncertainty' then HDF_SD_GETDATA,sds_id,IIRT_EFFECT_PART_SIZE_UNCERT
if var eq 'Reference_Brightness_Temperature' then HDF_SD_GETDATA,sds_id,IIRT_REF_BRIGHT_TEMP
if var eq 'Blackbody_Brightness_Temperature' then HDF_SD_GETDATA,sds_id,IIRT_BLCKBDY_BRIGHT_TEMP
if var eq 'Computed_Brightness_Temperature_Surface' then HDF_SD_GETDATA,sds_id,IIRT_COMP_BRIGHT_TEMP_SURF
if var eq 'Optical_Depth_12_05' then HDF_SD_GETDATA,sds_id,IIRT_OPT_DEPTH_12_05
if var eq 'Optical_Depth_12_05_Uncertainty' then HDF_SD_GETDATA,sds_id,IIRT_OPT_DEPTH_12_05_UNCERT
if var eq 'Ice_Water_Path' then HDF_SD_GETDATA,sds_id,IIRT_ICE_WATER_PATH
if var eq 'Ice_Water_Path_Confidence' then HDF_SD_GETDATA,sds_id,IIRT_ICE_WATER_PATH_CONFID
if var eq 'Optical_Depth_0532_Upper_Level' then HDF_SD_GETDATA,sds_id,IIRT_OPT_DEPTH_0532_UP_LVL
if var eq 'Depolarization_Upper_Level' then HDF_SD_GETDATA,sds_id,IIRT_DEPOLAR_UP_LVL
if var eq 'Integrated_Backscatter_Upper_Level' then HDF_SD_GETDATA,sds_id,IIRT_INTEGRATED_BACK_UP_LVL
if var eq 'Layer_Top_Height_Upper_Level' then HDF_SD_GETDATA,sds_id,IIRT_LAY_TOP_HEIGHT_UP_LVL
if var eq 'Centroid_IAB_0532_Upper_Level' then HDF_SD_GETDATA,sds_id,IIRT_CENTROID_IAB_0532_UP_LVL
if var eq 'Layer_Bottom_Height_Upper_Level' then HDF_SD_GETDATA,sds_id,IIRT_LAY_BOT_HEIGHT_UP_LVL
if var eq 'Layer_Top_Temperature_Upper_Level' then HDF_SD_GETDATA,sds_id,IIRT_LAY_TOP_TEMP_UP_LVL
if var eq 'Temperature_Centroid_IAB_0532_Upper_Level' then HDF_SD_GETDATA,sds_id,IIRT_TEMP_CENTROID_IAB_0532_UP_LVL
if var eq 'Optical_Depth_0532_Lower_Level' then HDF_SD_GETDATA,sds_id,IIRT_OPT_DEPTH_0532_LOW_LVL
if var eq 'Depolarization_Lower_Level' then HDF_SD_GETDATA,sds_id,IIRT_DEPOLAR_LOW_LVL
if var eq 'Integrated_Backscatter_Lower_Level' then HDF_SD_GETDATA,sds_id,IIRT_INTEGRATED_BACK_LOW_LVL
if var eq 'Layer_Top_Height_Lower_Level' then HDF_SD_GETDATA,sds_id,IIRT_LAY_TOP_HEIGHT_LOW_LVL
if var eq 'Centroid_IAB_0532_Lower_Level' then HDF_SD_GETDATA,sds_id,IIRT_CENTROID_IAB_0532_LOW_LVL
if var eq 'Layer_Bottom_Height_Lower_Level' then HDF_SD_GETDATA,sds_id,IIRT_LAY_BOT_HEIGHT_LOW_LVL
if var eq 'Layer_Top_Temperature_Lower_Level' then HDF_SD_GETDATA,sds_id,IIRT_LAY_TOP_TEMP_LOW_LVL
if var eq 'Temperature_Centroid_IAB_0532_Lower_Level' then HDF_SD_GETDATA,sds_id,IIRT_TEMP_CENTROID_IAB_0532_LOW_LVL
if var eq 'Surface_Emissivity_08_65' then HDF_SD_GETDATA,sds_id,IIRT_SURF_EMISS_08_65
if var eq 'Surface_Emissivity_12_05' then HDF_SD_GETDATA,sds_id,IIRT_SURF_EMISS_12_05
if var eq 'Surface_Emissivity_10_60' then HDF_SD_GETDATA,sds_id,IIRT_SURF_EMISS_10_60
if var eq 'IIR_Data_Quality_Flag' then HDF_SD_GETDATA,sds_id,IIRT_IIR_DATA_QUALITY_FLAG
if var eq 'LIDAR_Data_Quality_Flag' then HDF_SD_GETDATA,sds_id,IIRT_LIDAR_DATA_QUALITY_FLAG
if var eq 'Type_of_Scene' then HDF_SD_GETDATA,sds_id,IIRT_TYPE_OF_SCENE
if var eq 'Surrounding_Obs_Quality_Flag' then HDF_SD_GETDATA,sds_id,IIRT_SURROUND_OBS_QUALITY_FLAG
if var eq 'High_Cloud_vs_Background_Flag' then HDF_SD_GETDATA,sds_id,IIRT_HIGH_CLD_VS_BACK_FLAG
if var eq 'Computed_vs_Observed_Background_Flag' then HDF_SD_GETDATA,sds_id,IIRT_COMP_VS_OBS_BACK_FLAG
if var eq 'Regional_Background_Std_Dev_Flag' then HDF_SD_GETDATA,sds_id,IIRT_REG_BACK_STD_DEV_FLAG
if var eq 'Multi_Layer_Cloud_Flag' then HDF_SD_GETDATA,sds_id,IIRT_MULTI_LAY_CLOUD_FLAG
if var eq 'Microphysics' then HDF_SD_GETDATA,sds_id,IIRT_MICROPHYSICS

HDF_SD_ENDACCESS,sds_id

endfor

HDF_SD_END,SDinterface_id

;Retrieve the Vdata information
vds_id = HDF_VD_LONE(fid)
vdata_id=HDF_VD_ATTACH(fid,vds_id,/read)

HDF_VD_GET,vdata_id,name=var,count=cnt,fields=flds,size=sze,nfields=nflds


;TABLE 46 PARAMETERS - METADATA

nrec = HDF_VD_READ(vdata_id,IIRT_PROD_ID,fields='Product_ID')
nrec = HDF_VD_READ(vdata_id,IIRT_DAT_TIM_START,fields='Date_Time_at_Granule_Start')
nrec = HDF_VD_READ(vdata_id,IIRT_DAT_TIM_END,fields='Date_Time_at_Granule_End')
nrec = HDF_VD_READ(vdata_id,IIRT_DAT_TIM_PROD,fields='Date_Time_of_Production')
nrec = HDF_VD_READ(vdata_id,IIRT_INIT_SCAN_LAT,fields='Initial_IIR_Scan_Center_Latitude')
nrec = HDF_VD_READ(vdata_id,IIRT_INIT_SCAN_LON,fields='Initial_IIR_Scan_Center_Longitude')
nrec = HDF_VD_READ(vdata_id,IIRT_END_SCAN_LAT,fields='Ending_IIR_Scan_Center_Latitude')
nrec = HDF_VD_READ(vdata_id,IIRT_END_SCAN_LON,fields='Ending_IIR_Scan_Center_Longitude')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_RECS,fields='Number_of_IIR_Records_in_File')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_VAL_08_65_PIXS,fields='Number_of_Valid_08_65_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_VAL_12_05_PIXS,fields='Number_of_Valid_12_05_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_VAL_10_60_PIXS,fields='Number_of_Valid_10_60_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_INVAL_08_65_PIXS,fields='Number_of_Invalid_08_65_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_INVAL_12_05_PIXS,fields='Number_of_Invalid_12_05_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_INVAL_10_60_PIXS,fields='Number_of_Invalid_10_60_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_REJECT_08_65_PIXS,fields='Number_of_Rejected_08_65_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_REJECT_12_05_PIXS,fields='Number_of_Rejected_12_05_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_REJECT_10_60_PIXS,fields='Number_of_Rejected_10_60_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_REJECT_08_65_PIXS_LOC,fields='Number_of_Rejected_08_65_Pixels_Location')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_REJECT_12_05_PIXS_LOC,fields='Number_of_Rejected_12_05_Pixels_Location')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_REJECT_10_60_PIXS_LOC,fields='Number_of_Rejected_10_60_Pixels_Location')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_REJECT_08_65_PIXS_RAD,fields='Number_of_Rejected_08_65_Pixels_Radiance')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_REJECT_12_05_PIXS_RAD,fields='Number_of_Rejected_12_05_Pixels_Radiance')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_REJECT_10_60_PIXS_RAD,fields='Number_of_Rejected_10_60_Pixels_Radiance')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_08_65_RAD_ALL,fields='Mean_08_65_Radiance_All')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_12_05_RAD_ALL,fields='Mean_12_05_Radiance_All')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_10_60_RAD_ALL,fields='Mean_10_60_Radiance_All')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_08_65_RAD_SEL_CASES,fields='Mean_08_65_Radiance_Selected_Cases')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_12_05_RAD_SEL_CASES,fields='Mean_12_05_Radiance_Selected_Cases')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_10_60_RAD_SEL_CASES,fields='Mean_10_60_Radiance_Selected_Cases')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_08_65_BRIGHT_TEMP_ALL,fields='Mean_08_65_Brightness_Temp_All')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_12_05_BRIGHT_TEMP_ALL,fields='Mean_12_05_Brightness_Temp_All')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_10_60_BRIGHT_TEMP_ALL,fields='Mean_10_60_Brightness_Temp_All')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_08_65_BRIGHT_TEMP_SEL_CASES,fields='Mean_08_65_Brightness_Temp_Selected_Cases')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_12_05_BRIGHT_TEMP_SEL_CASES,fields='Mean_12_05_Brightness_Temp_Selected_Cases')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_10_60_BRIGHT_TEMP_SEL_CASES,fields='Mean_10_60_Brightness_Temp_Selected_Cases')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_VALID_LIDAR_PIX,fields='Number_of_Valid_LIDAR_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_INVALID_LIDAR_PIX,fields='Number_of_Invalid_LIDAR_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_REJECTED_LIDAR_PIX,fields='Number_of_Rejected_LIDAR_Pixels')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_IDENT_PIX_UP_LEVEL,fields='Number_of_Identified_Pixels_Upper_Level')
nrec = HDF_VD_READ(vdata_id,IIRT_PERCENT_IDENT_PIX_UP_LEVEL,fields='Percent_of_Identified_Pixels_Upper_Level')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_IDENT_PIX_LOW_LEVEL,fields='Number_of_Identified_Pixels_Lower_Level')
nrec = HDF_VD_READ(vdata_id,IIRT_PERCENT_IDENT_PIX_LOW_LEVEL,fields='Percent_of_Identified_Pixels_Lower_Level')
nrec = HDF_VD_READ(vdata_id,IIRT_NUM_IDENT_PIX_CLEAR_SKY,fields='Number_of_Identified_Pixels_Clear_Sky')
nrec = HDF_VD_READ(vdata_id,IIRT_PERCENT_IDENT_PIX_CLEAR_SKY,fields='Percent_of_Identified_Pixels_Clear_Sky')
nrec = HDF_VD_READ(vdata_id,IIRT_MEAN_ALT_UP_LEVEL,fields='Mean_Altitude_Upper_Level')
nrec = HDF_VD_READ(vdata_id,IIRT_GEOS_VERS,fields='GEOS_Version')


HDF_VD_DETACH,vdata_id

HDF_CLOSE,fid

; For Unix and using IDLDE for Mac
; Include the full path before the Checkit_IIR_TRACK called routine.
; An example would be
; @/full/path/Checkit_IIR_TRACK
; Otherwise, if routine in same working directory as main routine, full
; path is not needed.
@Checkit_IIR_TRACK.pro

; Below are examples of printing out the parameters from a data file.

; The print statement below prints out the file name which is: FNAME, the
; IIRT_PROD_ID which is the Product_ID, and the IIRT_DAT_TIM_PROD which is the Date_Time_of_Production.
product_id = string(IIRT_PROD_ID)
iirprodtim = string(IIRT_DAT_TIM_PROD)
print,FNAME,'     ',product_id,'     ',iirprodtim

; The print statement below prints out the IIRT_MICROPHYSICS which is the Microphysics.
print,'IIRT_MICROPHYSICS = ',IIRT_MICROPHYSICS

;close,/all

;stop

end
