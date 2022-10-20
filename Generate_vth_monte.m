function filename = Generate_vth_l(lib,corner,modelname,W,L,m,temperature,VGmax,VDD,VG_Step,VDlin,vdd_sat,wmin,wmax,lmin,lmax,flag_fet,Terminals,shrink,monteruns)

VDD = VDD;
% VBB = VD_VB;
VGG='GG';
VGmax=VGmax;

if flag_fet==-1
    VG_Start='0.5';
else 
    VG_Start='-0.5';
    
end


VG_Stop='maxvg';

% GG_Stop = 'VGmax';

% Device Dimensions
wn = W;
ln = L;
% nf = nf;
m_1 = m;

% corner=corner2;
% lib=lib2;
%Terminals
%Terminals = 6;
Temperature = temperature;
%fet_flag
term=str2double(Terminals);
%spl character
term

%Library
%lib = '/user/rkar/model_assessments/tc18c_model_update/model/all.scs';
%corner = 'TT_lib';


filename=['netlist_vth_l_' corner '.sp'];

%Opens the file
fileID = fopen(filename, 'w');


fprintf(fileID, '.option brief\n\n');

fprintf(fileID, '.option gmindc = 1e-15\n\n');

fprintf(fileID, '.param shrink = %d \n', shrink);

fprintf(fileID, '.param VDD = %s \n', VDD);

fprintf(fileID, '.param VDlin= %s \n', VDlin);

fprintf(fileID, '.param maxvg = %s \n', VGmax);


fprintf(fileID, '.param vdd_sat = %s \n', vdd_sat);

fprintf(fileID, '.param wn = %s \n', wn);

fprintf(fileID, '.param ln = %s \n', ln);

fprintf(fileID, '.param m1 = %s GG= %s \n\n\n', m_1 , VG_Start);


if term==5
    fprintf(fileID, 'xm1  d g 0 0 0  %s w=wn l=ln m=m1 \n', modelname);
    fprintf(fileID, 'xm2  d0 g 0 0 0  %s w=wn l=ln m=m1 \n\n', modelname);
    fprintf(fileID, 'xm3  d1 g 0 0 0  %s w=wn l=ln m=m1 \n\n', modelname);
 elseif term==6
    fprintf(fileID, 'xm1  d g 0 0 0 0 %s w=wn l=ln m=m1 \n', modelname);
    fprintf(fileID, 'xm2  d0 g 0 0 0 0 %s w=wn l=ln m=m1 \n\n', modelname);
    fprintf(fileID, 'xm3  d1 g 0 0 0 0 %s w=wn l=ln m=m1 \n\n', modelname);
 else
    fprintf(fileID, 'xm1  d g 0 0 %s w=wn l=ln m=m1 \n', modelname);
    fprintf(fileID, 'xm2  d0 g 0 0 %s w=wn l=ln m=m1 \n\n', modelname);
    fprintf(fileID, 'xm3  d1 g 0 0 %s w=wn l=ln m=m1 \n\n', modelname);end



fprintf(fileID, 'vd     d 0 VDD \n');

fprintf(fileID, 'vg     g 0 GG \n');

fprintf(fileID, 'vd1    d0 0 VDlin \n');

fprintf(fileID, 'vd2    d1 0 vdd_sat \n\n');


fprintf(fileID, '.DC GG %s %s %s sweep monte=%s \n', VG_Start, VG_Stop, VG_Step,monteruns);

fprintf(fileID, '.temp %s \n\n', Temperature );

fprintf(fileID, '.data device_size wn ln m1 \n' );

fprintf(fileID, '+ %s %s 1 \n', wmax, lmax);

%Wmax & Lmin

%Wmin & Lmax


fprintf(fileID, '*vtlin extraction \n' );
fprintf(fileID, '.meas dc vtlin find par(''GG'') when par(''(abs(i(vd1)))'') = ''1e-7*(wn/ln)'' \n' );
fprintf(fileID, '.meas dc vtsat find par(''GG'') when par(''(abs(i(vd2)))'') = ''1e-7*(wn/ln)'' \n\n' );

fprintf(fileID, '*Idsat extraction \n' );
fprintf(fileID, '.meas dc Idsat find par(''(abs(i(vd))/(wn*shrink))'') when par(''GG'')=maxvg \n' );

fprintf(fileID, '.meas dc Idoff find par(''(abs(i(vd2))/(wn*shrink))'') when par(''GG'')=0 \n' );
fprintf(fileID, '.meas dc Idoff_abs find par(''(abs(i(vd2)))'') when par(''GG'')=0 \n\n' );

fprintf(fileID, '*Idlin extraction \n' );
fprintf(fileID, '.meas dc Idlin find par(''(abs(i(vd1))/(wn*shrink))'') when par(''GG'')=maxvg \n' );


fprintf(fileID, '.lib ''%s'' %s \n\n', lib,corner);


fprintf(fileID, '.end \n' );


fclose(fileID);