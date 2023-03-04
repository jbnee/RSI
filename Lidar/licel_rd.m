function [fm, sysinfo, laser, number_of_data_set, ...
    data_info, data]=licel_rd(fn)

fid=fopen(fn,'r');
LN=fgetl(fid);

fm=LN(1:16); disp(fm);

LN=fgetl(fid); disp(LN);
sysinfo.site=LN(1:8); LN(1:10)=[];
sysinfo.start=LN(1:19); LN(1:20)=[];
sysinfo.finish=LN(1:19); LN(1:20)=[];
sysinfo.altitude=LN(1:4); LN(1:5)=[];
sysinfo.long=LN(1:6); LN(1:7)=[];
sysinfo.lat=LN(1:6); LN(1:7)=[];
sysinfo.zenith=LN(1:2);

LN=fgetl(fid); %disp(LN);
LN(1)=[];
laser.shot1=LN(1:7); LN(1:8)=[];
laser.repetition1=LN(1:4); LN(1:5)=[];
laser.shot2=LN(1:7); LN(1:8)=[];
laser.repetition2=LN(1:4); LN(1:5)=[];

number_of_data_set=str2double(LN(1:2));

for i=1:number_of_data_set
    LN=fgetl(fid); %disp(LN);
    data_info{i}.active=LN(2); LN(1:3)=[];
    data_info{i}.photon_or_analog=LN(1); LN(1:2)=[];
    data_info{i}.lasertype=LN(1); LN(1:2)=[];
    data_info{i}.number_of_bin=str2double(LN(1:5)); LN(1:6)=[];
    data_info{i}.the_number=str2double(LN(1)); LN(1:2)=[];
    data_info{i}.HV=str2double(LN(1:4)); LN(1:5)=[];
    data_info{i}.bin_width=str2double(LN(1:4)); LN(1:5)=[];
    data_info{i}.wavelength=str2double(LN(1:5)); LN(1:6)=[];
    data_info{i}.polarization=LN(1); LN(1:2)=[];
    LN(1:11)=[];
    data_info{i}.ADC_bits=str2double(LN(1:2)); LN(1:3)=[];
    data_info{i}.number_of_shot=str2double(LN(1:6)); LN(1:7)=[];
    s=findstr(LN,'B');
    data_info{i}.discriminator_level=str2double(LN(1:(s-2)));
    data_info{i}.device=LN(s:(s+2));
end
fgetl(fid);

for i=1:number_of_data_set
    p=fread(fid,data_info{i}.number_of_bin,'uint32');
    data{i}=p(1:data_info{i}.number_of_bin); %p(1:data_info{i}.number_of_bin)=[];
    data{i}=data{i}/data_info{i}.number_of_shot/2^(data_info{i}.ADC_bits);
    if strcmp(data_info{i}.device(1:2),'BT')
        data{i}=data{i}*500;
    else
        data{i}=data{i}/4096/256*500;
    end
end
fclose(fid);