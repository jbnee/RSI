pro cloudheight, rawdata, num, time1, time2, samint, range1, range2, Cred, resol, Zb, Zc, $
                   Zt, GTc, path1, filename1

;*input*
;rawdata=the raw return of MPL lidar
;num=the times of cirrus appeared in one day
;time1=the starting time of cirrus appeared   
;time2=the ending time of cirrus appeared   
;samint=the interval between time1 and time2
;range1=Estimated cirrus cloud base height
;range2=Estimated cirrus cloud top height
;Cred=below the CRED height is the valid data
;Zb=the base height of cirrus calculated by thresholdmethod
;Zt=the top height of cirrus calculated by thresholdmethod
;Zc=the cloud height of cirrus calculated by thresholdmethod
;GT=the Geometric thickness of cirrus calculated by thresholdmethod 


 h1=uint(range1*1000/75-1)                  
 h2=uint(range2*1000/75-1)
 
 d=1.0
 r1=uint((range1-d)*1000/75-1)              
 r2=uint((range2+d)*1000/75-1)

 SD1=make_array(1440,/float)
 SD2=make_array(1440,/float)
 
for j=time1,time2,samint do begin
    SD1(j)=STDDEV(rawdata[j,r1:h1])
    SD2(j)=STDDEV(rawdata[j,h2:r2])
endfor


  Zb=make_array(1440,/float)
  Zt=make_array(1440,/float)
  Zc=make_array(1440,/float)
  GTc=make_array(1440,/float)
  dp=make_array(1440,800,/float)
  dz=75
  
   for j=time1,time2,samint do begin
      
       for i=h1,h2,1 do begin
             if rawdata(j,i+1)-rawdata(j,i) ge SD1(j)^2 $
                and rawdata(j,i+3) ge rawdata(j,i+2) $
                and rawdata(j,i+2) ge rawdata(j,i+1) $
                and rawdata(j,i+1) ge rawdata(j,i) then begin
                  ;print,'Zb of 3 intervals',j,(i+1)*75.0/1000.0
                  Zb(j)=(i+1)*75.0/1000.0
             endif
             if Zb(j) gt 0.0 then break
         endfor
         
         for i=h2,h1,-1 do begin
             if rawdata(j,i-1)-rawdata(j,i) ge SD2(j)^2  $
                and rawdata(j,i-3) ge rawdata(j,i-2) $
                and rawdata(j,i-2) ge rawdata(j,i-1) $
                and rawdata(j,i-1) ge rawdata(j,i) then begin
                  ;print,'Zt of 3 intervals',j,(i+1)*75.0/1000.0
                  Zt(j)=(i+1)*75.0/1000.0
             endif
             if Zt(j) gt 0.0 then break
         endfor
         
         if Zb(j) eq 0.0 then begin
               for i=h1,h2 do begin
                      if rawdata(j,i+1)-rawdata(j,i) ge SD1(j)^2 $
                         and rawdata(j,i+2) ge rawdata(j,i+1)$
                         and rawdata(j,i+1) ge rawdata(j,i) then begin
                              ;print,'Zb of 2 intervals',j,(i+1)*75.0/1000.0
                              Zb(j)=(i+1)*75.0/1000.0
                     endif
                     if Zb(j) gt 0.0 then break
               endfor
          
       endif       

       if Zt(j) eq 0.0 then begin
               for i=h2,h1,-1 do begin
                      if rawdata(j,i-1)-rawdata(j,i) ge SD2(j)^2  $
                          and rawdata(j,i-2) ge rawdata(j,i-1) $
                          and rawdata(j,i-1) ge rawdata(j,i) then begin
                                 ;print,'Zt of 2 intervals',j,(i+1)*75.0/1000.0
                                 Zt(j)=(i+1)*75.0/1000.0
                      endif
                     if Zt(j) gt 0.0 then break
               endfor
       endif
       
       if Zb(j) eq 0.0 then begin
                 for i=h1,h2 do begin
                       if rawdata(j,i+1)-rawdata(j,i) ge SD1(j)^2 $
                          and rawdata(j,i+1) ge rawdata(j,i) then begin
                              ;print,'Zb of 1 intervals',j,(i+1)*75.0/1000.0
                              Zb(j)=(i+1)*75.0/1000.0
                       endif
                       if Zb(j) gt 0.0 then break
                 endfor
          
           endif       

           if Zt(j) eq 0.0 then begin
                    for i=h2,h1,-1 do begin
                         if rawdata(j,i-1)-rawdata(j,i) ge SD2(j)^2  $
                            and rawdata(j,i-1) ge rawdata(j,i) then begin
                                 ;print,'Zt of 1 intervals',j,(i+1)*75.0/1000.0
                                 Zt(j)=(i+1)*75.0/1000.0
                         endif
                         if Zt(j) gt 0.0 then break
                    endfor
           endif
         
   endfor
   
  
   for j=time1,time2,samint do begin
                for i=1,200 do begin
                       dp(j,i)=(rawdata(j,i+1)-rawdata(j,i-1))/(2*dz) 
                endfor
   endfor
   

 height=make_array(800,/float) 
   
   for i=0l,799l do begin
       height[i]=(resol*(i+1))/1000.0         
   endfor
   set_plot,'ps'

               !P.charsize=1
               !P.thick=3
               !P.charthick=3
               !X.thick=3     & !Y.thick=3
          for j=time1,time2,samint do begin
               base=zb(j)
               top=zt(j)
               validline=Cred(j)
               device,filename=path1+filename1+strmid(strtrim(string(j),2),0,4)+'.ps'
                       plot,rawdata(j,*),height,xstyle=1+8,xrange=[0,1],xticks=2,$         ;2007
                      ;plot,rawdata[j,*],rawdata[0,*],xstyle=1+8,xrange=[-0.5,1.5],xticks=5,$  ;2010
                            xtickname=['0','0.5','1'],$
                            ystyle=1+8,yrange=[0,16],yticks=8,$
                            ytickname=['0','2','4','6','8','10','12','14','16'],$
                            ytitle='Altitude z (km)',xtitle='signal P(z)Z!U2!N(arb. units)',$
                            position=[0.2,0,0.8,1]
                      oplot,[-10,20],[base,base]
                      oplot,[-10,20],[top,top]
                      oplot,[-10,20],[validline,validline]
                      ;this part for 一阶导
;                      plot,dp(j,*),height,xstyle=8,xticks=4,$     ; 2007
;                      ;plot,dp(j,*),rawdata[0,*],xstyle=8,xticks=4,$   ;2010
;                            xtickname=['-20','10','0','10','20'],ystyle=1+8,yrange=[0,20],yticks=10,$
;                            ytickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],$
;                            xtitle='slope dp/dz (arb. units)',position=[0.5,0,1,1],/noerase
;                      oplot,[-10,20],[base,base]
;                      oplot,[-10,20],[top,top]
;                      oplot,[-10,20],[validline,validline]
               device,/close_file
          endfor
          

   
   openw,lun,path1+filename1+num+'cloudheight.txt',/get_lun
   printf,lun,'time','Zb','Zt','Zc','GTc',format='(a5,a8,a9,a10,a12)'
          for j=time1,time2,samint do begin
               Zc(j)=(Zb(j)+Zt(j))/2.0
               GTc(j)=Zt(j)-Zb(j)
               print,'Time','Zb(j)','Zt(j)','Zc(j)','GTc(j)'
               print,j,Zb(j),Zt(j),Zc(j),GTc(j)
               if Zt(j) le Cred(j) then printf,lun,j,Zb(j),Zt(j),Zc(j),GTc(j),format='(i4,4f10.3)'
               ;if Zt(j) gt Cred(j) then printf,j,'Zt is invalid'
          endfor
   free_lun,lun
return
end