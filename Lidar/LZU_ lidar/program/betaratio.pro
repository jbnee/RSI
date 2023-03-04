 pro betaratio, Re, sigma1, beta1, num, time1, time2, samint, path1, filename1
 

 
  height=make_array(800,/float) 
      
   for i=0l,799l do begin
       height[i]=(75*(i+1))/1000.0         
   endfor
   set_plot,'ps'

               !P.charsize=1
               !P.thick=2
               !P.charthick=2
               !X.thick=2     & !Y.thick=2
          for j=time1,time2,samint do begin
               ;base=zb(j)
              ; top=zt(j)
              ; print,base
               device,filename=path1+filename1+strmid(strtrim(string(j),2),0,4)+'Re.ps'
                      plot,beta1[j,0:199],height[0:199],$
                            ytitle='Altitude z (km)',xtitle='Backscattering Coefficient',position=[0,0,0.5,1]
                     
                      plot,sigma1[j,0:199],height[0:199],$
                            xtitle='Extinction Coefficient',position=[0.5,0,1,1],/noerase
                     
               device,/close_file
          endfor
 end