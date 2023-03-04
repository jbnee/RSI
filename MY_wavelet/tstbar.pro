pro tstbar
 LOADCT,10
 loadct,15,ncolors=12,bottom=1
 !P.color=0
 nlevs=50
 cmax=150 ; max(abs(wave))
 cmin=-50; min(abs(wave))
 cint = round((cmax-cmin));/ NLEVS
 C_INDEX=-150+5*FINDGEN(NLEVS);+1)*col;/(NLEVS)
 plot,c_index,backgroun=-2 ,color=0
 CLEVS = CMIN + FINDGEN(NLEVS+1)*CINT
  zb = fltarr(nlevs,2)
  BAR_POSITION=[0.2,0.2,0.5,0.5]
    for k = 0, nlevs-1 do zb(k,0:1) = cmin + k*k ;cint*k
     xb = cmin + findgen(nlevs)*cint
     yb=[0,1]
     ;xname = [' ',' ']
     stretch,min(zb),max(zb)
    CONTOUR, zb, xb(0:nlevs-1), yb(0:1),position=bar_position,$

      nlevels=30,/follow,yrange=[cmin,cmax],/ystyle,xtickv=findgen(2),$
      C_COLORS = C_INDEX ,$
      xticks=1,xtickname=xname,xrange =[0,1],/xSTYLE, $
      LEVELS = CLEVS, /FILL, ycharsize=1, $;C_COLOR = C_INDEX,
      xcharsize=1,/noerase
    stop
      end