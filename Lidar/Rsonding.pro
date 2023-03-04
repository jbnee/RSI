Pro RSonding
; _data,Rdata,km,T,RH,WS,WD

;close,/all
;file1=''
;read,file1,prompt='input radiosonde data file:  '
;openr,1,'c:\JB\file1';  R020323.txt'
;OPENR, 1, 'd:\rsi\test\radioson2000_0101AM.txt'
; Define a string variable:

;line = ''
;readf,1,line

H=FLTARR(9,100) ;H a big array to hold the data
A=FLTARR(9) ;A small array to read a line
Rdata=''
read,Rdata,prompt='Radio data filename:?'

file1='c:\JB\'+Rdata+'.txt'
openr,1,file1
on_IOERROR,ers
line=''
for ln=0,4 do begin
readf,1,line
print,line
endfor

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

sum=0
print,'sonding file:',clm,row
;stop

   For j=0,8  do begin
   For i=0,70 do begin

     if (H[j,i] EQ 999.9) then H[j,i]=H[j,i-1]
      if (H[j,i] EQ 999) then H[j,i]=H[j,i-1];do not delete
   endfor   ;i
   endfor   ;j
   pr1=H[2,*]
   km1=H[3,*]/1000.0
   T1=H[4,*]
   RH1=H[5,*]
   Dew1=H[6,*]
   WD1=H[7,*]
   WS1=H[8,*]
   ;return,km,T, RH
   t0=min(T1)
   S0=min(where(T1 eq t0))+10
   km=km1[0:S0]
   T=T1[0:S0]
   RH=RH1[0:S0]
   WD=WD1[0:S0]
   WS=WS1[0:S0]
  stop
 end
;ENDWHILE
