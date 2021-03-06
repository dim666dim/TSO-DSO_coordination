function [result_OOS_validation_PCC, result_OOS_validation_FC, result_OOS_validation_CM] ...
	= run_outofsample_optim(mpc,base_PCC_capacity,PCC_lim_factor_grided,...
	wind_factor_grided,line_factor_gridded,line_var_cap,variance_base,mean_base,PCC_branch_id,nscen_IS,nscen_OOS,...
	DA_outcome_PCC,DA_outcome_CM,results_full_coordination,kk)
variance_wind = variance_base;
mean_wind = mean_base;
line_cap_base = mpc.branch(line_var_cap,6);

disp([' '])
disp([' '])
disp([' '])
disp([' OUT of sample '])
disp(['Wind-penetration point ' num2str(kk) ])
disp([' '])

% variance_wind(1:3) = variance_base(1:3)*wind_factor_grided(kk);
% mean_wind(1:3) = mean_base(1:3)*wind_factor_grided(kk);
variance_wind = variance_base*wind_factor_grided(kk)^1.5;
mean_wind = mean_base*wind_factor_grided(kk);

% 	variance = [0.01]*wind_factor(kk);
% 	mean = [0.8]*wind_factor(kk);

scenarios = scenario_generator(mpc,variance_wind,mean_wind,300,'default',false);

for k = 1:nscen_OOS
	mpc.RTscen(:,3+3*(k-1)) = scenarios(nscen_IS+k,:);
	mpc.RTscen(:,5+3*(k-1)) = 1/nscen_OOS;
	mpc.RTscen(:,4+3*(k-1)) = 0;
	mpc.RTscen(:,2) = nscen_OOS;
end

mpc.branch(PCC_branch_id,6) = base_PCC_capacity*PCC_lim_factor_grided(kk);
mpc.branch(line_var_cap,6) = line_factor_gridded(kk)*line_cap_base;


DA_outcome_FC.p_gen_DA = results_full_coordination.p_gen_DA;
DA_outcome_FC.p_dem_DA = results_full_coordination.p_dem_DA;
DA_outcome_FC.wind_DA = results_full_coordination.p_wind_DA;
DA_outcome_FC.cost_DA = results_full_coordination.cost_DA;

OOS_time = tic;
[result_OOS_validation_PCC] = OOS_validation(mpc,DA_outcome_PCC,kk);
[result_OOS_validation_CM] = OOS_validation(mpc,DA_outcome_CM,kk);
[result_OOS_validation_FC] = OOS_validation(mpc,DA_outcome_FC,kk);
tfin_OOS = toc(OOS_time);

disp(['WPP-OOS: ' num2str(kk) ', Time: ' num2str(tfin_OOS)])



	
end
