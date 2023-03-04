
pro cwb_with_interpolation
close,/all
;********************************************************************************************
;                       INFORMATION ABOUT SOFTWARE
;********************************************************************************************
; NAME:
;           RAS (RADIOSONDE ANALYSIS SOFTWARE)
;
; PURPOSE:
;            To analysis radiosonde data for CPT without interpolation of data
;
; INPUTS:
;      Year,Month,Year,Time and desired parameter to be analysed
;
; MODIFICATION HISTORY:
;            S.K.Das,    2007 Jan 27
;
;        Copyright (C) 2007, National Central University/Lidar Laboratory
;        This software may be used, copied, or redistributed within university
;        as long as it is not sold.
;
;###########################################################################################
;                         PROGRAM
;###########################################################################################

;***************************  READ PATH OF FILE & FIND IT  *********************************
;
;start with a colour table, read in from an external file
rgb = bytarr(3,256)
openr,2,'d:\rsi\hues.dat'
readf,2,rgb
close,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b

!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels

path='c:\radiosonde\cwb_data\' ;data place
file=File_search(path+'T*')  ; to list the number of files which starts with file name with T
file_list=file_basename(file);to show the last part of the file name.


year='2003' ; for reading the year as an variable quantity (and variable is always string)
month=''  ; '' has been used to indicate that it is string
time='12'
z1=10
z2=25
cpt1=fltarr(400);
cpt_h1=fltarr(400);
pindex=0
;stop
;read,year,prompt='Enter which year: ';promt is a command to enter variable from desktop
;read,month,prompt='Enter which month from 1 to 12: ';
;month=1
for month=3,12 do begin

pindex=0
;read,time,prompt='Select the UTC time(00/12): '
;read,z1,prompt='Enter starting height (km): '
;read,z2,prompt='Enter ending height (km): '
if strlen(month) eq 1 then month='0'+month  ;To count string length and to change month=1 to month=01
yy=strmid(file_list,1,2); r=strmid('string',start position,length).For taking out the year from the file name
mm=strmid(file_list,3,2); for taking out the month from the file i.e if T0209, so this comand will take 09
yr=strmid(year,2,2)
compare=where(yy eq yr and mm eq month)     ;to check yy is equal to yr
file_name=file_list(compare)    ;upto this part of the program u can know which file u want
print,'filename  ',compare,file_name
;stop
;
;************************  TO READ THE DESIRED FILE  ***********************************************
;
openr,lun,path+file_name,/get_lun; file(filename) is taken bcz it will
                   ;search file name(like T0213) from many files(T0212,T0506 etc)

line=''
first6=''
check_t='Time'
check_z='Z'
check_no='N'
;read,plot_name,prompt='Enter the output file plot name'; to be set for ps plot
;set_plot,'ps'; to be set for ps plot; to be set for ps plot
;device,filename=path+plot_name+'.ps',/times,/bold

idx=0
;while not eof(lun) do begin
    p_year=-1
    p_month=-1
    while (p_year eq -1 or p_month eq -1) do begin;to check the position of year,month and date
  ; while not eof(lun) do begin
        readf,lun,line;to store data in line which is a variable
        p_year=STRPOS(line,year);to show the string position of year(start letter only) in the line not the value
        p_month=STRPOS(line,month,p_year+4);to show the string position of month in the line not the value
              ; 4 has been added bcz it will add after the year (2003.01)
        ;print,'p_year  ',p_year
        ;print,'p_month  ',p_month
  ; endwhile

       p_time=STRPOS(line,check_t);to give position of time
       p_z=STRPOS(line,check_z);to give position of Z
    if (p_time ne -1 and p_z ne -1) then $; $ sign for conbtinuation of line
       tm=strmid(line,p_z-2,2);to give the value of time i.e. either 12 or 00
  ; endwhile
;
;************************  TO FIND DATE AND TIME WITHIN THE FILE  ***********************************************
;
    if (time eq tm) then begin;if (date eq dt and time eq tm) then begin
       p_no=-1
       while (p_no eq -1) do begin; to find the position of N
      ; while not eof(lun) do begin
         readf,lun,line;to store data in line which is a variable
         p_no=STRPOS(line,check_no);give the position of N
      ; endwhile
      endwhile
;*****************  TO FIND THE POSITION OF N IN THE FILE OF DESIRED DATE AND TIME ******************************
;
       length=0
       while (length ne 1) do begin;to find where the data line start bcz we know that first serial no is 1 and it will be within first 6 character
         readf,lun,line
         first6=strmid(line,0,6);to read first 6 character
         first6=strtrim(first6,2);if there is 2 character then it will reduced the length from both side
         length=strlen(first6);to find the actual length of character
         print,'first6 length  ',first6,length
       endwhile
;;*****************  TO READ DATA OF DESIRED DATE AND TIME IN THE FILE  ******************************************
;
       nmax=100; max. no. of data never excedds 100
       ;Si=intarr(nmax)
       pressure=fltarr(nmax)
       height=fltarr(nmax)
       temperature=fltarr(nmax)
       humidity=fltarr(nmax)
       dew_temperature=fltarr(nmax)
       wind_direction=fltarr(nmax)
       wind_speed=fltarr(nmax)
       count=0
       while (length eq 1 or length eq 2) do begin;to read the line of length 2 (from the starting first 6 character) i.e. from 1 to 99
         param=strsplit(line,/extract);to split the character and extract is used to give the value.
         ;without extract it will give the position.
         ;Si(count)=fix(param(1))
         pressure(count)=float(param(2));param(2) is the position of pressure
         height(count)=float(param(3));param(3) is the position of height
         temperature(count)=float(param(4))
         humidity(count)=float(param(5))
         dew_temperature(count)=float(param(6))
         wind_direction(count)=float(param(7))
         wind_speed(count)=float(param(8))
         count=count+1
         readf,lun,line;to store data in line which is a variable
         if (eof(lun)) then break;for last line
         first6=strmid(line,0,6)
         first6=strtrim(first6,2)
         length=strlen(first6)
       endwhile
       count=count-1
       ;Si=Si(0:count)
           p=pressure(0:count)
        h=height(0:count)
        t=temperature(0:count)
        hm=humidity(0:count)
        td=dew_temperature(0:count)
       wd=wind_direction(0:count)
       ws=wind_speed(0:count)

;******************************  Interpolation of Data  **********************************************
h=h/1000;conversion of height to Km
hmax=fix(max(h));to get interger value of hmax as later it will be equal to z1 and z2 which are string
;print,'hamx= ',hmax, ' z2= ',z2
hres=0.05;resolution of data to be interpolate in km
nheights=fix(((z2-z1)/hres))+1; to get the no. of point of interpolated data and plus one bcz it is fron logical sense
h_intpl=fltarr(nheights);we have to convert it into array according to the rule and it is float one that is why fltarr
for i=0,nheights-1 do begin
    h_intpl(i)=z1+hres*i;to increase the height with resolution
endfor
phts=where(h ge z1 and h le z2);to get position of z1 and z2

pnan=where(t(phts) lt 999.);to locate the position where the data is less than 999 or NaN
;stop

t_intpl=interpol(t(phts(pnan)),h(phts(pnan)),h_intpl)
print,'Tropopause temperature (K):',min(t_intpl)
pmin=where(t_intpl eq min(t_intpl))
print,'Tropopause height (km):',h_intpl(pmin(0))

cpt1(idx)=min(t_intpl)
cpt_h1(idx) =h_intpl(pmin(0))
;;;while (idx lt30) do begin  ;;;;jb
    idx=idx+1
    print,'idx:  ',idx
;;;;;endwhile
;t_intpl=t(phts(pnan))+4*pindex    temperature shift 4 degree
t_intpl=t(phts(pnan))  ; +4*pindex
h_intpl=h(phts(pnan))
    if pindex eq 0 then begin
       plot,t_intpl+273.15,h_intpl,linestyle=0,xrange=[180,240],yrange=[10,25],xstyle=1,ystyle=1,$
            background=-1, color=1,YTITLE = 'Height (km)', xtitle='Temperature K' ;,/noerase
       pindex=pindex+1
    endif else begin
    oplot,t_intpl+273.15,h_intpl,linestyle=0
print,'pindex ;',pindex
    pindex=pindex+1

    endelse
endif
       if(eof(lun)) then break
endwhile
free_lun,lun;to close the line

;device,/close_file
;set_plot,'win'; to be set for ps plot

;;;;;;;;;;;;;;;
cpt1=cpt1(0:idx-1)
cpt_h1=cpt_h1(0:idx-1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;********************  To Sava data file  ******************************************************
 ;
path1='C:\radiosonde\test\'
;month=''
   fout=path1+year+'.'+ STRCOMPRESS(month)+'.'+time+'.txt'
  ; fout2=path1+year+'.'+ STRCOMPRESS(month)+'.'+time+'.txt'
 openw,2,fout;/get_lun
 printf,2,'Date  Temp.   Height'

 for j=0,idx-1 do begin
   printf,2,j+1,cpt1(j),cpt_h1(j),format='(i2,3x,f8.3,3x,f5.2)'
    ;print,h(j),t(j),p(j),hm(j),td(j),wd(j),ws(j),format='(f7.3,2x,f7.2,2x,f7.2,2x,f5.0,2x,f6.2,2x,f6.2)'
 endfor  ; j index
;free_lun,lun1
close,2
;
;print,month,idx
idx=0
endfor  ;month index
stop
END