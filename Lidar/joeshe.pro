PRO  Joeshe

device, decomposed=0

!p.multi=[0,1,2]
!p.background=255
 loadct,39
;plot,[0,10],[-1,1],COLOR = 0
;plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
;oplot,[0,20],[1.5,1.5],COLOR = 50

;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'c:\idl62\hues.dat'
readf,2,rgb
close,2
free_lun,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 col = 240 ; don't change it

  cmax=300;max(T);400;1500;500;./2
  cmin=min(0)
  ;nlevs=40
  ;nlevs_max=40
  nlevs_max = 20 ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

 col = 240 ; don't change it
 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white

 plot_position1 = [0.1,0.15,0.93,0.95]; plot_position=[0.1,0.15,0.95,0.45]
;plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.97,0.7,0.99,0.95]
 ;BAR_POSITION2=[0.97,0.7,0.99,0.95]

 ;f1=string(ni,format='(I3.3)')
 ;f2=string(nf,format='(I3.3)')
 ;f3=f1+'--'+f2
 ;s1=strtrim(fix(ni),2)
; s2=strtrim(fix(nf),2)
 ;S='                                       file:'+s1+'_'+s2;used to print title


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cd,'c:\JB\JSHE0918\data2'
qf=file_search()
szf=size(qf)
nmf=szf[1]
For I1=0,nmf-1 do begin
filename=qf[I1]
;filename='c:\JB\JSHE0918\Tint8242nw4cm-80806sg4nFwCZ20NofE0.N60z2';
; Tint8275nw4cm-80806sg4nFwCZ20NofE0.N60z2';
;Tint8243nw4cm-80806sg4nFwCZ20NofE0.N60z2'
;Tint8242nw4cm-80806sg4nFwCZ20NofE0.N60z2';
  ;Tint8241nw4sg4nFnCZ20NofE0.N60z2'
  ;Tint8213nw4cm-80806sg4nFwCZ20NofE0.N60z2';cirrus\EASM_month_10_20KM.txt'
close,/all
OPENR,1,filename
H=FLTARR(60,500) ;A big array to hold the data
A=FLTARR(60) ;A small array to read a line
;DATA1=fltarr(3,12)
;mondata=fltarr(2,12)
on_IOERROR,ers
line=''
for i2=0,40 do begin; skip 34 lines of strings
readf,1,line
;print,line
y=strpos(line,'69.956')
if (y NE -1) then print,i2,y
n0=i2  ; first data
endfor  ;i2
;readf,1,line
stop
n=0
FOR n=0,399 DO BEGIN  ; this is data
READF,1,A ;Read a line of data
;PRINT,A ;Print the line
for j=0,25 do begin
 x=A[j]
 if (x GT 990) then x=-1
 A[j]=x
 ;print,A
endfor   ;n
H[0:25,n]=A ;Store it in H
ENDFOR
ers:CLOSE,1
;;;
;stop
;x=where(H[0,*]  eq 0)
;y=min(x)

;sz=size(H);
;col=Sz[1]
;row=Sz[2]
T=H(3:9,180:n-1)
Ht=H[0,180:n-1]
x=findgen(7)+3.5
;stop

 contour,T,x,ht,xtitle='U Time',ytitle='ht',LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,title=S,position=plot_position1
; xyouts,1.5*max(x),0.2*max(y),f3,/device
 ;stop
 ; plot a color bar, use the same clevs as in the contour

   ; nlevs=40
    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION1,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase


 stop
  DEVICE, DECOMPOSED=0
  fout='C:\JB\JSHE0918\output2\';
  fnm=strmid(filename,4,4);
  ;read,fnm,prompt='filename to output'
  cntrname =fout+"T"+fnm+'.tiff'

  WRITE_tiff, cntrname, TVRD(/TRUE)
  close,2
  endfor  ;I1
stop
END