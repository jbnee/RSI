pro sddc_stru2cdf, data, filename, append=append
;inputs:
;data: array of any structure
;filename: your cdf-files


if keyword_set(append) then begin
  cid = cdf_open(filename)
endif else begin
  ;Create your cdf
  cid = cdf_create(filename, /clobber, /single)
endelse

;IDL type
;0  UNDEFINED
;1  BYTE  Byte
;2  INT  Integer
;3  LONG  Longword integer
;4  FLOAT  Floating point
;5  DOUBLE  Double-precision floating
;6  COMPLEX  Complex floating
;7  STRING  String

  cdftype = ['UNDEFINED', 'CDF_BYTE','CDF_INT2','CDF_INT4','CDF_FLOAT','CDF_DOUBLE','UNDEFINED','CDF_CHAR']
  stru    = data[0]
  tagnames = tag_names(stru)
  for i=0, n_elements(tagnames)-1 do begin

    thistag  = tagnames[i]
    thistype = size(stru.(i), /type)
    thisNDim = size(stru.(i), /N_DIMENSIONS)
    thisDims = size(stru.(i), /DIMENSIONS)
    thiscdftype = cdftype[thistype]
    thiscdfid   = thistag+"_id"
    case thisNDim of
    0:exec = thiscdfid+"=cdf_varcreate(cid, '"+thistag+"',/"+thiscdftype+" ,/REC_VARY, /zvar)"
    1:exec = thiscdfid+"=cdf_varcreate(cid, '"+thistag+"', ['Vary'],/"+thiscdftype+", dimensions=["+string(thisDims[0], format='(I)')+"] ,/REC_VARY, /zvar)"
    2:exec = thiscdfid+"=cdf_varcreate(cid, '"+thistag+"', ['Vary','Vary'],/"+thiscdftype+", dimensions=["+string(thisDims[0], format='(I)')+","+string(thisDims[1], format='(I)')+"] ,/REC_VARY, /zvar)"
    endcase
    print, exec

;if NOT keyword_set(append) then begin
  s = execute(exec)
;endif


    exec = "cdf_varput, cid, "+thiscdfid+", data.(i), /zvar"
    s = execute(exec)
  endfor

  cdf_close, cid
end