 ;PRO Ring_Pos
 close,/all
table_path="E:\RSI\work2\"
datecode=''

READ, datecode, PROMPT='Enter  DATE code eg.20041021: '
datecode=string(datecode, format="(I8.8)")

cdf_path="E:\RSI\SPR\"
file1=cdf_path+"is_k0_spr_"+datecode+".cdf"
;readf, u1, datecode, im_rec

print, file1
cdf=sddc_read_cdf(file1)
Read, Ir, Prompt='Enter record number: '
rec1=string(Ir)
Read, IX1,Ix2,Prompt='Enter left and right Ix1 and Ix2 '
Ixm=(Ix1+ix2)/2.
Read, Iy1,Iy2, Prompt='Enter upper and lower ring, Iy1,Iy2: '
Iym=(Iy1+Iy2)/2.
read, Iy_Ag, Prompt='Iy for Airglow height: '
Ht_ring=87.-(Iy_Ag-Iym)
ll=interpol_proj_ll(cdf[IR],Ixm,Iym,Ht_ring); for IRth record of the file
    L2=ll(2)
    IF (L2 EQ 1) THEN BEGIN
    format='5(F7.4)'
    ring_lat=ll(0)
    Ring_long=ll(1)

    PRINT, IR,Ixm,Iym,ht_ring,ll(0),ll(1)
    openw,3,"e:\RSI\temp\"+"R"+datecode+'_'+rec1+'.txt'
        Printf,3,Ir,Ix,Iy,ht,ll(0),ll(1)
       ENDIF


close,/all
end