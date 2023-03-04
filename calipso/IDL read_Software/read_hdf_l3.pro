pro read_hdf_L3,path,FNAME                 ;DPC RELEASE VERSION 3.4
;
; This is a simple read program for the CALIPSO Lidar Level 3
; Data Products, including assignments to variables contained in the
; Lidar Level 3 Common (L3_COMMON.pro)
; The user can comment out any assignments not required for their application.
; This Reader Version 3.2v1 corresponds to the Data Products Catalog Release 3.4.
; The DP Catalog is available on the CALIPSO public web site:
;     http://www-calipso.larc.nasa.gov/resources/project_documentation.php
; This reader corresponds to DPC Tables 52 thru 61.
;
; There are 2 string inputs to this program:
;   1) the path (i.e. 'C:\') containing the data
;   2) the filename of the Lidar Level 3 HDF file to be read.
;
; Also provided is a corresponding Checkit_L3 program to verify that all variables
; have been read and assigned. It is called at the end of this program.
;
; December 20, 2011  Science Systems & Applications, Inc.          Data Release
;
; NOTE: Please modify lines in code that meet your system's requirements.

; For Unix and using IDLDE for Mac
; Include the full path before the L1_COMMON called routine.
; An example would be  @/full/path/L1_COMMON
; Otherwise, if routine in same working directory as main routine, full
; path is not needed.
@L3_COMMON

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


;TABLE 53 PARAMETERS - Spatial Coordinates
if var eq 'Longitude_Midpoint' then HDF_SD_GETDATA,sds_id,L3_LON_MID
if var eq 'Latitude_Midpoint' then HDF_SD_GETDATA,sds_id,L3_LAT_MID
if var eq 'Altitude_Midpoint' then HDF_SD_GETDATA,sds_id,L3_ALT_MID

;TABLE 54 PARAMETERS - Meteorological Context
if var eq 'Pressure_Mean' then HDF_SD_GETDATA,sds_id,L3_PRES_MEAN
if var eq 'Pressure_Standard_Deviation' then HDF_SD_GETDATA,sds_id,L3_PRES_STAN_DEV
if var eq 'Temperature_Mean' then HDF_SD_GETDATA,sds_id,L3_TEMP_MEAN
if var eq 'Temperature_Standard_Deviation' then HDF_SD_GETDATA,sds_id,L3_TEMP_STAN_DEV
if var eq 'Relative_Humidity_Mean' then HDF_SD_GETDATA,sds_id,L3_REL_HUMID_MEAN
if var eq 'Relative_Humidity_Standard_Deviation' then HDF_SD_GETDATA,sds_id,L3_REL_HUMID_STAN_DEV
if var eq 'Tropopause_Height_Minimum' then HDF_SD_GETDATA,sds_id,L3_TROP_HEIGHT_MIN 
if var eq 'Tropopause_Height_Maximum' then HDF_SD_GETDATA,sds_id,L3_TROP_HEIGHT_MAX
if var eq 'Tropopause_Height_Median' then HDF_SD_GETDATA,sds_id,L3_TROP_HEIGHT_MED
if var eq 'Tropopause_Height_Mean' then HDF_SD_GETDATA,sds_id,L3_TROP_HEIGHT_MEAN
if var eq 'Tropopause_Height_Standard_Deviation' then HDF_SD_GETDATA,sds_id,L3_TROP_HEIGHT_STAN_DEV
if var eq 'Meteorological_Profiles_Averaged' then HDF_SD_GETDATA,sds_id,L3_MET_PROF_AVG

;TABLE 55 PARAMETERS - Surface and Overflight Parameters
if var eq 'Surface_Elevation_Minimum' then HDF_SD_GETDATA,sds_id,L3_SURF_ELEV_MIN
if var eq 'Surface_Elevation_Maximum' then HDF_SD_GETDATA,sds_id,L3_SURF_ELEV_MAX
if var eq 'Surface_Elevation_Median' then HDF_SD_GETDATA,sds_id,L3_SURF_ELEV_MED
if var eq 'Land_Samples' then HDF_SD_GETDATA,sds_id,L3_LAND_SAMP
if var eq 'Water_Samples' then HDF_SD_GETDATA,sds_id,L3_WAT_SAMP
if var eq 'Days_Of_Month_Observed' then HDF_SD_GETDATA,sds_id,L3_DAYS_MON_OBS

;TABLE 56 PARAMETERS - Static Lidar Parameters
if var eq 'Initial_Aerosol_Lidar_Ratio_532' then HDF_SD_GETDATA,sds_id,L3_INIT_AERO_LID_RATIO_532
if var eq 'Initial_Aerosol_Lidar_Ratio_Uncertainty_532' then HDF_SD_GETDATA,sds_id,L3_INIT_AERO_LID_RATIO_UNCERT_532

;TABLE 57 PARAMETERS - Aerosol Optical Properties - All Species
if var eq 'Extinction_532_Mean' then HDF_SD_GETDATA,sds_id,L3_EXT_532_MEAN
if var eq 'Extinction_532_Standard_Deviation' then HDF_SD_GETDATA,sds_id,L3_EXT_532_STAN_DEV
if var eq 'Extinction_532_Median' then HDF_SD_GETDATA,sds_id,L3_EXT_532_MED
if var eq 'Extinction_532_Skew' then HDF_SD_GETDATA,sds_id,L3_EXT_532_SKEW
if var eq 'Extinction_532_RMS' then HDF_SD_GETDATA,sds_id,L3_EXT_532_RMS
if var eq 'Extinction_532_Percentiles' then HDF_SD_GETDATA,sds_id,L3_EXT_532_PERC
if var eq 'Samples_Searched' then HDF_SD_GETDATA,sds_id,L3_SAMP_SEARCH
if var eq 'Samples_Aerosol_Detected_Accepted' then HDF_SD_GETDATA,sds_id,L3_SAMP_AERO_DET_ACCEPT
if var eq 'Samples_Aerosol_Detected_Rejected' then HDF_SD_GETDATA,sds_id,L3_SAMP_AERO_DET_REJECT
if var eq 'Samples_Cloud_Detected' then HDF_SD_GETDATA,sds_id,L3_SAMP_CLD_DET
if var eq 'Samples_Averaged' then HDF_SD_GETDATA,sds_id,L3_SAMP_AVG
if var eq 'AOD_Cloud_Free_Mean' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_MEAN
if var eq 'AOD_Cloud_Free_Standard_Deviation' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_STAN_DEV
if var eq 'AOD_Cloud_Free_Median' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_MED
if var eq 'AOD_Cloud_Free_Skew' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_SKEW
if var eq 'AOD_Cloud_Free_RMS' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_RMS
if var eq 'AOD_Cloud_Free_Percentiles' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_PERC
if var eq 'AOD_Above_Cloud_Mean' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_MEAN
if var eq 'AOD_Above_Cloud_Standard_Deviation' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_STAN_DEV
if var eq 'AOD_Above_Cloud_Median' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_MED
if var eq 'AOD_Above_Cloud_Skew' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_SKEW
if var eq 'AOD_Above_Cloud_RMS' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_RMS
if var eq 'AOD_Above_Cloud_Percentiles' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_PERC
if var eq 'AOD_Combined_Mean' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_MEAN
if var eq 'AOD_Combined_Standard_Deviation' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_STAN_DEV
if var eq 'AOD_Combined_Median' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_MED
if var eq 'AOD_Combined_Skew' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_SKEW
if var eq 'AOD_Combined_RMS' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_RMS
if var eq 'AOD_Combined_Percentiles' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_PERC
if var eq 'AOD_All_Sky_Mean' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_MEAN
if var eq 'AOD_All_Sky_Standard_Deviation' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_STAN_DEV
if var eq 'AOD_All_Sky_Median' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_MED
if var eq 'AOD_All_Sky_Skew' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_SKEW
if var eq 'AOD_All_Sky_RMS' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_RMS
if var eq 'AOD_All_Sky_Percentiles' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_PERC

;TABLE 58 PARAMETERS - Aerosol Optical Properties - Dust Only
if var eq 'Extinction_532_Mean_Dust' then HDF_SD_GETDATA,sds_id,L3_EXT_532_MEAN_DUST
if var eq 'Extinction_532_Standard_Deviation_Dust' then HDF_SD_GETDATA,sds_id,L3_EXT_532_STAN_DEV_DUST
if var eq 'Extinction_532_Median_Dust' then HDF_SD_GETDATA,sds_id,L3_EXT_532_MED_DUST
if var eq 'Extinction_532_Skew_Dust' then HDF_SD_GETDATA,sds_id,L3_EXT_532_SKEW_DUST
if var eq 'Extinction_532_RMS_Dust' then HDF_SD_GETDATA,sds_id,L3_EXT_532_RMS_DUST
if var eq 'Extinction_532_Percentiles_Dust' then HDF_SD_GETDATA,sds_id,L3_EXT_532_PERC_DUST
if var eq 'Samples_Aerosol_Detected_Accepted_Dust' then HDF_SD_GETDATA,sds_id,L3_SAMP_AERO_DET_ACCEPT_DUST
if var eq 'Samples_Aerosol_Detected_Rejected_Dust' then HDF_SD_GETDATA,sds_id,L3_SAMP_AERO_DET_REJECT_DUST
if var eq 'Samples_Averaged_Dust' then HDF_SD_GETDATA,sds_id,L3_SAMP_AVG_DUST
if var eq 'AOD_Cloud_Free_Mean_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_MEAN_DUST
if var eq 'AOD_Cloud_Free_Standard_Deviation_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_STAN_DEV_DUST
if var eq 'AOD_Cloud_Free_Median_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_MED_DUST
if var eq 'AOD_Cloud_Free_Skew_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_SKEW_DUST
if var eq 'AOD_Cloud_Free_RMS_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_RMS_DUST
if var eq 'AOD_Cloud_Free_Percentiles_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_CLD_FREE_PERC_DUST
if var eq 'AOD_Above_Cloud_Mean_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_MEAN_DUST
if var eq 'AOD_Above_Cloud_Standard_Deviation_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_STAN_DEV_DUST
if var eq 'AOD_Above_Cloud_Median_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_MED_DUST
if var eq 'AOD_Above_Cloud_Skew_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_SKEW_DUST
if var eq 'AOD_Above_Cloud_RMS_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_RMS_DUST
if var eq 'AOD_Above_Cloud_Percentiles_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ABV_CLD_PERC_DUST
if var eq 'AOD_Combined_Mean_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_MEAN_DUST
if var eq 'AOD_Combined_Standard_Deviation_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_STAN_DEV_DUST
if var eq 'AOD_Combined_Median_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_MED_DUST
if var eq 'AOD_Combined_Skew_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_SKEW_DUST
if var eq 'AOD_Combined_RMS_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_RMS_DUST
if var eq 'AOD_Combined_Percentiles_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_COMB_PERC_DUST
if var eq 'AOD_All_Sky_Mean_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_MEAN_DUST
if var eq 'AOD_All_Sky_Standard_Deviation_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_STAN_DEV_DUST
if var eq 'AOD_All_Sky_Median_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_MED_DUST
if var eq 'AOD_All_Sky_Skew_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_SKEW_DUST
if var eq 'AOD_All_Sky_RMS_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_RMS_DUST
if var eq 'AOD_All_Sky_Percentiles_Dust' then HDF_SD_GETDATA,sds_id,L3_AOD_ALLSKY_PERC_DUST

;TABLE 59 PARAMETERS - Aerosol Type Distribution
if var eq 'Aerosol_Type' then HDF_SD_GETDATA,sds_id,L3_AERO_TYPE
if var eq 'Multiple_Aerosol_Type_Count' then HDF_SD_GETDATA,sds_id,L3_MULT_AERO_TYPE_COUNT

;TABLE 60 PARAMETERS - Aerosol Spatial Distribution - All Species
if var eq 'Number_Layers_Per_Column' then HDF_SD_GETDATA,sds_id,L3_NUM_LAY_PER_COL
if var eq 'Highest_Aerosol_Layer_Detected' then HDF_SD_GETDATA,sds_id,L3_HIGH_AERO_LAY_DET
if var eq 'Lowest_Aerosol_Layer_Detected' then HDF_SD_GETDATA,sds_id,L3_LOW_AERO_LAY_DET
if var eq 'Layer_Separation_Minimum' then HDF_SD_GETDATA,sds_id,L3_LAY_SEP_MIN
if var eq 'Layer_Separation_Maximum' then HDF_SD_GETDATA,sds_id,L3_LAY_SEP_MAX
if var eq 'Layer_Separation_Median' then HDF_SD_GETDATA,sds_id,L3_LAY_SEP_MED
if var eq 'Layer_Separation_Mean' then HDF_SD_GETDATA,sds_id,L3_LAY_SEP_MEAN
if var eq 'Layer_Separation_Standard_Deviation' then HDF_SD_GETDATA,sds_id,L3_LAY_SEP_STAN_DEV

;TABLE 61 PARAMETERS - Aerosol Spatial Distribution - Dust Only
if var eq 'Number_Layers_Per_Column_Dust' then HDF_SD_GETDATA,sds_id,L3_NUM_LAY_PER_COL_DUST
if var eq 'Highest_Aerosol_Layer_Detected_Dust' then HDF_SD_GETDATA,sds_id,L3_HIGH_AERO_LAY_DET_DUST
if var eq 'Lowest_Aerosol_Layer_Detected_Dust' then HDF_SD_GETDATA,sds_id,L3_LOW_AERO_LAY_DET_DUST
if var eq 'Layer_Separation_Minimum_Dust' then HDF_SD_GETDATA,sds_id,L3_LAY_SEP_MIN_DUST
if var eq 'Layer_Separation_Maximum_Dust' then HDF_SD_GETDATA,sds_id,L3_LAY_SEP_MAX_DUST
if var eq 'Layer_Separation_Median_Dust' then HDF_SD_GETDATA,sds_id,L3_LAY_SEP_MED_DUST
if var eq 'Layer_Separation_Mean_Dust' then HDF_SD_GETDATA,sds_id,L3_LAY_SEP_MEAN_DUST
if var eq 'Layer_Separation_Standard_Deviation_Dust' then HDF_SD_GETDATA,sds_id,L3_LAY_SEP_STAN_DEV_DUST


HDF_SD_ENDACCESS,sds_id

endfor

HDF_SD_END,SDinterface_id

;Retrieve the Vdata information
vds_id = HDF_VD_LONE(fid)
vdata_id=HDF_VD_ATTACH(fid,vds_id,/read)

HDF_VD_GET,vdata_id,name=var,count=cnt,fields=flds,size=sze,nfields=nflds
print,flds

; TABLE 52 Metadata Descriptions
nrec= HDF_VD_READ(vdata_id,L3_PROD_ID,fields='Product_ID')
nrec= HDF_VD_READ(vdata_id,L3_DATE,fields='Nominal_Year_Month')
nrec= HDF_VD_READ(vdata_id,L3_NUM_L2_FILE_ANALYZ,fields='Number_of_Level2_Files_Analyzed')
nrec= HDF_VD_READ(vdata_id,L3_EARL_INPUT_FILE,fields='Earliest_Input_Filename')
nrec= HDF_VD_READ(vdata_id,L3_LAST_INPUT_FILE,fields='Latest_Input_Filename')
nrec= HDF_VD_READ(vdata_id,L3_SCREEN_NAME,fields='Data_Screening_Script_Filename')
nrec= HDF_VD_READ(vdata_id,L3_SCREEN_CONTENTS,fields='Data_Screening_Script_File_Contents')

HDF_VD_DETACH,vdata_id

HDF_CLOSE,fid

; For Unix and using IDLDE for Mac
; Include the full path before the CheckitL1 called routine.
; An example would be
; @/full/path/Checkit_L3
; Otherwise, if routine in same working directory as main routine, full
; path is not needed.
@Checkit_L3

; Below are two examples of printing out the parameters from a data file.

; The print statement below prints out the file name whic is: FNAME, the
; L1_PROD_ID which is: Product_ID, and the L1_DAT_TIM_PROD which is the Date_Time_of_Production.
product_id = string(L3_PROD_ID)
datemonth = string(L3_DATE)
numl2 = string(L3_NUM_L2_FILE_ANALYZ)
ffinput = string(L3_EARL_INPUT_FILE)
llinput = string(L3_LAST_INPUT_FILE)
screenname = string(L3_SCREEN_NAME)
screencontents = string(L3_SCREEN_CONTENTS)
print,FNAME,'product_id=     ',product_id
print,FNAME,'datemonth=     ',datemonth
print,FNAME,'numl2=     ',numl2
print,FNAME,'ffinput=     ',ffinput
print,FNAME,'llinput=     ',llinput
print,FNAME,'screenname=     ',screenname
print,FNAME,'screencontents=     ',screencontents

; The print statement below prints out the L3_AERO_TYPE which is: Aerosol_Type
print,'L3_AERO_TYPE = ',L3_AERO_TYPE

;close,/all

;stop

end
