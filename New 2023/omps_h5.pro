pro OMPS_h5
X='E:\RSI\NEW 2023\*';
F1=file_search(X)
help,F1
stop
h5_open; open IDL's HDF5 library
Result = H5_BROWSER(F1[0], /DIALOG_READ)

IDx=h5f_open(F1[0]); get the ID number

stop
end