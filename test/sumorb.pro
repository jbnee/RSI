pro sumorb
close,/all
b=fltarr(5,180)
c=fltarr(3,43)
openr,1,'d:\origin\SEP2008_7774_orb_rec3_7.txt'
readf,1,b
close,1
sig=0.
 k=0.
 L=1
;initial condition
 rec=b[2,L-1]
 orb=b[3,L-1]
 sig=b[4,L-1]
 ;print,L,rec,orb,sig
 ;stop
while (L LT 180) do begin
while (b[3,L] eq orb) do begin
  sig=sig+b[4,L]
  ;stop
  print,L,orb,sig
   L=L+1
; stop

endwhile
   c[0,k]=k
   c[1,k]=orb
   c[2,k]=sig
  k=k+1
  print,L,K,sig,b[3,L],c[0:2,k-1]
  ;L=L+1
  ;stop
;endelse
rec=b[2,L]
 orb=b[3,L]
 sig=0
 ;k=k+1
;L=L+1

endwhile
;endfor
stop
end