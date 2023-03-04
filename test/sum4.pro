pro sum4
b=fltarr(5,172)
c=fltarr(3,43)
openr,1,'d:\origin\SEP2008_7774_orb_rec3_7.txt'
readf,1,b
close,1
sig=0.
k=0.
;for L=0,171 do begin
L=0
while (L LT 172) do begin
rec=b[2,L]
orb=b[3,L]
;if (b[3,L+1] eq orb) then begin
sig=sig+b[4,L]+b[4,L+1]+b[4,L+2]+b[4,L+3]+b[4,L+4]
;endif
c[0,k]=k+1
c[1,k]=orb
c[2,k]=sig
;print,L,K,c[*,k]
;k=k+1
;endif
k=k+1
L=L+5
sig=0
endwhile
;endfor
stop
end