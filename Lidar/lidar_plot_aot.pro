pro lidar_plot_AOT
;;;plot data based on betaM or betaD

  dz=24;  ;7.5     ;160 ns for SR430 bin width
  year=2002;   year\month
  yr=strtrim(year,2);  remove white space
  fnm=''
    ;fnm=strmid(dnm,0,4)

  Read, fnm, PROMPT='Enter filename fnm as ja15;'   ; Enter date+code

  data_path='f:\RSI\lidar\Fernald\out\';
  data1=data_path+fnm+'M_beta.txt'
  close,/all
  openr,1,data1
  hd=''
  readf,1,hd
  print,hd
  readf,1,hd
  print,1,hd
  ;stop
  read,col,raw,prompt='col and raw of data as 20,1000: '
 ; col=strmid(hd[1]
  ;raw=hd[2]
  B=fltarr(col,raw)
  readf,1,B
  close,1
 ; ht=findgen(bnum)*dz  ; height in km
  ; dz1000=dz*1000 ;in meter
   ;z=ht*1000 ; in meter


   n5=floor(raw/5)
     mpk=fltarr(5,n5)
      For i3=0,n5-1 do begin
      mpk[0,i3]=mean(B[i3,n5,*])
      mpk[1,i3]=mean(B[i3,2*n5,*])
      mpk[2,i3]=mean(B[i3,3*n5,*])
      mpk[3,i3]=mean(B[i3,4*n5,*])
      mpk[4,i3]=mean(B[i3,5*n5,*])
      endfor
    ht=dz*findgen(col)
    plot,mpk[0,*],ht,background=-2,color=2,psym=2,title='peak beta at 1,2,3,km'
    oplot,mpk[1,*],ht,color=55,psym=4
    oplot,mpk[2,*],ht,color=100,psym=5
    oplot,mpk[3,*],ht,color=80,psym=5
    oplot,mpk[4,*],ht,color=200,psym=5
    stop
    read,hc1,hc2,prompt='cloud height region in km as 1,3 km'
       bc1=round(hc1*1000/dz)
       bc2=round(hc2*1000/dz)
       AOD=fltarr(raw)
       for ia=0,col-1 do begin

       AOD[ia]=total(B(ia,bc1:bc2),2)*dz*50;SA/(bc2-bc1+1)
       endfor
    stop
    plot,AOD,color=2,background=-2
end