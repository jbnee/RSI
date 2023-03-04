
   pro solar_image_outline_sub,Zsc,Ztn,xsi_km,ysi_km,ysir_km,xsi_am,ysi_am,ysir_am

;----------------------------------------------------------------------------------------
;
;  Routine generates a solar image outlines at the tangent point for a limb view,
;  with and without refraction of solar rays by the Earth's atmosphere.
;  The routine will place the sun image center at the specified tangent 
;  point altitude. 
;
;  Currently the routine contains a representation of the refraction angle 
;  versus altitude based on model calculations for 0.8 microns wavelength. 
;
;  Input:
;    Zsc......spacecraft altitude, km
;    Ztn......tangent point altitude, km
;
;  Output:
;    xsi_km......points on solar image in x-direction, km
;    ysi_km......points on solar image in y-direction, km
;    ysir_km.....points on refracted solar image in y-direction, km (goes with xsi_km)
;    xsi_am......points on solar image in x-direction, arcmin
;    ysi_am......points on solar image in y-direction, arcmin
;    ysir_am.....points on refracted solar image in y-direction, arcmin (goes with xsi_am)
;
;  Example:  plot aparent solar images at 20 km tangent height for a satellite in 600 km orbit
;
;    the IDL code:
;
;    solar_image_outline_sub,600,20,xsi_km,ysi_km,ysir_km,xsi_am,ysi_am,ysir_am
;
;    plot,xsi_km,ysi_km,xtitle='azimuth (km)',ytitle='altitude (km)',title='dashed: refracted'
;    oplot,xsi_km,ysir_km,line=2
;
;    plot,xsi_am,ysi_am,xtitle='azimuth (arcmin)',ytitle='altitude (arcmin)',title='dashed: refracted'
;    oplot,xsi_am,ysir_am,line=2
;
;  Source:  Mark Hervig
;
;----------------------------------------------------------------------------------------

;- some constants

   Dts  = 1.5e8     ; mean distance from earth to sun, km
   Rs   = 695950.0  ; sun radius, km (+/- 810 km)
   Re   = 6378.0    ; mean earth radius, km

;- calculate some geometric values

   s2t   = sqrt((Zsc+Re)^2 -(Ztn+Re)^2)  ; distance from S/C to tangent point, km
   Ri_km = s2t * (Rs / Dts)              ; radius of solar image, km
   Ri_am = Ri_km / s2t * (60*180/!pi)    ; radius of solar image, arcmin

;- approximate the refraction angle vs. altitude
;- below is for 0.8 microns wavelength and a standard atmosphere

   nz = 70                    ; number of altitudes
   za = findgen(nz) + 1.0     ; apparent altitude grid, km

   r  = [2.00275,-0.0633366]  ; polynomial coefficients,  ra vs. za
   ra = 10^poly(za,r)         ; refraction angle vs. za, arcmin

;- determine refraction of the solar image vs. view angle

   np   = 101 

   z    = ((findgen(np+1))) / (np/2.)  ; grid of points in the vertical
   pos  = Rs * z                       ; points on the actual sun

   aos  = atan( pos / ( s2t + Dts) )   ; view angles to pos,  radians
   zsi  = Ri_km * z                    ; apparent altitude of points on solar image, km

   dz   = fltarr(np)    ; height shift due to refraction
   rva  = fltarr(np)    ; refracted view angle,  view angle to sun - refraction angle

   for i = 0,np-1 do begin

     y      = Ztn + zsi(i) - ri_km                ; apparent altitude of each point on the sun
     rang   = interpol(ra,za,y) * (!pi/180.)/60.  ; interpolate refraction angle to y
     dz(i)  = s2t * tan(rang)                     ; height shift due to refraction, km
     rva(i) = aos(i) - rang                       ; refracted view angle,  radians

   endfor

;- interpolate height shift (dz) vs. refracted view angle (rva) to sun view angle (aos)

   k    = where(rva gt 0,nk)

   dz2  = interpol(dz(k),rva(k),aos)

   zsi  = zsi - ri_km  ; shift the solar image height scale down so sun center is at tangent

   zsir = zsi + dz2    ; altitude of points on refracted solar image

;- generate apparent vs. refracted solar image point scales 

   asi  = zsi  * (Ri_am/Ri_km)    ; convert the height scale to arcmin
   dam  = dz2  * (Ri_am/Ri_km)    ; delta angle,  arcmin

   asir = asi + dam               ; angle to refracted solar image, arcmin

;- generate a solar image at the limb,  i.e., make a circle

   np  = 101
   x   = ((findgen(np+1))- (np-1)/2.) / ((np-1)/2.)  ; grid of points

   xsi = Ri_km * x               ; points on a half circle in x,  km
   ysi = sqrt(Ri_km^2 - xsi^2)   ; points on a half circle in y,  km

   xsi_km = [xsi(0:np-1),reverse(   xsi(0:np-1))]  ; make the half circle whole
   ysi_km = [ysi(0:np-1),reverse(-1*ysi(0:np-1))]

   xsi_am = xsi_km * (Ri_am/ri_km)  ; solar image x in arcmin
   ysi_am = ysi_km * (Ri_am/ri_km)  ; solar image y in arcmin

   npt  = n_elements(ysi_km)    ; # points on the whole circle

;- refract the solar image using the refraction "profile" determined above
 
   ysir_km = fltarr(npt)   ; refracted image, km
   ysir_am = fltarr(npt)   ; refracted image, arcmin

   if (Ztn gt 60) then begin  ; no refraction above here
     ysir_km = ysi_km
     ysir_km = ysi_km
     goto, jump1
   endif

   for i = 0,npt-1 do begin

     ysir_km(i) = interpol(zsir,zsi,ysi_km(i))   ; interpolate height shift to point on solar image, km

     ysir_am(i) = interpol(asir,asi,ysi_am(i))   ; interpolate height shift to point on solar image, km

   endfor    

   jump1:

   ysi_km  = ysi_km  + Ztn
   ysir_km = ysir_km + Ztn

   return
   end
