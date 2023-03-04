pro myhistogram
; inarr $
             ;    , binsize = binsize, maxa = maxa, mina = mina, nbins = nbins $
             ;    , reverse_indices = reverse, omax = omax, omin = omin $
            ;     , xaxis = xaxis

; GET THE FINITE INDICED ('GOOD'), NON-FINITE INDICES ('BAD') AND # OF GOOD
path1='F:\RSI\test\SSA.txt'
outfil='F:\AERONET\ncu\output\';output.txt'
A0=READ_ASCII(Path1)

A=A0.(0)
stop
S=size(A)
col=s(2)
raw=S(2)
;input below: 1 for 440,2:670,3:870,4:1020
print,'input below: 1 for 440,2:670,3:870,4:1020';
INArr=A[2,0:raw-1]; select SSA channel;
;read,binsize,prompt='enter bin size such as 0.01: '
binsize=0.01
;stop
  good = where(finite(inarr), comp = bad, ng)
; CHECK THAT THERE IS AT LEAST ONE GOOD ELEMENT
  if (ng gt 0) then $
    arr = inarr(good) $
  else begin
    print, 'Not an array of sortable floats'
  stop;  return, -1
  endelse

; GET THE NUMBER OF ELEMENTS FOR THE ARRAY
  neL = n_elements(arr)
;stop
; REVERT TO DEFAULTS IF INPUT ON MIN/MAX VALUE IS NONSENSICAL
  if (n_elements(max) ne 1) then $
    maxa = max(arr)
  if (n_elements(min) ne 1) then $
    mina = min(arr)
  if (mina ge maxa) then begin
    maxa = max(arr)
    mina = min(arr)
  endif
  if (mina eq maxa) then begin
    if (n_elements(binsize) eq 1) then $
      mina = mina-binsize else $
      mina = mina-1
  endif

stop
binsize=0.01
; SET THE BIN SIZE IF NOT USER SPECIFIED
  if (n_elements(binsize) ne 1) then begin
    if (n_elements(nbins) gt 0) then $
      binsize = (maxa-mina)/(nbins*1.) $
    else begin
      binsize =1
      nbins = ceil(maxa-mina)
    endelse
  endif else begin
    nbins = ceil((maxa-mina)/binsize)
    maxa = mina+nbins*binsize
  endelse

; MAKE AN ARRAY OF INTEGERS WITH 'NBINS' ELEMENTS -- THIS IS OUR HISTOGRAM
  ibins = lonarr(nbins)

; THE "REVERSE INDICES," AN ARRAY WHICH TELLS YOU WHICH ELEMENTS OF
; THE ORIGINAL ARRAY ARE IN EACH BIN. SETUP IS THE FOLLOWING: FIRST
; nbins ENTRIES POINT YOU TO THE LOCATION OF THE LIST OF ELEMENTS
; ASSOCIATED WITH THAT BIN. SO reverse[reverse[i]:reverse[i+1]-1] IS
; THE ARRAY OF ELEMENTS IN BIN i.
  reverse = intarr(nel+nbins+1)
; INITIALIZE THE COUNTER SHOWING US WHERE TO PUT ELEMENTS FOR THE NEXT
; BIN IN THE reverse ARRAY.
  ir = nbins+1

; MAKE THE ARRAY TO HOLD THE X AXIS. THE XAXIS IS DEFINED TO BE THE
; *MINIMUM* VALUE ASSOCIATED WITH EACH BIN.
  xaxis = fltarr(nbins+1)

; LOOP OVER ALL BINS AND COUNT ELEMENTS IN EACH BIN THEN ASSIGN TO
; REVERSE-INDICES
  for i = 0, nbins-1 do begin
    bmin = mina+i*binsize        ; MINIMUM VALUE FOR CURRENT BIN
    bmax = mina+(i+1)*binsize    ; MAXIMUM VALUE FOR CURRENT BIN
    xaxis[i] = bmin             ; ASSIGN MINIMUM VALUE TO THE X AXIS

;   CALCULATE THE NUMBER (nw) OF ELEMENTS IN THE CURRENT BIN
    if (i eq nbins-1) then $
      junk = where((arr ge bmin) and (arr le bmax), nw) $ ; <= ONLY FOR THE LAST BIN
    else $
      junk = where((arr ge bmin) and (arr lt bmax), nw) ; ... OTHERWISE USE <

    ibins[i] = nw               ; PUT THAT NUMBER IN THE HISTOGRAM
    reverse[i] = ir             ; POINT TO THE INDICES FOR BIN i.
;   PUT THE INDICES FOR BIN i INTO THE REVERSE ARRAY
    if (nw gt 0) then begin
      nir = ir+nw
      reverse[ir:nir-1] = junk
      ir = nir                  ; ADJUST THE COUNTER TO POINT TO THE NEXT FREE SPOT
    endif
  endfor

; THE LAST ELEMENT OF THE XAXIS IS THE MAX VALUE, SO THAT THE X AXIS
; HAS ONE MORE VALUE THAN THE HISTOGRAM ITSELF, THEREBY INCLUDING ALL
; "FENCEPOSTS."
  xaxis[i] = bmax ; this is the bins array

; POINT THE nbins (here i=nbins) ELEMENT OF THE reverse ARRAY AT THE
; FIRST EMPTY ELEMENT AND THEN LOP OFF THE EXTRA ELEMENTS OF reverse
; (THAT POTENTIALLY COME FROM HAVING ELEMENTS THAT DO NOT F
; BIN)
  reverse[i] = ir               ;Yes, this should be outside the loop.  i=nbins
  reverse = reverse[0:ir-1]
; GET THE MININUM AND THE MAXIMUM VALUE THAT ACTUALLY WENT INTO THE
; HISTOGRAM (omin AND omax)
  if (reverse[i] ne nbins+1) then begin
    omin = min(arr[reverse[nbins+1:ir-1]])
    omax = max(arr[reverse[nbins+1:ir-1]])
  endif

; RETURN THE HISTOGRAM
print,'total bins: ',total(ibins)

plot,xaxis,ibins,psym=10,color=2,background=-2,thick=1.5,ytitle='number of bin',xtitle='SSA',title='SSA870/440'
stop
an=size(ibins)

Hist=fltarr(2,an[1])
xa=xaxis(0:an[1]-1)
Hist[0,*]=xa
Hist[1,*]=ibins

ofile1=outfil+'SSA870.txt'  ;1 for 440,2:670,3:870,4:1020
 ;
 ofile2=outfil+'SSA870p.bmp' ;same as aboe
write_bmp,ofile2,tvrd()

openw,2,ofile1
printf,2,Hist
close,2
SSA440a=fltarr(2,an[1])
;SSA870=Hist
infil1=outfil+'SSA440.txt'
openr,1,infil1
readf,1,SSA440a
close,1

device, decomposed=0
   Loadct,5
x440=SSA440a[1,*]
oplot,xaxis,x440,psym=10,color=60,thick=2
oplot,xaxis,ibins,psym=10,color=120
xyouts,0.77,15,'blue:SSA440,red:SSA870',color=2,size=1.5

ofile3=outfil+'SSA440_SSA870.bmp'

 write_bmp,ofile3,tvrd(/true)

stop

end
