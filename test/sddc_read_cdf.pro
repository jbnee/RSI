function sddc_cdf_getvartype, zinfos, idx
  type = zinfos[idx].datatype
  case type of
    "CDF_EPOCH" : ret = '0d'
    "CDF_INT4"  : ret = '0l'
    "CDF_DOUBLE": ret = '0d'
    "CDF_INT2": begin
                dim1 = zinfos[idx].dim1
                dim2 = zinfos[idx].dim2
                if dim2 ne 0 then $
                  ret = "INTARR("+STRING(dim1, format='(I)')+","+STRING(dim2, format='(I)')+")" $
                else $
                  ret = "INTARR("+STRING(dim1, format='(I)')+")"
       end
    else: ret = ""
  endcase
  return, ret
end

function sddc_read_cdf, filename, rec_start=rec_start, rec_read=rec_read
  if n_elements(filename) eq 0 then $
    filename = "/nspo/scc/inbound/Level1Data/is_k0_aps_20010224.cdf"
  ;2004-07-30: fix error of lost data
  cdfId = cdf_open(filename)
  res   = cdf_inquire(cdfid)
  zvarN = res.nzvars

  ;Get names of zvars
  zvarinfo  = {name:"", datatype:"", dim1:0L, dim2:0L}
  zvarinfos = replicate(zvarinfo, zVarN)

  for i=1, zvarN-1 do begin
    tmpInfo           = cdf_varinq(cdfid, i, /zVar)
    zvarinfos[i].name = tmpInfo.name
    zvarinfos[i].datatype = tmpInfo.datatype
    if n_elements(tmpinfo.dim) eq 1 then begin
      zvarinfos[i].dim1 = tmpInfo.dim
    endif else if n_elements(tmpinfo.dim) eq 2 then begin
      zvarinfos[i].dim1 = tmpInfo.dim[0]
      zvarinfos[i].dim2 = tmpInfo.dim[1]
    endif
  endfor

  ;Create structure
  exec = "cdf = {"
  cnt  = 0
  for i=0, n_elements(zvarinfos.name)-1 do begin
    if cnt gt 0 then exec += ","
    if zvarinfos[i].name ne "" then begin
        exec += zvarinfos[i].name +":"+sddc_cdf_getvartype(zvarinfos, i)
        cnt += 1
    endif
  endfor
  exec += "}"
  ;print, exec
  resu = execute(exec)

  ;Get record number
  cdf_control, cdfid, var=zvarinfos[n_elements(zvarinfos)-1].name, /zvar, get_var_info=vinfo, set_padvalue=0.0d
  recNum = vinfo.maxrecs+1
  if recNum lt 1 then begin
    print, "Record nubmer eq zero..."
    return, -1
  endif

  if not keyword_set(rec_read ) then rec_read =recnum
  if not keyword_set(rec_start) then rec_start=0

  if rec_read+rec_start gt recnum then rec_read=recnum-rec_start

  print, "recnum=", recnum
  cdfs   = replicate(cdf[0], rec_read)
   ;cdfs   = replicate(cdf[0], recNum)

  ;Insert data
  varnames = tag_names(cdf)
  for i=0, n_elements(varnames)-1 do begin
    cdf_control, cdfid, var=varnames[i], /zvar, set_padvalue=0.0d
    ;for j=0, recNum-1 do begin
    for j=0, rec_read-1 do begin
      ;Rec start from 0
      cdf_varget, cdfid, varnames[i], value, rec_start=rec_start+j
      cdfs[j].(i)[*] = value
    endfor
  endfor
  cdf_close, cdfid
  return, cdfs
end
