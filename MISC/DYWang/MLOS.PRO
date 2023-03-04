;
; subroutine mlos
;
; Originally written by Chin Tai (April, 1991)
;
; Converted into IDL by Dan Charrois (May, 1993)
;The line

; ee=-0.0044*sin(125.0-.05295D0*day)-.0003*sin(200.9+1.97129D0*day)is not correct.

 ;Comapred to the orginal FORTRAN routine OA_EPHEM.F (attached here)

        ;EE=-0.0044*SIND( 125.0 -0.05295*DAY )
       ; 1  -0.0003*SIND( 200.9 +1.97129*DAY )

; The argument in IDL must be converted into degree, as did in my  SAT_lat_long.pro.



pro mlos,fov,row,col,time,dircos_eci,limb_pt,dist_st,geod_lat,$
    long,geod_alt,look_angle,transform,sat_pos,ypr,iypr,$
    nvo,nho,nvb,nhb,nvw,nhw,tt,t2

common mlos,int_d,alpha_1,beta_1,skew_1,alpha_2,beta_2,skew_2

dircos_ipf=dblarr(3)
dircos_omf=dblarr(3)
fov=1
pi_d_180=3.14159265358979323846D0/180.0
if fov eq 1 then rcol=160.0D0-nho-nhw+nhb*(col-0.5) $
else rcol=nho+nhb*(col-0.5D0)
rrow=240.0D0-nvo-nvw+nvb*(row-0.5)
omega=pi_d_180*.0242
theta_H=omega*(rcol-80.0D0)
theta_V=omega*(239.0D0-rrow)
dircos_IPF(0)=sin(theta_V)
dircos_IPF(1)=sin(theta_H)
dircos_IPF(2)=cos(theta_H)*cos(theta_V)

if fov eq 1 then t=reform(t2(0,*,*))$
else t=reform(t2(1,*,*))


;
; Compute IPF to IRF transformation
;

dircos_IRF1=T(0,0)*dircos_IPF(0)+T(0,1)*dircos_IPF(1)+T(0,2)*dircos_IPF(2)
dircos_IRF2=T(1,0)*dircos_IPF(0)+T(1,1)*dircos_IPF(1)+T(1,2)*dircos_IPF(2)
dircos_IRF3=T(2,0)*dircos_IPF(0)+T(2,1)*dircos_IPF(1)+T(2,2)*dircos_IPF(2)
;
; Compute IRF to OMF transformation
;
; The following is only used if it is desired to use the yaw, pitch, and
; roll of the satellite to compute the IRF misalignment matrix instead of
; using one matrix per yaw period.  Although we are currently calling this
; subroutine with iypr=0, it is included here in case we change our mind.
;
if iypr eq 1 then begin
  cpsi=cos(ypr(1)*pi_d_180)
  spsi=sin(ypr(1)*pi_d_180)
  cth=cos(ypr(2)*pi_d_180)
  sth=sin(ypr(2)*pi_d_180)
  cphi=cos(ypr(0)*pi_d_180)
  sphi=sin(ypr(0)*pi_d_180)
  tt(0,0)=cpsi*cpsi-sth*spsi*sphi
  tt(0,1)=-cth*sphi
  tt(0,2)=spsi*cphi+sth*cpsi*sphi
  tt(1,0)=cpsi*sphi+sth*spsi*cphi
  tt(1,1)=cth*cphi
  tt(1,2)=spsi*sphi-sth*cpsi*cphi
  tt(2,0)=-cth*spsi
  tt(2,1)=sth
  tt(2,2)=cth*cpsi
endif

dircos_OMF(0)=tt(0,0)*dircos_IRF1+tt(0,1)*dircos_IRF2+tt(0,2)*dircos_IRF3
dircos_OMF(1)=tt(1,0)*dircos_IRF1+tt(1,1)*dircos_IRF2+tt(1,2)*dircos_IRF3
dircos_OMF(2)=tt(2,0)*dircos_irf1+tt(2,1)*dircos_IRF2+tt(2,2)*dircos_IRF3
;
; Computes ECI direction cosines for given line of sight
;
dircos_ECI(0)=transform(0,0)*dircos_OMF(0)+transform(0,1)*dircos_OMF(1)+$
       transform(0,2)*dircos_OMF(2)
dircos_ECI(1)=transform(1,0)*dircos_OMF(0)+transform(1,1)*dircos_OMF(1)+$
       transform(1,2)*dircos_OMF(2)
dircos_ECI(2)=transform(2,0)*dircos_OMF(0)+transform(2,1)*dircos_OMF(1)+$
       transform(2,2)*dircos_OMF(2)

; *******************************************************************
; The original FORTRAN source now called OA_LIMB_CALC here.  But since IDL
; needs a file for every procedure, and this procedure is only used
; once, it is included right here, inline.

view_vec=double(dircos_eci) ; just to make the variable names the same
             ; and to make sure we use double arithmetic
;
; Equatorial radius and flattening of ellipsoid
;
A=6378.140D0
F=1/298.257D0

FAB2=1/((1-F)*(1-F))
FC=1.689D-5 ;=4-2*f-sqrt(16/(1+FAB2-1)/2))


look_angle=0.0
limb_pt(0)=0.0
limb_pt(1)=0.0
limb_pt(2)=0.0
;
; Attempt to normalize VIEW
;
v2=view_vec(0)*view_vec(0)+view_vec(1)*view_vec(1)+view_vec(2)*view_vec(2)
;
; If VIEW given, compute and return ECI limb tangent point
;
if v2 ne 0 then begin
  pdotv=(double(sat_pos(0))*view_vec(0)+sat_pos(1)*view_vec(1)+$
    sat_pos(2)*view_vec(2))/sqrt(v2)
  if pdotv ge 0.0 then begin
    x=sat_pos(0)
    y=sat_pos(1)
    z=sat_pos(2)
  endif else begin
    x=sat_pos(0)-pdotv*view_vec(0)
    y=sat_pos(1)-pdotv*view_vec(1)
    z=sat_pos(2)-pdotv*view_vec(2)
  endelse
  limb_pt(0)=x
  limb_pt(1)=y
  limb_pt(2)=z
; otherwise, use satellite position for X,Y,Z
endif else begin
  x=sat_pos(0)
  y=sat_pos(1)
  z=sat_pos(2)
endelse
; compute radius at X,Y,Z
r2=x*x+y*y+z*z
r=sqrt(r2)
;
; if VIEW_VEC given, compute LOOK_ANGLE at limb tangent point
;
if v2 ne 0 then begin
  vdote=-view_vec(0)*y+view_vec(1)*x
  vdotn=-view_vec(0)*x*z-view_vec(1)*y*z+view_vec(2)*(x*x+y*y)
  if (not((r*vdote eq 0)and(vdotn eq 0)))$
     then look_angle=atan(r*vdote,vdotn)/pi_d_180 $
  else begin
    if z le 0 then geod_lat=-90.0 else geod_lat=90.0
    look_angle=9999999.0
  endelse
endif else look_angle=9999999.0
;
; Convert geocentric latitude to geodetic latitude
;
if (not ((x eq 0) and (y eq 0))) then begin
  tph=z/sqrt(x*x+y*y)
  geod_lat=atan(fab2*tph)/pi_d_180
endif else begin
  if z le 0 then geod_lat=-90.0 else geod_lat=90.0
endelse
;
; Compute and subtract radius of ellipsoid
;
if r2 ne 0 then begin
  sph2=z*z/r2
  geod_alt=r-a*(1-(f+fc-fc*sph2)*sph2)
endif else begin
  geod_alt=-9999999.9
endelse
;
;*********************************************************************
; Now, we must get Greenwich apparent sidereal time.  Again, this was
; called as the function OA_EPHEM in the original FORTRAN source, but
; since it is not used anywhere else and I want to avoid file clutter,
; it's included here inline.  Besides, the original source did more than
; we need.

;
; Days since epoch J2000.0
;
iyr=time(0)/1000.0D0
day=365.0D0*iyr+(iyr-1)/4.0+(time(0) mod 1000D0)-36525.5
;
; approximate the equation of the equinoxes
;
ee=-0.0044*sin(125.0-.05295D0*day)-.0003*sin(200.9+1.97129D0*day)
gst0=24110.54841d0/240.0
gst1=8640184.812866d0/36525.0D0/240.0D0
gst2=(360.0D0+gst1)/86400000d0
v=ee+gst0+gst1*day+gst2*time(1)-360D0*(iyr-100D0)
grnw_sid_time=v mod 360D0
if grnw_sid_time lt 0 then grnw_sid_time=grnw_sid_time+360.0D0
;
; Now, OA_EPHEM is done what we need it to do, so we return to the
; 'calling' procedure...
;
if (not((x eq 0) and (y eq 0))) then begin
  ra=atan(y,x)/pi_d_180
  long=(720.0D0+ra-grnw_sid_time) mod 360D0
  if long lt 0 then long=long+360.0
endif else begin
  if z lt 0 then geod_lat=-90.0 else geod_lat=90.0
  long=-9999999.0
endelse
;
; Now, OA_LIMB_CALC is done, so we return to its calling procedure
;

dist_ST=sqrt((sat_pos(0)-limb_pt(0))^2+(sat_pos(1)-limb_pt(1))^2+$
         (sat_pos(2)-limb_pt(2))^2)
return
end
