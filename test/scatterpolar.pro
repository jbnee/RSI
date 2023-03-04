Pro scatterPolar
; scattering intensity of light refracted once in a spherical drops of radius a=1
;y is the scattering angle

 x=findgen(180)
  n=1.33
  p=cos(x/2)
  q=sin(x/2)

  y=(1-q/(sqrt(n^2-p^2)))
  plot,x,y
    plot,y,x, /polar
  x=findgen(360)
  plot,y,x, /polar
 end