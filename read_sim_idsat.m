function [idlin_sim,idsat_sim,vtlin_sim,vtsat_sim] = read_sim_idsat(filename_meas,corner)

filename_meas_FF = 'netlist_vth_l_FF_lib.measure';
% filename_meas = 'netlist_vth_l_FF_lib.measure';

%filename_meas=[netlist_name '.measure'];

fid = fopen(filename_meas,'r');
text = textscan(fid,'%s');
text2=text{1};








Index_meas_idsat_c = strfind(text2,'idsat');
Index_meas_idsat = find(not(cellfun('isempty',Index_meas_idsat_c)))


idsat_sim=str2double(text2(Index_meas_idsat+2));


idsat_sim



Index_meas_idlin_c = strfind(text2,'idlin');
Index_meas_idlin = find(not(cellfun('isempty',Index_meas_idlin_c)))


idlin_sim=str2double(text2(Index_meas_idlin+2));



Index_meas_vtlin_c = strfind(text2,'vtlin');
Index_meas_vtlin = find(not(cellfun('isempty',Index_meas_vtlin_c)))

vtlin_sim=str2double(text2(Index_meas_vtlin+2));



Index_meas_vtsat_c = strfind(text2,'vtsat');
Index_meas_vtsat = find(not(cellfun('isempty',Index_meas_vtsat_c)))

vtsat_sim=str2double(text2(Index_meas_vtsat+2));




