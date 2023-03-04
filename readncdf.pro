;*********************************************************************************************
;
; NAME: readNCDF
;
; PURPOSE:
;   Generic netCDF reader. Returns the data through an output structure.
;
; CALLING SEQUENCE:
;  outStruct = readNCDF(file)
;
; POSITIONAL PARAMETERS:
;   -i    file          netCDF file (full path specified)
;   -o    outStruct     Output structure containing all data within the NETCDF file.
;                       Default set to scalar 0.
;
; KEYWORD PARAMETERS:
;   TOREAD=TOREAD:    [N] element array which contains a list of variables to
;                       extract from the netCDF file.
;   ATTRIB=ATTRIB:    If this keyword is set then also returns the attributes for
;                       each variables (if they exist).
;
; MODIFICATIONS:
;   11/07/2008 BJG:   Initial version of the code.
;   01/06/2009 BJG:   Added the ability to read in global attributes.
;
;**********************************************************************************************
 FUNCTION readNCDF, file, TOREAD=TOREAD, ATTRIB=ATTRIB

 ;
    outStruct = 0  ;Initialize outStruct to default 0

    IF(N_ELEMENTS(TOREAD) EQ 0) THEN TOREAD='NULL'
  TOREAD = STRUPCASE(TOREAD)

  IF(N_PARAMS(file) EQ 0) THEN BEGIN
   file = DIALOG_PICKFILE()
 ;;  IF(file(0) EQ '') THEN RETURN, outStruct
  ;ENDIF

    ;Does the file exists?
  ;; temp = FILE_SEARCH(file, COUNT=count)
   ;; IF(count NE 1) THEN RETURN, outStruct

  ;Open the netCDF file for reading.
  openNCDF = NCDF_OPEN(file)
  ;IF (openNCDF EQ -1) THEN RETURN, outStruct

  ;Retrieve information about this netCDF file.
  infoNCDF = NCDF_INQUIRE(openNCDF)

  ;Extract the number of global attributes in this netCDF file
  numGAtt = infoNCDF.NGATTS

  ;Scan through all of the global attributes
  IF(numGAtt NE 0 AND KEYWORD_SET(ATTRIB) ) THEN BEGIN
   FOR ii=0, numGAtt-1L DO BEGIN

     attName = NCDF_ATTNAME(openNCDF, /GLOBAL, ii)
     NCDF_ATTGET, openNCDF, /GLOBAL, attName, attData

     ;Convert byte string into actual string
     IF(SIZE(attData(0), /TYPE) EQ 1) THEN attData = STRING(attData)

     IF((SIZE(outStruct,/TYPE)) NE 8) THEN outStruct = CREATE_STRUCT(attName, attData) $
                    ELSE outStruct = CREATE_STRUCT(outStruct, attName, attData)
   ENDFOR
  ENDIF  ;IF(numGAtt NE 0 AND KEYWORD_SET(ATTRIB) ) THEN BEGIN

  ;Extract the number of variables defined in this netCDF file
  numVars = infoNCDF.NVARS

  ;Scan through all of the defined variables
  IF(numVars NE 0) THEN BEGIN
   FOR ii=0, numVars-1L DO BEGIN

     varInfo = NCDF_VARINQ(openNCDF, ii)
     varName = varInfo.NAME

     NCDF_VARGET, openNCDF, ii, varData

     storeVar=0B
     toUse = WHERE( (TOREAD EQ varName) OR (STRUPCASE(TOREAD) EQ STRUPCASE(varName)) )
     IF( (SIZE(toUse))(0) GE 1 OR TOREAD(0) EQ 'NULL') THEN storeVar=1B

     IF(storeVar) THEN BEGIN
      IF((SIZE(outStruct,/TYPE)) NE 8) THEN outStruct = CREATE_STRUCT(varName, varData) $
                   ELSE outStruct = CREATE_STRUCT(outStruct, varName, varData)
     ENDIF

     IF (KEYWORD_SET(ATTRIB)) THEN BEGIN
      numAtt = varInfo.Natts  ;how many attributes?
      FOR jj=0, numAtt-1 DO BEGIN
        att = NCDF_ATTNAME(openNCDF, ii, jj)
        attribName = STRCOMPRESS(varName+"_"+STRCOMPRESS(att,/REMOVE_ALL))
        temp_attribName = attribName
        NCDF_ATTGET, openNCDF, ii, att, attribName
        attribName = STRING(attribName)
        IF(storeVar) THEN outStruct = CREATE_STRUCT(outStruct, temp_attribName,attribName)
      ENDFOR
     ENDIF

   ENDFOR
  ENDIF  ;IF(numVars NE 0) THEN BEGIN

  NCDF_CLOSE, openNCDF

  RETURN, outStruct
;stop
;END
;**********************************************************************************************


