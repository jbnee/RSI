pro Transmision_O3_532
km=24*findgen(1250)
; ozone transmission at 532 nm
;TO3 is the ozone transmission at 532 nm
  TO3=6.8828e-008*km^4 - 6.8432e-006*km^3 + 1.5743e-004*km^2 - 0.0015*km + 1.0011
  plot,TO3,km
  stop
  end
