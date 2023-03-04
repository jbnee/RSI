PRO parlist

;TABLE 10 PARAMETRS

if var eq 'Profile_Time' then HDF_SD_GETDATA,sds_id,L1_PROF_TIME
if var eq 'Profile_UTC_Time' then HDF_SD_GETDATA,sds_id,L1_PROF_UTC
if var eq 'Profile_ID' then HDF_SD_GETDATA,sds_id,L1_PROF_ID
if var eq 'Land_Water_Mask' then HDF_SD_GETDATA,sds_id,L1_LW_MASK
if var eq 'IGBP_Surface_Type' then HDF_SD_GETDATA,sds_id,L1_IGBP_TYPE
if var eq 'NSIDC_Surface_Type' then HDF_SD_GETDATA,sds_id,L1_NSIDC_TYPE
if var eq 'Day_Night_Flag' then HDF_SD_GETDATA,sds_id,L1_DN_FLAG
if var eq 'Frame_Number' then HDF_SD_GETDATA,sds_id,L1_FRM_NUM
if var eq 'Lidar_Mode' then HDF_SD_GETDATA,sds_id,L1_LID_MD
if var eq 'Lidar_Submode' then HDF_SD_GETDATA,sds_id,L1_LID_SBMD
if var eq 'Surface_Elevation' then HDF_SD_GETDATA,sds_id,L1_SURF_ELEV
if var eq 'Laser_Energy_532' then HDF_SD_GETDATA,sds_id,L1_LAS_EN_532
if var eq 'Perpendicular_Amplifier_Gain_532' then HDF_SD_GETDATA,sds_id,L1_PER_AMP_GN
if var eq 'Parallel_Amplifier_Gain_532' then HDF_SD_GETDATA,sds_id,L1_PAR_AMP_GN
if var eq 'Perpendicular_Background_Monitor_532' then HDF_SD_GETDATA,sds_id,L1_PER_BKG_MON
if var eq 'Parallel_Background_Monitor_532' then HDF_SD_GETDATA,sds_id,L1_PAR_BKG_MON
if var eq 'Depolarization_Gain_Ratio_532' then HDF_SD_GETDATA,sds_id,L1_DEP_GR
if var eq 'Depolarization_Gain_Ratio_Uncertainty_532' then HDF_SD_GETDATA,sds_id,L1_DEP_GR_UNC
if var eq 'Calibration_Constant_532' then HDF_SD_GETDATA,sds_id,L1_CAL_CNST_532
if var eq 'Calibration_Constant_Uncertainty_532' then HDF_SD_GETDATA,sds_id,L1_CAL_CNST_532_UNC
if var eq 'Total_Attenuated_Backscatter_532' then HDF_SD_GETDATA,sds_id,L1_TOT_BKS_532
if var eq 'Perpendicular_Attenuated_Backscatter_532' then HDF_SD_GETDATA,sds_id,L1_PER_BKS_532
if var eq 'Perpendicular_RMS_Baseline_532' then HDF_SD_GETDATA,sds_id,L1_PER_RMS_BL
if var eq 'Parallel_RMS_Baseline_532' then HDF_SD_GETDATA,sds_id,L1_PAR_RMS_BL
if var eq 'Laser_Energy_1064' then HDF_SD_GETDATA,sds_id,L1_LAS_EN_1064
if var eq 'Amplifier_Gain_1064' then HDF_SD_GETDATA,sds_id,L1_AMP_GN_1064
if var eq 'Calibration_Constant_1064' then HDF_SD_GETDATA,sds_id,L1_CAL_CNST_1064
if var eq 'Calibration_Constant_Uncertainty_1064' then HDF_SD_GETDATA,sds_id,L1_CAL_CNST_1064_UNC
if var eq 'Attenuated_Backscatter_1064' then HDF_SD_GETDATA,sds_id,L1_BKS_1064
if var eq 'RMS_Baseline_1064' then HDF_SD_GETDATA,sds_id,L1_RMS_BL_1064
if var eq 'Molecular_Number_Density' then HDF_SD_GETDATA,sds_id,L1_MOL_NUM_DEN
if var eq 'Ozone_Number_Density' then HDF_SD_GETDATA,sds_id,L1_OZ_NUM_DEN
if var eq 'Temperature' then HDF_SD_GETDATA,sds_id,L1_TEMP
if var eq 'Pressure' then HDF_SD_GETDATA,sds_id,L1_PRESS
if var eq 'Noise_Scale_Factor_532_Perpendicular' then HDF_SD_GETDATA,sds_id,L1_NSF_PER
if var eq 'Noise_Scale_Factor_532_Parallel' then HDF_SD_GETDATA,sds_id,L1_NSF_PAR
if var eq 'Noise_Scale_Factor_1064' then HDF_SD_GETDATA,sds_id,L1_NSF_1064
if var eq 'QC_Flag' then HDF_SD_GETDATA,sds_id,L1_QC_FLG
if var eq 'QC_Flag_2' then HDF_SD_GETDATA,sds_id,L1_QC_FLG_2

;TABLE 9 PARAMETERS

if var eq 'Latitude' then HDF_SD_GETDATA,sds_id,L1_LAT
if var eq 'Longitude' then HDF_SD_GETDATA,sds_id,L1_LON
if var eq 'Off_Nadir_Angle' then HDF_SD_GETDATA,sds_id,L1_OFF_NDR
if var eq 'Viewing_Zenith_Angle' then HDF_SD_GETDATA,sds_id,L1_VW_ZNTH
if var eq 'Viewing_Azimuth_Angle' then HDF_SD_GETDATA,sds_id,L1_VW_AZMTH
if var eq 'Solar_Zenith_Angle' then HDF_SD_GETDATA,sds_id,L1_SOL_ZNTH
if var eq 'Solar_Azimuth_Angle' then HDF_SD_GETDATA,sds_id,L1_SOL_AZMTH
if var eq 'Scattering_Angle' then HDF_SD_GETDATA,sds_id,L1_SCATR

;TABLE 8 PARAMETERS

if var eq 'Spacecraft_Altitude' then HDF_SD_GETDATA,sds_id,L1_SPC_ALT
if var eq 'Spacecraft_Position' then HDF_SD_GETDATA,sds_id,L1_SPC_POS
if var eq 'Spacecraft_Velocity' then HDF_SD_GETDATA,sds_id,L1_SPC_VEL
if var eq 'Spacecraft_Attitude' then HDF_SD_GETDATA,sds_id,L1_SPC_ATT
if var eq 'Spacecraft_Attitude_Rate' then HDF_SD_GETDATA,sds_id,L1_SPC_ATT_RATE
if var eq 'Subsatellite_Latitude' then HDF_SD_GETDATA,sds_id,L1_SUBSAT_LAT
if var eq 'Subsatellite_Longitude' then HDF_SD_GETDATA,sds_id,L1_SUBSAT_LON
if var eq 'Earth-Sun_Distance' then HDF_SD_GETDATA,sds_id,L1_EARTH_SUN_DIST
if var eq 'Subsolar_Latitude' then HDF_SD_GETDATA,sds_id,L1_SSOL_LAT
if var eq 'Subsolar_Longitude' then HDF_SD_GETDATA,sds_id,L1_SSOL_LON

;TABLE 7 PARAMETERS

nrec = HDF_VD_READ(vdata_id,L1_PROD_ID,fields='Product_ID')
nrec = HDF_VD_READ(vdata_id,L1_DAT_TIM_START,fields='Date_Time_at_Granule_Start')
nrec = HDF_VD_READ(vdata_id,L1_DAT_TIM_END,fields='Date_Time_at_Granule_End')
nrec = HDF_VD_READ(vdata_id,L1_DAT_TIM_PROD,fields='Date_Time_of_Production')
nrec = HDF_VD_READ(vdata_id,L1_NUM_GOOD_PROF,fields='Number_of_Good_Profiles')
nrec = HDF_VD_READ(vdata_id,L1_NUM_BAD_PROF,fields='Number_of_Bad_Profiles')
nrec = HDF_VD_READ(vdata_id,L1_INIT_SUBSAT_LAT,fields='Initial_Subsatellite_Latitude')
nrec = HDF_VD_READ(vdata_id,L1_INIT_SUBSAT_LON,fields='Initial_Subsatellite_Longitude')
nrec = HDF_VD_READ(vdata_id,L1_FINAL_SUBSAT_LAT,fields='Final_Subsatellite_Latitude')
nrec = HDF_VD_READ(vdata_id,L1_FINAL_SUBSAT_LON,fields='Final_Subsatellite_Longitude')
nrec = HDF_VD_READ(vdata_id,L1_EPHM_FILES_USED,fields='Ephemeris_Files_Used')
nrec = HDF_VD_READ(vdata_id,L1_ATT_FILES_USED,fields='Attitude_Files_Used')
nrec = HDF_VD_READ(vdata_id,L1_PCNT_PAR_BAD,fields='Percent_532-parallel_Bad')
nrec = HDF_VD_READ(vdata_id,L1_PCNT_PER_BAD,fields='Percent_532-perpendicular_Bad')
nrec = HDF_VD_READ(vdata_id,L1_PCNT_1064_BAD,fields='Percent_1064_Bad')
nrec = HDF_VD_READ(vdata_id,L1_PCNT_PAR_MISNG,fields='Percent_532-parallel_Missing')
nrec = HDF_VD_READ(vdata_id,L1_PCNT_PER_MISNG,fields='Percent_532-perpendicular_Missing')
nrec = HDF_VD_READ(vdata_id,L1_PCNT_1064_MISNG,fields='Percent_1064_Missing')
nrec = HDF_VD_READ(vdata_id,L1_CALREG_TOP_ALT,fields='Cal_Region_Top_Altitude_532')
nrec = HDF_VD_READ(vdata_id,L1_CALREG_BASE_ALT,fields='Cal_Region_Base_Altitude_532')
nrec = HDF_VD_READ(vdata_id,L1_LID_ALTS,fields='Lidar_Data_Altitudes')
nrec = HDF_VD_READ(vdata_id,L1_MET_ALTS,fields='Met_Data_Altitudes')
END
;----------------------------------------------------------------------------
FUNCTION read_hdf_L1_XLT,path,FNAME,vname,XLT_ID
fid=hdf_open(path+FNAME,/read)
SDinterface_id=HDF_SD_START(path+FNAME,/read)
index1=HDF_SD_NAMETOINDEX(SDinterface_id,vname)
sds_id=HDF_SD_SELECT(SDinterface_id,index1)

HDF_SD_GETINFO,sds_id,name=var,dims=dimx,format=formx,hdf_type=hdft,unit=unitx

HDF_SD_GETDATA,sds_id,L1_ONE_VAR
HDF_SD_ENDACCESS,sds_id
HDF_SD_END,SDinterface_id
HDF_CLOSE,fid
L1_ONE_VAR_XLT=L1_ONE_VAR[*,XLT_ID]
return,L1_ONE_VAR_XLT
END
;----------------------------------------------------------------------------
FUNCTION read_hdf_L1_XLT7,path,FNAME,vname,XLT_ID ,count
fid=hdf_open(path+FNAME,/read)
SDinterface_id=HDF_SD_START(path+FNAME,/read)
index1=HDF_SD_NAMETOINDEX(SDinterface_id,vname)
sds_id=HDF_SD_SELECT(SDinterface_id,index1)

HDF_SD_GETINFO,sds_id,name=var,dims=dimx,format=formx,hdf_type=hdft,unit=unitx

HDF_SD_GETDATA,sds_id,L1_ONE_VAR
HDF_SD_ENDACCESS,sds_id
HDF_SD_END,SDinterface_id
HDF_CLOSE,fid
;L1_ONE_VAR_XLT=L1_ONE_VAR[88:577,XLT_ID[0]-7:XLT_ID[count-1]+7]
L1_ONE_VAR_XLT=L1_ONE_VAR[88:577,XLT_ID]
return,L1_ONE_VAR_XLT
END
;----------------------------------------------------------------------------

FUNCTION read_hdf_L1,path,FNAME,vname
dsets=0
attrs=0
fid=hdf_open(path+FNAME,/read)
SDinterface_id=HDF_SD_START(path+FNAME,/read)
index=HDF_SD_NAMETOINDEX(SDinterface_id,vname)
sds_id=HDF_SD_SELECT(SDinterface_id,index)
HDF_SD_GETDATA,sds_id,L1_ONE_VAR
HDF_SD_ENDACCESS,sds_id
HDF_SD_END,SDinterface_id
HDF_CLOSE,fid
return,L1_ONE_VAR
END
;------------------------------------------------------------------------------
FUNCTION read_hdf_VD_L1, path, FNAME, vname

fid=hdf_open(path + FNAME,/read)

;Retrieve the Vdata information
vds_id = HDF_VD_LONE(fid)
vdata_id=HDF_VD_ATTACH(fid,vds_id,/read)

nrec = HDF_VD_READ(vdata_id,L1_VDATA,fields=vname)

HDF_VD_DETACH,vdata_id

HDF_CLOSE,fid

return, L1_VDATA

END
;*********************************************************
PRO DEP_CLR_RATIO_ATTEN_EXT_DUST

;sitename='SACOL' & site_lat=35.9462  & site_lon = 104.13708
;sitename='SENDAI' & site_lat=38.25  & site_lon = 140.84
sitename='TPE' & site_lat=25  & site_lon = 121
fpath='F:\calipso\data\'
;fname=''
;FNAME='CAL_LID_L3_APro_AllSky-Beta-V1-00.2009-04N.hdf'
FNAME='CAL_LID_L1-ValStage1-V3-01.2010-03-20T03-59-11ZD.hdf'
;FNAME='CAL_LID_L1-ValStage1-V3-01.2009-03-14T05-09-14ZD.hdf_Subset.hdf'
gpath1='F:\CALIPSO\results\';   20150507\'

;filelist=fpath+'list.txt'

;openr,lun,filelist,/get_lun
;while(eof(lun) ne 1)  DO BEGIN
file=fpath+fname
openr,lun,file,/get_lun
print,file
readf,lun,file
lon1=0
lon2=130.
lat1=0.
lat2=50.
tag=0
;MAIN_PROGRAM,fpath,FNAME,gpath1,lat1,lat2,lon1,lon2,sitename,site_lat,site_lon
;ENDWHILE

END

;////////////////////////////////////////////////////////////////////////////
PRO MAIN_PROGRAM,fpath,FNAME,gpath,lat1,lat2,lon1,lon2,sitename,site_lat,site_lon

GET_DEP_CLR_ATT,fpath,FNAME,lat1,lat2,lon1,lon2,LON_1,LAT_1,prof_lid_alts_1,$
                 prof_tot_bks_532_1,prof_surf_elev_1,xstr,prof_dep_ratio_1,$
                 prof_clr_ratio_1,begin_time_1,end_time_1,prof_ext_coe_1,$
                 count


IF(count gt 15)  then  begin
filename1=strmid(begin_Time_1,0,10)+'_'+strmid(begin_Time_1,11,2)+'_'+$
  strmid(begin_Time_1,14,2)+ '_'+strmid(begin_Time_1,17,2)
lx1=0.0
lx2=0.85
ly1=0.1
dyy=0.29
tag1=1
psopen,gpath+filename1+'_'+'DEP_BKS_CLR.eps'
ly2=ly1+dyy
help,prof_lid_alts_1
; print,'prof_lid_alts_1',prof_lid_alts_1
;Avrg.
help,prof_tot_bks_532_1,prof_clr_ratio_1,prof_dep_ratio_1

siz=size(prof_tot_bks_532_1)
;print,'prof_surf_elev_1',prof_surf_elev_1
help,prof_surf_elev_1
;fn='D:\My paper\New paper-dust storm\DATA\LIDAR\CALIPSO\contour_data\'

totalfile=gpath+filename1+'_TOTAL_BKS_532_clr_ratio_dep_ratio.dat'
openw,lun,totalfile,/GET_LUN
printf,lun,prof_lid_alts_1,format='(583f14.7)'
printf,lun,prof_surf_elev_1,format='(11808f14.7)'
printf,lun,LON_1,format='(11808f14.7)'
printf,lun,LAT_1,format='(11808f14.7)'
printf,lun,prof_tot_bks_532_1,format='(583f14.7)'
printf,lun,prof_dep_ratio_1,format='(583f14.7)'
printf,lun,prof_clr_ratio_1,format='(583f14.7)'
close,lun & free_lun,lun

;SMOOTH
FOR i=0,siz(1)-1 DO BEGIN
 prof_tot_bks_532_1(i,*)=smooth(prof_tot_bks_532_1(i,*),3)
 prof_clr_ratio_1(i,*)=smooth(prof_clr_ratio_1(i,*),9)
 prof_dep_ratio_1(i,*)=smooth(prof_dep_ratio_1(i,*),17)

ENDFOR

FOR j=0,siz(2)-1 DO BEGIN
 prof_tot_bks_532_1(*,j)=smooth(prof_tot_bks_532_1(*,j),3)
 prof_clr_ratio_1(*,j)=smooth(prof_clr_ratio_1(*,j),9)
 prof_dep_ratio_1(*,j)=smooth(prof_dep_ratio_1(*,j),17)

ENDFOR

mean_tot_bks_532=fltarr(siz(1)) & std_tot_bks_532=fltarr(siz(1))
mean_clr_ratio=fltarr(siz(1))   & std_clr_ratio=fltarr(siz(1))
mean_dep_ratio=fltarr(siz(1))   & std_dep_ratio=fltarr(siz(1))

FOR i=0,siz(1)-1 DO BEGIN
 index_tot_bks_532=where(prof_tot_bks_532_1(i,*) GT -0.02 and prof_tot_bks_532_1(i,*) LE 0.1,count_tot_bks_532)
 IF count_tot_bks_532 GT 1.0 THEN BEGIN
  mean_tot_bks_532(i)=mean(prof_tot_bks_532_1(i,index_tot_bks_532))
  std_tot_bks_532(i)=STDDEV(prof_tot_bks_532_1(i,index_tot_bks_532))
 ENDIF
 index_clr_ratio=where(prof_clr_ratio_1(i,*) GT -0.2 AND prof_clr_ratio_1(i,*) LE 1.6,count_clr_ratio)
 IF count_clr_ratio GT 1.0 THEN BEGIN
  mean_clr_ratio(i)=mean(prof_clr_ratio_1(i,index_clr_ratio))
  std_clr_ratio(i)=STDDEV(prof_clr_ratio_1(i,index_clr_ratio))
 ENDIF
 index_dep_ratio=where(prof_dep_ratio_1(i,*) GT -0.3 AND prof_dep_ratio_1(i,*) LE .25,count_dep_ratio)
 IF count_dep_ratio GT 1.0 THEN BEGIN
  mean_dep_ratio(i)=mean(prof_dep_ratio_1(i,index_dep_ratio))
  std_dep_ratio(i)=STDDEV(prof_dep_ratio_1(i,index_dep_ratio))
 ENDIF

ENDFOR


mean_total=[TRANSPOSE(prof_lid_alts_1)-MAX(prof_surf_elev_1),TRANSPOSE(mean_tot_bks_532),TRANSPOSE(std_tot_bks_532),$
   TRANSPOSE(mean_clr_ratio),TRANSPOSE(std_clr_ratio),TRANSPOSE(mean_dep_ratio),TRANSPOSE(std_dep_ratio)]
help,mean_total
mean_totalfile=gpath+filename1+'mean&std_TOTAL_BKS_532_clr_ratio_dep_ratio.dat'
openw,lun,mean_totalfile,/GET_LUN
printf,lun,mean_total,format='(7f14.7)'
close,lun & free_lun,lun

;filename5='CLR_RATIO.eps'
GRAPH_clr_RATIO,gpath,filename1,begin_time_1,xstr,count,filename5,$
                prof_surf_elev_1,prof_lid_alts_1,prof_clr_ratio_1,$
                lx1,lx2,ly1,ly2,tag1
ly1=ly2+0.02
ly2=ly1+dyy
tag1=0
;filename4='DEP_RATIO.eps'
GRAPH_DEP_RATIO,gpath,filename1,begin_time_1,xstr,count,filename4,$
                prof_surf_elev_1,prof_lid_alts_1,prof_dep_ratio_1,$
                lx1,lx2,ly1,ly2,tag1

ly1=ly2+0.02
ly2=ly1+dyy
tag1=0
;filename3='select_tot_att_bks_532.eps'
GRAPH_TOTAL_BKS_532,gpath,filename1,begin_time_1,end_time_1,prof_tot_bks_532_1,$
                   subname,prof_surf_elev_1,prof_lid_alts_1,$
                   xstr,count,filename3,$
                lx1,lx2,ly1,ly2,tag1
psclose

stop

filename6='cal_orbit.eps'
ORBIT_CAL,gpath,filename1,LON_1,LAT_1,filename6,lon1,lon2,lat1,lat2,sitename,site_lat,site_lon
ENDIF
END
;//////////////////////////////////////////////////////////////////////////////
PRO   ORBIT_CAL,gpath,filename1,LON,LAT,filename6,lon1,lon2,lat1,lat2,sitename,site_lat,site_lon
nx=(lon2-lon1)/10
ny=(lat2-lat1)/5
dlon=(lon2-lon1)/nx
dlat=(lat2-lat1)/ny

psopen,gpath+filename1+'_'+filename6
color_tab,color
plot,findgen(nx+1)*10+lon1,findgen(ny+1)*5+lat1,$
                color=0,linestyle=1,/nodata,xtickname=sub_lon1,$
    charsize=0.9,ytitle='Latitude (N)',xtitle='Longitude (E)',$
   xticks=nx,yticks=ny,xminor=4,/noerase,ystyle=1,xstyle=1,$
     position=[0.0,0.1,0.95,0.95],$
       xrange=[lon1,lon2],yrange=[lat1,lat2]

plots,lon,lat,color=2,thick=8.0
;  ;Read HYSPLIT data
;  sitename='Chiba'
;  Read_HYSPLIT,sitename,HYSPLIT_DATA
;    OPLOT,HYSPLIT_DATA(10,*),HYSPLIT_DATA(9,*),COLOR=3,THICK=8.
;    HYSPLIT_DAY=strmid(filename1,8,2)
;    INDEX=WHERE(HYSPLIT_DATA(4,*) EQ float(HYSPLIT_DAY))
;    OPLOT,HYSPLIT_DATA(10,INDEX),HYSPLIT_DATA(9,INDEX),COLOR=7,THICK=20.
;    xyouts, -86.4,80,'PEARL'


;x = 0.1*(cos(findgen(170)*2*!pi/16)+100.272)
;y = 0.1*(sin(findgen(170)*2*!pi/16)+39.078)
;;usersym,x,y,thick=4,/fill
lon=transpose(lon)
lat=transpose(lat)
lon_lat=[lon,lat]
lon_latfile=gpath+filename1+'orbit.dat'
openw,lun,lon_latfile,/GET_LUN
printf,lun,lon_lat,format='(2f14.7)'
close,lun & free_lun,lun
;site diatance
r1=sqrt(min((lon-site_lon)^2+(lat-site_lat)^2,Min_Subscript1))*110.

;calculate distance between two places
temp_angle=cos(lat*!Pi/180.)*cos(site_lat*!Pi/180.)*cos((lon-site_lon)*!Pi/180.)+sin(lat*!Pi/180.)*sin(site_lat*!Pi/180.)
D=6371.*ACOS(temp_angle) & D_min=MIN(D,Min_Subscript)

;Jingtai
;r2=sqrt(min((lon-104.139)^2+(lat-37.332)^2,Min_Subscript2))*110
;;SACOL
;r3=sqrt(min((lon-104.137)^2+(lat-35.946)^2,Min_Subscript3))*110
;print,filename1,r1,lon(Min_Subscript1),r2,lon(Min_Subscript2),r3,lon(Min_Subscript3)
xyouts,site_lon,site_lat,'*',charsize=3
xyouts,site_lon-0.2,site_lat-0.2,sitename
xyouts,0.4,0.3,'Distance: '+STRTRIM(string(D_min),2)+'km',color=2,/NORMAL,charsize=1.5
;xyouts,0.5,0.7,'OLD: '+STRTRIM(string(r1),2)+'km',color=2,/NORMAL
xyouts,0.5,0.2,'Lat: '+STRTRIM(string(lat(Min_Subscript)),2),color=2,/NORMAL

;xyouts,104.139,37.332,'*'
;xyouts,104.137,35.946,'*'
map_set,    /CYL,/noerase ,/noborder, $
         limit=[lat1,lon1,lat2,lon2], $
         position=[0.0,0.1,0.95,0.95]
map_continents,/countries,/coasts
map_grid,lats=findgen(ny+1)*dlat+lat1,lons=findgen(nx+1)*dlon+lon1,color=7,$
                    glinestyle=1,glinetick=3
psclose

END
;//////////////////////////////////////////////////////////////////////////
PRO  GRAPH_clr_RATIO,gpath,filename1,begin_time,xstr,count,filename5,$
                prof_surf_elev,prof_lid_alts,prof_clr_ratio,$
                lx1,lx2,ly1,ly2,tag1,trj_alt1,trj_alt2,trj_count
SURF_ELEV=prof_surf_elev
LID_ALTS=prof_lid_alts
num_lon=count
n_clr=18
bar_name=['0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9',$
          '1.0','1.1','1.2','1.3','1.4','1.5','1.6',' ']
color_clr_ratio,color
xname=[' ',' ',' ',' ',' ',' ',' ']
xticks=xstr
plot, findgen(num_lon+1), findgen(7), /nodata,xticks=6,xtickname=xname, $
        xrange=[0,num_lon],xtick_get= xtick_pos,  $
        ytitle = 'Altitude (km)', $
        position= [lx1, ly1, lx2, ly2], $
        xstyle = 3, yrange=[0,15], color=0,charsize=0.9,thick=8.0,/noerase

;//////////////////////////////////////////////////////////////
index_gt09=where(prof_clr_ratio gt 1.6,count_gt09)
IF(count_gt09 gt 0)  then  prof_clr_ratio[index_gt09]=1.6

clr_index = floor(prof_clr_ratio*10)+3

index_9999=where(prof_clr_ratio eq -9999.0,count_9999)
IF(count_9999 gt 0)   then  clr_index[index_9999]=2

index_0_82=where((LID_ALTS gt -0.01) and (LID_ALTS le 8.2),count_0_82)
IF(count_0_82 gt 0 )   THEN  BEGIN
tv,reverse(transpose(clr_index[index_0_82,*])),0,8.2,xsize=num_lon-1,ysize=-8.2,/data
ENDIF
index_15_82=where((LID_ALTS gt 8.2) and (LID_ALTS le 15),count_15_82)
IF(count_15_82 gt 0 )   THEN  BEGIN
tv,reverse(transpose(clr_index[index_15_82,*])),0,15,xsize=num_lon-1,ysize=-6.8,/data
ENDIF
zero_y=[0]
poly_x=[indgen(num_lon),reverse(indgen(num_lon)),0]
poly_y=[rebin(zero_y,num_lon),SURF_ELEV,0]
polyfill,poly_x,poly_y,color=1
plots,indgen(num_lon),reverse(SURF_ELEV),color=7,thick=3.0
;/////////////////////////////////////////////////////
;/////////////////////////////////////////////////////
IF(tag1 eq 1)   then begin
axis,xaxis=0,xrange=[0,num_lon],xtickname=xticks,/save,xminor=1,xticks=6,$
   charsize=0.9    ,xtitle = '!CLat | Lon'   ,xstyle=3,xtick_get= xtick_pos
ENDIF
;/////////////////////////////////////////////////////////////
plot, findgen(num_lon+1), findgen(7), /nodata,xticks=6,xtickname=xname, $
        xrange=[0,num_lon],xtick_get= xtick_pos,  $
        ytitle = 'Altitude (km)', $
        position= [lx1, ly1, lx2, ly2], $
        xstyle = 3, yrange=[0,15], color=0,charsize=0.9,thick=8.0,/noerase
xyouts,num_lon/20.,13.5,'(c) Color ratio (1064nm/532nm)',color=18,charsize=1.,alignment=0.
;xyouts,num_lon-num_lon/(6*5),8.5,'Backscatter Color Ratio',$
;                            color=18,charsize=1.0,alignment=1.0

dy=(ly2-ly1)/(n_clr)
x0=lx2+0.03
x1=lx2+0.07
y0=ly1

plots,[x0, x1,x1, x0, x0],[y0, y0, y0+dy*n_clr, y0+dy*n_clr, y0], $
      color=0, /norm,thick=6.0


FOR ibox=0,n_clr-1  DO begin
y1=y0+dy
polyfill,[x0, x1, x1, x0, x0], [y0, y0, y1, y1, y0],/normal,$
          color=ibox+2
y0=y1
ENDFOR
;xyouts,x1+0.01,y1-0.01,bar_name[ibox],/normal,color=0,charsize=0.7
dy=(ly2-ly1)/(n_clr)
x0=lx2+0.03
x1=lx2+0.07
y0=ly1
y0=y0-dy
FOR ibox=0,n_clr-2,2 DO begin
y1=y0+dy*2
xyouts,x1+0.01,y1-0.01,bar_name[ibox],/normal,color=0,charsize=0.7
y0=y1
ENDFOR
dy=(ly2-ly1)/(n_clr)
x0=lx2+0.03
x1=lx2+0.07
y0=ly1
FOR iy=1,n_clr-1  DO  BEGIN
plots,[x0,x1],[y0+iy*dy,y0+iy*dy],color=0,/normal
ENDFOR
plots,[x0, x1,x1, x0, x0],[y0, y0, y0+dy*n_clr, y0+dy*n_clr, y0], $
      color=0, /norm,thick=6.0

END
;/////////////////////////////////////////////////////////////////////////
PRO GRAPH_DEP_RATIO,gpath,filename1,begin_time,xstr,count,filename4,$
                    prof_surf_elev,prof_lid_alts,prof_dep_ratio,$
                   lx1,lx2,ly1,ly2,tag1,trj_alt1,trj_alt2,trj_count
SURF_ELEV=prof_surf_elev
LID_ALTS=prof_lid_alts
num_lon=count
color_dep_ratio,color
n_clr=12
bar_name=['0.0','.06','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0',' ']

xname=[' ',' ',' ',' ',' ',' ',' ']
xticks=xstr
plot, findgen(num_lon+1), findgen(7), /nodata,xticks=6,xtickname=xname, $
        xrange=[0,num_lon],xtick_get= xtick_pos,  $
        ytitle = 'Altitude (km)', $
        position= [lx1, ly1, lx2, ly2], $
        xstyle = 3, yrange=[0,15], color=0,charsize=0.9,thick=8.0,/noerase
;===================================================================
index_gt09=where(prof_dep_ratio gt 1.0,count_gt09)
IF(count_gt09 gt 0)  then  prof_dep_ratio[index_gt09]=1.0
clr_index=floor(prof_dep_ratio*10)+3
index_006=where((prof_dep_ratio lt 0.2) and (prof_dep_ratio ge 0.06),count_006)
IF(count_006 gt 0)  then   clr_index[index_006]=4
index_9999=where(prof_dep_ratio eq -9999.0,count_9999)
IF(count_9999 gt 0)   then  clr_index[index_9999]=2

index_0_82=where((LID_ALTS gt -0.01) and (LID_ALTS le 8.2),count_0_82)
IF(count_0_82 gt 0 )   THEN  BEGIN
tv,reverse(transpose(clr_index[index_0_82,*])),0,8.2,xsize=num_lon-1,ysize=-8.2,/data
ENDIF
index_15_82=where((LID_ALTS gt 8.2) and (LID_ALTS le 15),count_15_82)
IF(count_15_82 gt 0 )   THEN  BEGIN
tv,reverse(transpose(clr_index[index_15_82,*])),0,15,xsize=num_lon-1,ysize=-6.8,/data
ENDIF
zero_y=[0]
poly_x=[indgen(num_lon),reverse(indgen(num_lon)),0]
poly_y=[rebin(zero_y,num_lon),SURF_ELEV,0]
polyfill,poly_x,poly_y,color=1
plots,indgen(num_lon),reverse(SURF_ELEV),color=7,thick=3.0
;/////////////////////////////////////////////////////
;/////////////////////////////////////////////////////
;===========================================================================
IF(tag1 eq 1)   then begin
axis,xaxis=0,xrange=[0,num_lon],xtickname=xticks,/save,xminor=1,xticks=6,$
   charsize=0.9    ,xtitle = '!CLat | Lon'   ,xstyle=3,$
   xtick_get= xtick_pos
ENDIF
plot, findgen(num_lon+1), findgen(7), /nodata,xticks=6,xtickname=xname, $
        xrange=[0,num_lon],xtick_get= xtick_pos,  $
        ytitle = 'Altitude (km)', $
        position= [lx1, ly1, lx2, ly2], $
        xstyle = 3, yrange=[0,15], color=0,charsize=0.9,thick=8.0,/noerase

xyouts,num_lon/20.,13.5,'(b) Depolarization ratio (532nm)',color=11,charsize=1.,alignment=0.
;xyouts,num_lon-num_lon/(6*5),8.5,'Depolarization Ratio',$
;                            color=11,charsize=1.0,alignment=1.0

dy=(ly2-ly1)/(n_clr)
x0=lx2+0.03
x1=lx2+0.07
y0=ly1

plots,[x0, x1,x1, x0, x0],[y0, y0, y0+dy*n_clr, y0+dy*n_clr, y0], $
      color=0, /norm,thick=6.0


FOR ibox=0,n_clr-1  DO begin
ii=ibox
if(ibox ge 9)  THEN ii=9
y1=y0+dy
polyfill,[x0, x1, x1, x0, x0], [y0, y0, y1, y1, y0],/normal,$
          color=ii+2
xyouts,x1+0.01,y1-0.01,bar_name[ibox],/normal,color=0,charsize=0.7
y0=y1
ENDFOR
;xyouts,x1+0.01,y1-0.01,bar_name[ibox],/normal,color=0,charsize=0.7
dy=(ly2-ly1)/(n_clr)
x0=lx2+0.03
x1=lx2+0.07
y0=ly1
FOR iy=1,n_clr-1  DO  BEGIN
plots,[x0,x1],[y0+iy*dy,y0+iy*dy],color=0,/normal
ENDFOR
plots,[x0, x1,x1, x0, x0],[y0, y0, y0+dy*n_clr, y0+dy*n_clr, y0], $
      color=0, /norm,thick=6.0
END
;/////////////////////////////////////////////////////////////////////////
PRO GRAPH_TOTAL_BKS_532,path1,filename1,begin_time,end_time,prof_tot_bks_532,$
                    subname,prof_surf_elev,prof_lid_alts,xstr,count,filename3,$
                lx1,lx2,ly1,ly2,tag1,trj_alt1,trj_alt2,trj_count
SURF_ELEV=prof_surf_elev
prof_532_tot_bks=prof_tot_bks_532
LID_ALTS=prof_lid_alts
num_lon=count
;   LOADCT,42,FILE='D:\SACOL_MPL\NEED\Color table\huang2.tbl'
  get_color_tbl ; load new color table from calipso

; create colors_532. colors_532 is used to create the lidar color image. (=34)
colors_plot = [130, 113,  64,  57,  50,  43,  36,  29, 128, 144, $
                 7,   7, 193, 192, 191, 190, 188, 155, 139, 123, $
                10,  11,  12,  13,  14,  15,  16,  17,  18,  19, $
                20,  21,  22,  49]

replicates =  [  1,   2,   1,   1,   1,   1,   1,   1,   1,   5, $
                 5,   5,   5,   5,   5,   5,   5,   5,   5,   5, $
                 5,   5,   5,  20, 100, 100, 100, 100, 100, 100, $
               100, 100, 100, 40000]

; create INT array with 51000 elements and filled with value 49
colors_532 = replicate(49,51000L)
ncols = n_elements(colors_plot)

ic = 0L ; counter for colors_532
ip = 0L ; counter for colors_plot

for im=0,ncols-1 do begin
  iend = ic + (replicates(im)-1)
  colors_532(ic:iend) = colors_plot(ip)
  ip = ip + 1L
  ic = iend + 1L
end

xname=[' ',' ',' ',' ',' ',' ',' ']
xticks=xstr
plot, findgen(num_lon+1), findgen(7), /nodata,xticks=6,xtickname=xname, $
        xrange=[0,num_lon],xtick_get= xtick_pos,  $
        ytitle = 'Altitude (km)', $
        position= [lx1, ly1, lx2, ly2], $
        xstyle = 3, yrange=[0,15], color=254,charsize=0.9,thick=8.0,/noerase

;scale=round(count/250)
;if(scale eq 0) then scale=1
;for ipix =0, num_lon-1,scale do begin
;for ilay = 0, 582 do begin
;if (LID_ALTS[ilay] ge SURF_ELEV[ipix]) and (LID_ALTS[ilay] le 15.0) then begin
;        cvt_2_int = floor(prof_532_tot_bks[ilay,ipix] / 1.0e-4)
;        clr_index = colors_532((cvt_2_int ge 0) ? cvt_2_int:0)
;        plots, ipix,LID_ALTS[ilay], psym = 6, color=clr_index, symsize=0.1
;      endif else begin
;if ((LID_ALTS[ilay] lt SURF_ELEV[ipix]) and (LID_ALTS[ilay] gt 0.0))then begin
;        plots, ipix,LID_ALTS[ilay], psym = 6, color=16, symsize=0.1
;      endif
;   ENDELSE
;  endfor
;        plots, ipix, SURF_ELEV[ipix], psym = 6, color=254, symsize=0.1
;  endfor
;rang_h=15*1000
;rang_l=0
;num_rang=(rang_h-rang_l)/30+1
;image=make_array(num_rang,num_lon,/byte)
cvt_2_int = floor(prof_532_tot_bks/1.0e-4)
index_cvt=where(cvt_2_int lt 0,count_cvt)
IF(count_cvt gt 0)  then  cvt_2_int[index_cvt]=0
clr_index=colors_532[cvt_2_int]
index_0_82=where((LID_ALTS gt -0.01) and (LID_ALTS le 8.2),count_0_82)
IF(count_0_82 gt 0 )   THEN  BEGIN
temp_total_lower=reverse(transpose(clr_index[index_0_82,*]))
tv,temp_total_lower,0,8.2,xsize=num_lon-1,ysize=-8.2,/data
ENDIF
index_15_82=where((LID_ALTS gt 8.2) and (LID_ALTS le 15),count_15_82)
IF(count_15_82 gt 0 )   THEN  BEGIN
temp_total_upper=reverse(transpose(clr_index[index_15_82,*]))
tv,temp_total_upper,0,15,xsize=num_lon-1,ysize=-6.8,/data
ENDIF


zero_y=[0]
poly_x=[indgen(num_lon),reverse(indgen(num_lon)),0]
poly_y=[rebin(zero_y,num_lon),SURF_ELEV,0]
polyfill,poly_x,poly_y,color=16

plots,indgen(num_lon),reverse(SURF_ELEV),color=188,thick=3.0
;/////////////////////////////////////////////////////
;/////////////////////////////////////////////////////
help,colors_532
print,colors_532(48)
help,cvt_2_int,clr_index
IF(tag1 eq 1)   then begin
axis,xaxis=0,xrange=[0,num_lon],xtickname=xticks,/save,xminor=1,xticks=6,$
   charsize=0.9    ,xtitle = '!CLat | Lon'   ,xstyle=1,xtick_get= xtick_pos
ENDIF
plot, findgen(num_lon+1), findgen(7), /nodata,xticks=6,xtickname=xname, $
        xrange=[0,num_lon],xtick_get= xtick_pos,  $
        ytitle = 'Altitude (km)', $
        position= [lx1, ly1, lx2, ly2], $
        xstyle = 3, yrange=[0,15], color=254,charsize=0.9,thick=8.0,/noerase
xyouts,num_lon/20.,13.5,'(a) Lidar attenuated backscatter (532nm)',color=0,charsize=1.,alignment=0.
;xyouts,num_lon-num_lon/(6*5),13.5,'532-nm Attenuated Backscatter',$
;                            color=0,charsize=1.0,alignment=0.5

;COLOR_BAR, [0.920, 0.955, 0.17, 0.80], [0.0001,1.0], 0.0001, 1.0, CHARTHICK=0.3
; add color bar
n_clr=34
dy=(ly2-ly1)/(n_clr)
x0=lx2+0.03
x1=lx2+0.07
x2=x1
y0=ly1
dx=0.01
plots,[x0, x1,x1, x0, x0],[y0, y0, y0+dy*n_clr, y0+dy*n_clr, y0], $
      color=254, /norm,thick=6.0

for ibox = 0, 33 do begin
  y1 = y0 + dy
  polyfill,[x0, x1, x1, x0, x0], [y0, y0, y1, y1, y0], /norm, color=colors_plot[ibox]
  y0 = y1
endfor
y0=ly1
y0 = y0
for iy = 1, 33 do begin
plots, [x0, x1],[y0+iy*dy, y0+iy*dy], color=254, /norm
endfor


sa= string(1.0, form='(f3.1)') +' x10!u-4!n'
y0 = y0 - dy/3.0
xyouts, x2+dx, y0, sa, color = 254, /norm, charsize = 0.65
y0 = y0+dy*9

sa= string(1.0, form='(f3.1)') +' x10!u-3!n'
  xyouts, x2+dx, y0, sa, color = 254, /norm, charsize = 0.7
  y0 = y0+dy*8
sa=string(5.0, form='(f3.1)') + ' x10!u-3!n'
  xyouts, x2+dx, y0, sa, color = 254, /norm, charsize = 0.7
  y0 = y0+dy*7

sa= string(1.0, form='(f3.1)') +' x10!u-2!n'

  xyouts,  x2+dx, y0, sa, color = 254, /norm, charsize = 0.7
  y0 = y0+dy*9

sa = string(1.0, form='(f3.1)') + ' x10!u-1!n'
xyouts, x2+dx, y0, sa, color = 254, /norm, charsize = 0.7

xyouts,x2+dx, lx1-0.3, '(km!u-1!nsr!u-1!n)', color = 254, /norm, charsize = 0.7

;xyouts,0.5,0.91,'532nm Total Attenuaed Backscatter,/km /sr',$
;                 /normal,color=254,charsize=0.9,alignment=0.5
;subname='12345'
;xyouts,0.5,0.91,subname,/normal,color=254,charsize=0.85
;xyouts,0.0,1.0,'Date: 2008-05-02',/normal,color=254,charsize=1.0
;xyouts,0.25,1.0,'Begin: 03:49:18',/normal,color=254,charsize=1.0
;xyouts,0.5,1.0,'End: 03:52:05 (Beijing Time)',/normal,color=254,charsize=1.0
;
;plots,[0.07,0.48],[0.83,0.83],/normal,color=254,thick=12.0
;plots,[0.07,0.48],[0.745,0.745],/normal,color=254,thick=12.0
;plots,[0.07,0.07],[0.745,0.83],/normal,color=254,thick=12.0
;plots,[0.48,0.48],[0.745,0.83],/normal,color=254,thick=12.0
;xyouts,0.22,0.77,'DUST',/normal,color=254,charsize=1.5
;
;plots,[0.07,0.48],[0.53,0.53],/normal,color=254,thick=12.0
;plots,[0.07,0.48],[0.445,0.445],/normal,color=254,thick=12.0
;plots,[0.07,0.07],[0.445,0.53],/normal,color=254,thick=12.0
;plots,[0.48,0.48],[0.445,0.53],/normal,color=254,thick=12.0
;xyouts,0.22,0.47,'DUST',/normal,color=254,charsize=1.5

dy=(ly2-ly1)/(n_clr)
x0=lx2+0.03
x1=lx2+0.07
y0=ly1
plots,[x0, x1,x1, x0, x0],[y0, y0, y0+dy*n_clr, y0+dy*n_clr, y0], $
      color=254, /norm,thick=6.0

END
;////////////////////////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////////////////////////
PRO  GET_DEP_CLR_ATT,fpath,FNAME,lat1,lat2,lon1,lon2,LON,LAT,prof_lid_alts,$
                 prof_tot_bks_532,prof_surf_elev,xstr,prof_dep_ratio,$
                 prof_clr_ratio,begin_time,end_time,prof_ext_coe,$
                 count,trj_lon1,trj_lon2,trj_lat1,trj_lat2,trj_count

GET_DATA,fpath,FNAME,LAT_L,LON_L,Prof_Time,$
          UTC_Time,LID_ALTS_L,SURF_ELEV_L,TOT_BKS_532_L,$
          PER_BKS_532_L,BKS_1064_L

index=where(((LAT_L ge lat1) and(LAT_L le lat2))  and  $
            ((LON_L ge lon1) and(LON_L le lon2)),count)

IF(count gt 15)  then begin
help,count
LAT=LAT_L[index]
LON=LON_L[index]
;///////////////////////////////////////////////////////////////////////////
;==============================================================================

prof_surf_elev=SURF_ELEV_L[index]
prof_lid_alts=LID_ALTS_L


tot_532_L=TOT_BKS_532_L[*,index]
per_532_L=PER_BKS_532_L[*,index]
tot_1064_L=BKS_1064_L[*,index]

;========================  begin dep ratio ==============================

;index_532=where(tot_532_L le 0.0 ,count_532)
;IF(count_532 gt 0) then   tot_532_L[index_532]=0.0
;index_4=where(tot_532_L gt 0.4,count_4)
;IF(count_4 gt 0)  then tot_532_L[index_4]=0.4

middle_tot_532=smooth(tot_532_L,[1,15],/edge_truncate)
index_532=where(middle_tot_532 le 0.0 ,count_532)
IF(count_532 gt 0) then   middle_tot_532[index_532]=0.0

;index_per=where(per_532_L le 0.0 ,count_per)
;IF(count_per gt 0) then   per_532_L[index_per]=0.0
;index_4=where(per_532_L gt 0.2,count_4)
;IF(count_4 gt 0)  then  per_532_L[index_4]=0.2

middle_per_532=smooth(per_532_L,[1,15],/edge_truncate)
index_per=where(middle_per_532 le 0.0 ,count_per)
IF(count_per gt 0) then   middle_per_532[index_per]=0.0



par_532_L=tot_532_L-per_532_L

;index_par=where(par_532_L le 0,count_par)
;IF(count_par gt 0) then   par_532_L[index_par]=0.0
middle_par_532=smooth(par_532_L,[1,15],/edge_truncate)
;middle_par_532=par_532_L
;index_par=where(middle_par_532 le 0,count_par)
;IF(count_par gt 0) then   middle_par_532[index_par]=0.0

index_par_0=where(middle_par_532 gt 0.0003,count_par_0)
IF(count_par_0 gt 0)  then begin
dep_ratio=make_array(583,count,/float,value=0.0)
dep_ratio[index_par_0]=middle_per_532[index_par_0]/middle_par_532[index_par_0]
ENDIF
index_par_1=where(middle_par_532 le 0.0003,count_par_1)
if(count_par_1 gt 0)  then  dep_ratio[index_par_1]=-9999.0

index_par=where(middle_par_532 le 0,count_par)
IF(count_par gt 0) then   dep_ratio[index_par]=0.0

;========================  end dep ratio ================================



;========================  begin clr ratio ================================

;index_1064=where(tot_1064_L le 0.0 ,count_1064)
;IF(count_1064 gt 0) then   tot_1064_L[index_1064]=0.0
;index_4=where(tot_1064_L gt 0.4,count_4)
;IF(count_4 gt 0)  then tot_1064_L[index_4]=0.4

middle_tot_1064=smooth(tot_1064_L,[1,15],/edge_truncate)
;middle_tot_1064=tot_1064_L
;index_1064=where(middle_tot_1064 le 0.0 ,count_1064)
;IF(count_1064 gt 0) then   middle_tot_1064[index_1064]=0.0


index_tot_0=where(middle_tot_532 gt 0.0003,count_tot_0)
IF(count_tot_0 gt 0)  then  begin
clr_ratio=make_array(583,count,/float,value=0.0)
clr_ratio[index_tot_0]=middle_tot_1064[index_tot_0]/middle_tot_532[index_tot_0]
ENDIF
index_tot_1=where(middle_tot_532 le 0.0003,count_tot_1)
IF(count_tot_1 gt 0)  then   clr_ratio[index_tot_1]=-9999.0

index_1064=where(middle_tot_1064 le 0.0 ,count_1064)
IF(count_1064 gt 0) then   clr_ratio[index_1064]=0.0

;========================  end clr ratio ================================


;========================  begin ext coeff ================================

prof_tot_bks_532=middle_tot_532
;help,prof_tot_bks_532,min(prof_tot_bks_532),max(prof_tot_bks_532)
prof_dep_ratio=dep_ratio
;help,prof_dep_ratio,min(prof_dep_ratio),max(prof_dep_ratio)
prof_clr_ratio=clr_ratio
;help,prof_clr_ratio,min(prof_clr_ratio),max(prof_clr_ratio)


index_gt017=where(middle_tot_532 gt 0.017,count_gt017)
IF(count_gt017 gt 0)  then  middle_tot_532[index_gt017]=0.0
;help,count_le0,count_gt017
ext_coeff=-0.7143*alog(1-61.6*middle_tot_532)
prof_ext_coe=ext_coeff
;help,prof_ext_coe,max(prof_ext_coe),min(prof_ext_coe)
;========================  end ext coeff ================================


TIME_DECODE,Prof_Time[index[0]],IYYMMDD,IHHMMSS,UTC
begin_Time=IYYMMDD+' '+IHHMMSS & help,begin_Time
TIME_DECODE,Prof_Time[index[count-1]],IYYMMDD,IHHMMSS,UTC
end_Time=IYYMMDD+' '+IHHMMSS & help,end_Time

nct = round(count/6)
xstr=strarr(7)
for i=0,5 do begin
xstr[i] = strtrim(string(LAT[(5-i+1)*nct-1], form='(f7.2)'), 2) + '!c' + $
          strtrim(string(LON[(5-i+1)*nct-1], form='(f7.2)'), 2)
endfor
xstr[6] = strtrim(string(LAT[0], form='(f7.2)'), 2) + '!c' + $
          strtrim(string(LON[0], form='(f7.2)'), 2)

print,xstr

ENDIF
END

;*****************************************************************************
PRO GET_DATA,path,FNAME,L1_LAT,L1_LON,L1_Prof_Time ,L1_UTC_Time,$
         L1_LID_ALTS,L1_SURF_ELEV,L1_TOT_BKS_532,L1_PER_BKS_532,L1_BKS_1064
L1_LAT=read_hdf_L1(path,FNAME,'Latitude') & help,L1_LAT
L1_LON=read_hdf_L1(path,FNAME,'Longitude') & help,L1_LON
PROF_ID=read_hdf_L1(path,FNAME,'Profile_ID') & help,PROF_ID
L1_Day_Night=read_hdf_L1(path,FNAME,'Day_Night_Flag') & help,L1_Day_Night
L1_UTC_Time=read_hdf_L1(path,FNAME,'Profile_UTC_Time')&help,L1_UTC_Time
L1_Prof_Time=read_hdf_L1(path,FNAME,'Profile_Time')&help,L1_Prof_Time
L1_LID_ALTS=read_hdf_VD_L1(path,FNAME,'Lidar_Data_Altitudes')&help,L1_LID_ALTS
;===================================================================
var_xlt='Surface_Elevation'
L1_SURF_ELEV=read_hdf_L1(path,FNAME,var_xlt)&help,L1_SURF_ELEV
var_xlt='Total_Attenuated_Backscatter_532'
L1_TOT_BKS_532=read_hdf_L1(path,FNAME,var_xlt)&help,L1_TOT_BKS_532
var_xlt='Perpendicular_Attenuated_Backscatter_532'
L1_PER_BKS_532 = read_hdf_L1(path,FNAME,var_xlt)&help,L1_PER_BKS_532
var_xlt='Attenuated_Backscatter_1064'
L1_BKS_1064 = read_hdf_L1(path,FNAME, var_xlt)&help,L1_BKS_1064
;OPENW,lun,'/user1/chenb/data/LID_ALTS.data',/get_lun
;OPENW,lun,'E:\pic\LID_ALTS.data',/get_lun
;printf,lun,L1_LID_ALTS,format='(f)'
;FREE_LUN,LUN
END
;*****************************************************************************
;/////////////////////////////////////////////////////////////////////
pro get_color_tbl
common colors, r_orig,g_orig,b_orig,r_curr,g_curr,b_curr
red_c=[0.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,$
0.0,42.5,85.0,127.5,170.0,212.5,255.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,$
0.0,42.5,85.0,127.5,170.0,212.5,255.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,$
0.0,42.5,85.0,127.5,170.0,212.5,255.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,$
0.0,42.5,85.0,127.5,170.0,212.5,255.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,$
0.0,42.5,85.0,127.5,170.0,212.5,255.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,$
0.0,42.5,85.0,127.5,170.0,212.5,255.0,$
0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,255.0,255.0,255.0,255.0,255.0,$
0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,255.0,255.0,255.0,255.0,255.0,$
0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,255.0,255.0,255.0,255.0,255.0,$
0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,255.0,255.0,255.0,255.0,255.0,$
0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,255.0,255.0,255.0,255.0,255.0,$
0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,255.0,255.0,255.0,255.0,255.0,255.0,$
42.5,85.0,127.5,170.0,212.5,42.5,85.0,127.5,170.0,212.5,$
42.5,85.0,127.5,170.0,212.5,42.5,85.0,127.5,170.0,212.5,42.5,85.0,127.5,170.0,212.5]

green_c=[0.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,$
255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,$
255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,$
255.0,255.0,255.0,255.0,255.0,255.0,255.0,212.5,212.5,212.5,212.5,212.5,212.5,212.5,$
170.0,170.0,170.0,170.0,170.0,170.0,170.0,127.5,127.5,127.5,127.5,127.5,127.5,127.5,$
85.0,85.0,85.0,85.0,85.0,85.0,85.0,42.5,42.5,42.5,42.5,42.5,42.5,42.5,$
0.0,0.0,0.0,0.0,0.0,0.0,0.0,$
212.5,170.0,127.5,85.0,42.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,$
212.5,170.0,127.5,85.0,42.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,$
212.5,170.0,127.5,85.0,42.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,$
212.5,170.0,127.5,85.0,42.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,$
212.5,170.0,127.5,85.0,42.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,$
212.5,170.0,127.5,85.0,42.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,42.5,85.0,127.5,170.0,212.5,$
42.5,42.5,42.5,42.5,42.5,85.0,85.0,85.0,85.0,85.0,$
127.5,127.5,127.5,127.5,127.5,170.0,170.0,170.0,170.0,170.0,212.5,212.5,212.5,212.5,212.5]

blue_c=[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,42.5,42.5,42.5,42.5,42.5,42.5,42.5,$
85.0,85.0,85.0,85.0,85.0,85.0,85.0,127.5,127.5,127.5,127.5,127.5,127.5,127.5,$
170.0,170.0,170.0,170.0,170.0,170.0,170.0,212.5,212.5,212.5,212.5,212.5,212.5,212.5,$
255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,$
255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,$
255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,255.0,$
255.0,255.0,255.0,255.0,255.0,255.0,255.0,$
212.5,212.5,212.5,212.5,212.5,212.5,212.5,212.5,212.5,212.5,212.5,212.5,212.5,212.5,212.5,212.5,212.5,$
170.0,170.0,170.0,170.0,170.0,170.0,170.0,170.0,170.0,170.0,170.0,170.0,170.0,170.0,170.0,170.0,170.0,$
127.5,127.5,127.5,127.5,127.5,127.5,127.5,127.5,127.5,127.5,127.5,127.5,127.5,127.5,127.5,127.5,127.5,$
85.0,85.0,85.0,85.0,85.0,85.0,85.0,85.0,85.0,85.0,85.0,85.0,85.0,85.0,85.0,85.0,85.0,$
42.5,42.5,42.5,42.5,42.5,42.5,42.5,42.5,42.5,42.5,42.5,42.5,42.5,42.5,42.5,42.5,42.5,$
0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,$
0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,$
0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]

; Insert Grey Scale into color indices 10 to 22.

g_scale = [70,100,130,155,180,200,225,235,240,242,245,249,253]

red_c(10:22) = g_scale(0:12)
green_c(10:22) = g_scale(0:12)
blue_c(10:22) = g_scale(0:12)

red = replicate(0,256)
green = red & blue = red
red(0:218) = red_c
green(0:218) = green_c
blue(0:218) = blue_c
red(0) = red(49)
green(0) = green(49)
blue(0) = blue(49)
r_curr = red
g_curr = green
b_curr = blue
tvlct,red,green,blue
end
;////////////////////////////////////////////////////////////////////
PRO TIME_DECODE,ITIME,IYYMMDD,IHHMMSS,UTC
ITIME=ITIME-6
totalday=ceil(ITIME/86400)&help,totalday
GET_YYMMDD,totalday,1993,1,1,IYYMMDD
totsec=ITIME-86400*fix(ITIME/86400)
;print,totsec
HH=floor(totsec/3600)
tothh=totsec-3600*floor(totsec/3600);  &help,tothh
MM=fix(tothh/60)
SS=tothh-60*floor(tothh/60)
SS1=floor(SS)
SS2=round((SS-SS1)*10000)
;help,HH,MM,SS,SS2,SS1
IHHMMSS=string(HH,format='(i2.2)')+':'+string(MM,format='(i2.2)')+':'+$
  string(SS1,format='(i2.2)')+'.'+string(SS2,format='(i4.4)')
help,IHHMMSS
END
;///////////////////////////////////////////////
PRO GET_YYMMDD,totalday,by,bm,bd,IYYMMDD
ytotday=totalday
yy=by
mm=bm
dd=bd
if((long(yy+1) mod 4l) eq 0l) then begin
  if(((long(yy+1) mod 100l) eq 0l) and ((long(yy+1) mod 400l) ne 0l)) then begin
  while(ytotday gt 365) do GET_YY,ytotday,yy
  endif else begin
  while(ytotday gt 366) do GET_YY,ytotday,yy
  endelse
endif else begin
while(ytotday gt 365) do GET_YY,ytotday,yy
endelse
GET_MMDD,yy,ytotday,mm,dd
;help,yy,ytotday,mm,dd

IYYMMDD=string(yy,format='(i4.4)')+'-'+$
string(mm,format='(i2.2)')+'-'+string(dd,format='(i2.2)')
help,IYYMMDD
END
;/////////////////////////////////////
PRO GET_YY,ytotday,yy
  if((long(yy) mod 4l) eq 0l) then begin
    if(((long(yy) mod 100l) eq 0l) and ((long(yy) mod 400l) ne 0l)) then begin
    ytotday=ytotday-365
    yy=yy+1
    endif else begin
    ytotday=ytotday-366
    yy=yy+1
    endelse
  endif else begin
    ytotday=ytotday-365
    yy=yy+1
  endelse
END
;/////////////////////////////////////
PRO GET_MMDD,yy,ytotday,mm,dd
;************* 1month  *****************
if((ytotday le 31) and (ytotday ge 1)) then begin
mm=1
dd=ytotday
endif
;************* 2month  *****************


if((long(yy) mod 4l) eq 0l) then begin
  if(((long(yy) mod 100l) eq 0l) and ((long(yy) mod 400l) ne 0l)) then begin
  GET_MM,ytotday,mm,dd,0
  endif else begin
  GET_MM,ytotday,mm,dd,1
  endelse
endif else begin
  GET_MM,ytotday,mm,dd,0
endelse
END

;///////////////////////////////
PRO GET_MM,ytotday,mm,dd,leap
     if((ytotday le (59+leap)) and (ytotday gt 31)) then begin
        mm=2
        dd=ytotday-31
     endif  ;2 month
     if((ytotday le (90+leap)) and (ytotday gt (59+leap))) then begin
        mm=3
        dd=ytotday-59-leap
     endif  ;3month
     if((ytotday le (120+leap)) and (ytotday gt (90+leap))) then begin
        mm=4
        dd=ytotday-90-leap
     endif  ;4month
     if((ytotday le (151+leap)) and (ytotday gt (120+leap))) then begin
        mm=5
        dd=ytotday-120-leap
     endif  ;5month
     if((ytotday le (181+leap)) and (ytotday gt (151+leap))) then begin
        mm=6
        dd=ytotday-151-leap
     endif
     if((ytotday le (212+leap)) and (ytotday gt (181+leap))) then begin
        mm=7
        dd=ytotday-181-leap
     endif
     if((ytotday le (243+leap)) and (ytotday gt (212+leap))) then begin
        mm=8
        dd=ytotday-212-leap
     endif
     if((ytotday le (273+leap)) and (ytotday gt (243+leap))) then begin
        mm=9
        dd=ytotday-243-leap
     endif
     if((ytotday le (304+leap)) and (ytotday gt (273+leap))) then begin
        mm=10
        dd=ytotday-273-leap
     endif
     if((ytotday le (334+leap)) and (ytotday gt (304+leap))) then begin
        mm=11
        dd=ytotday-304-leap
     endif
     if((ytotday le (365+leap)) and (ytotday gt (334+leap))) then begin
        mm=12
        dd=ytotday-334-leap
     endif
END
;******************************************************************
;///////////////////////////////////////////////////////////////////////////
;pro color_clr_ratio,color
;red=[0,221,255,  0,  2,  1,  2,  0,242,251,251,249,163,168,173,161,205,246,250]
;grn=[0,221,  0,  0, 49,172,156,197,244,166,  1,207,  2,206,255,249,251,247,250]
;blu=[0,221,  0,255,165,250,255,  2,  2,  1,251,247,132,251,255,203,205,197,248]
;tvlct,red,grn,blu
;end
;///////////////////////////////////////////////////////////////////////////
pro color_clr_ratio,color
red=[0,221,  0,  0,  0,255,255,255,255,255,170,127,170,170,170,170,205,255,255,127]
grn=[0,221,  0,170,212,255,170,  0,  0,212, 85,  0,  0,212,255,255,251,255,255,127]
blu=[0,221,255,255,  0,  0,  0,  0,255,255,255,170,127,255,255,212,205,212,255,127]
tvlct,red,grn,blu
end
;///////////////////////////////////////////////////////////////////////////
pro color_dep_ratio,color
red=[0,221,  0,  1, 40,255,253,255,253,253,170,255]
grn=[0,221,  0,176,211,255,172,  0,  1,211, 83,255]
blu=[0,221,255,250,  1,  0,  1,  0,253,253,255,255]
tvlct,red,grn,blu
end
;///////////////////////////////////////////////////////////////////////////
;*****************************************************************************
pro color_tab,color
red=[0,0,  255,0,   255,255,255,77,255,150,150,2  ,204,255,130]
grn=[0,0,  0,  250, 0,  255,255,77,255,50 ,50 ,160,51 ,204,87]
blu=[0,255,0,  0 ,  255,0,  125,77,255,20 ,200,168,0  ,0,  0]
tvlct,red,grn,blu
end
;///////////////////////////////////////////////////////////////////


;//////////////////////////////////////////////////////////

;/////////////////////////////////////////////////////////////////////////////;*
;******************************************************************
PRO psopen, psfname

   set_plot,'ps'
   device, /encapsulated,preview=2
   device, filename=psfname
   device, /helvetica, /bold, font_size=20
   device, /color, bits_per_pixel=8  ; 2**8=256 colors
   device, /landscape
   device, xsize=10.0, ysize=8.0,/inch
   device, xoffset=0.5, yoffset=10.5,/inch

   !p.font = 0
   !p.thick=6.5
   !x.thick=4
   !y.thick=4

 !x.ticklen = 0.042  &  !y.ticklen = 0.031
 !p.charsize=1.8


END

;-----------------

PRO psclose
  device,/close
  !p.multi=0

  !p.thick=1
  !x.thick=1
  !y.thick=1
  !p.charsize=1
  set_plot,'ps'
END

;PRO Read_HYSPLIT,sitename,HYSPLIT_DATA
;
;   HYSPLIT_fn='D:\My paper\New paper-dust storm\DATA\HYSPLIT\'
;   HYSPLIT_DATA=fltarr(13,1000)
;   HYSPLIT_filename=HYSPLIT_fn+sitename+'_backward.txt'
;   j=0
;   JUMP:
;   openr,lun,HYSPLIT_filename,/GET_LUN
;   Var1='' & Var2='' & Var3='' & Var4='' &  Var5='' & Var6='' &  Var7='' &  Var8=''
;   readf,lun,Var1  & readf,lun,Var2 & readf,lun,Var3 & readf,lun,Var4
;   readf,lun,Var5  & readf,lun,Var6 & readf,lun,Var7 & readf,lun,Var8
;
;   data=fltarr(13,1)
;   WHILE EOF(lun) NE 1 DO BEGIN
;   readf,lun,data
;   HYSPLIT_DATA(*,j)=data
;   j=j+1
;   ENDWHILE
;   close,lun & free_lun,lun
;
;   IF HYSPLIT_filename EQ HYSPLIT_fn+sitename+'_backward.txt' THEN BEGIN
;     HYSPLIT_filename=HYSPLIT_fn+sitename+'_forward.txt'
;     GOTO,JUMP
;   ENDIF
;   help,HYSPLIT_DATA
;   HYSPLIT_DATA=HYSPLIT_DATA(*,1:(j-1))
;   HYSPLIT_DATA=HYSPLIT_DATA(*,SORT(HYSPLIT_DATA(8,*)))
;
;END
