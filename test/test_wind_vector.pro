Pro test_wind_vector
for i=0,361-1 do begin
  for j=0,181-1 do begin
  background(i,j)=sin(i*1./360.)+cos(j*1./180.)                                                         ;set values
 ; if(j eq 60)then begin
  U(i,j)=i*5.
  V(i,j)=j^2
  ;endif
  endfor
  endfor
  stop

  U = RANDOMN(S, 361, 181)                                                                              ;set U values
  V = RANDOMN(S, 361, 181)
                                                                             ;set V values
stop
end