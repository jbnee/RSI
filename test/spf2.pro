Pro SPF2; calculate equatorial channel 5 (777.4nm) signal for recors 8,9,10,11
close,/all
n=0
m=0
a=fltarr(8,907)  ;a is the data array
b=fltarr(5,180)  ; b is the array for records betwen [8,11]
c=fltarr(2,43)

m=0
k=0
openr,1,'d:\rsi\ISUAL\SPF200809D.txt'

readf,1, a
for n=0 , 906 do begin
rec=a[1,n]
orb=a[0,n]
;while (m lt 179) do begin
if (rec GE 3) and (rec LT 8) then begin
;while (m lt 180) do begin
b[0,m]=m
b[1,m]=n
b[2,m]=rec  ; rec
b[3,m]=orb;orbit
b[4,m]=a[7,n]; 7774 signal
print,b[*,m]
if (m lt 179) then begin
m=m+1
endif
endif
;endwhile
;m=m+1
endfor
stop
sig=0
j=0
L=0
sig=0.
k=0.
;for L=0,171 do begin
L=0
while (L LT 172) do begin
rec=b[2,L]
orb=b[3,L]
;if (b[3,L+1] eq orb) then begin
sig=sig+b[4,L]+b[4,L+1]+b[4,L+2]+b[4,L+3]+b[4,L+4] ;records used
;endif
c[0,k]=k+1
c[1,k]=orb
c[2,k]=sig
;print,L,K,c[*,k]
;k=k+1
;endif
k=k+1
L=L+5  ;or 4 for 4 or 5 records selected
sig=0
endwhile
;endfor
stop
;for L=0,172 do begin
;while (L LE 172) do begin
 ; rec2=b[2,L]
  ;orb2=b[3,L]
  ;sig=b[4,L]

  ;if (orb2 eq b[3,L]) then begin
   ;sig=sig+b[4,L]

 ;   print,L,k,rec2, orb2,sig
    ;endif else begin
  ;  c[0,j]=orb2
   ; c[1,j]=sig
  ;endif else begin
   ;k=0
   ;j=j+1
   ;sig=0
;endelse
;endfor
;endwhile
;close,1

stop

;end
;close,1
end
