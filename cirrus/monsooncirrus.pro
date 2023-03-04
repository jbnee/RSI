pro monsooncirrus

filename='f:\rsi\cirrus\EASM_month_10_20KM.txt'
close,/all
OPENR,1,filename
H=FLTARR(4,55) ;A big array to hold the data
A=FLTARR(4) ;A small array to read a line
cirrus=fltarr(3,12)
mondata=fltarr(2,12)
on_IOERROR,ers
line=''
readf,1,line
readf,1,line
FOR n=0,99 DO BEGIN
READF,1,A ;Read a line of data
PRINT,A ;Print the line
H[*,n]=A ;Store it in H
ENDFOR
ers:CLOSE,1
;stop
sz=size(H);
clm=Sz[1]
row=Sz[2]
cirrus=fltarr(3,12)
sum=0
stop
   For i=0,11 do begin
     ;for J=0,11 do begin
        print,H[3,i],H[3,i+12],H[3,i+24],H[3,i+36]

        cirrus[0,i]=H[1,i]+H[1,i+12]+H[1,i+24]+H[1,i+36] ; number of events
        cirrus[1,i]=H[2,i]+H[2,i+12]+H[2,i+24]+H[2,i+36]  ;total counting
        cirrus[2,i]=H[3,i]+H[3,i+12]+H[3,i+24]+H[3,i+36]  ;month


   endfor
stop

END