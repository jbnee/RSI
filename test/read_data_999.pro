PRO Read_DATA_999
erase
;with interpolation
; read unknow number of elements; H, filename,COLUMNS=cols,ROWS=rows
fname='E:\RSI\test\WaterVapor_data.txt'; rsi\cirrus\';   ;35data.txt'
;data1='ASM_10_20km.txt'
;fname='F:\Radiosonde\CWB2010\Sounding_20100503_00z.txt';T2005se0512.txt'
;read,data1,prompt=' where is data? AS d:\rsi\test\Lidar_T2001ja16.txt'
;fname=fpath+data1
Xdata=read_ascii(fname)
 Mdata=Xdata.(0)
stop
S1=size(Mdata);
rows=4;
col=60;
H=Mdata(1:4,1:60);

 For i=0,rows-1  do begin; ith column
   For j=0,col-1 do begin  ;jth raw
   ; A[j,i]=H[j,i]
     if (H[i,j] LT 0) then H[i,j]=(H[i-1,j]);+H[i,j-2])/2
         ;if (H[i,j] eq 999.) then H[i,j]=(H[i,j-1]+H[i,j-2])/2


   endfor   ;i

 endfor   ;i
 Nrow=indgen(rows-1)

;!p.multi=[0,4,1]
; plot_position1 = [0.1,0.15,0.3,0.9]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.4,0.15,0.6,0.9];
; plot_position3 = [0.7,0.15,0.9,0.9]
T1=indgen(col-1)


plot,T1,H(0,*),background=-2,color=2,psym=2,xtitle='Day no',ytitle='H2O',title=' H2O AIRS',$
charsize=2,yrange=[10,20];position=plot_position1
oplot,T1,H(1,*),color=25,psym=4
oplot,T1,H(2,*),color=85,psym=5
oplot,T1,H(3,*),color=125,psym=6




stop


plots='E:\RSI\test\Taal_H2O.bmp'
write_BMP,plots,tvrd(/true)
;printf,2,meanH
;close,2
;stop
;j=0
stop
END