function [result_DA_powerflow] = DA_powerflow(data,DA_outcome,kk)

cc{1} = double.empty(1,0);
[~,~,~,~,~,~,~,~,~,~,~,...
	ng,nd,~,~,~,~,~,~,~,~,...
    Pmax_gen,~,~,~,Pmax_dem,~,~,...
	~,~,~,~,~,~,~,~,~,...
    ~,~,~,~,~,~,~,~,...
	~,~,~,~,...
	~,~,~,~,~,~,....
	~,~,~,~,~,prob_wscen,~,~,...
	~,nscen,~,bus_wgen,...
	offer_wind_DA,offer_wind_up,offer_wind_dn] = Data_Reader(data,cc);

if ~isempty(data.DR_DSO)
	bus_DR = data.DR_DSO(:,1);
	nDR = length(bus_DR);
else
	bus_DR = [];
	nDR = length(bus_DR);
end
p_DR_DA_hat = zeros(nDR,1);


p_gen_DA_hat = DA_outcome.p_gen_DA;
p_dem_DA_hat = DA_outcome.p_dem_DA;

wind_DA_hat = DA_outcome.wind_DA;


t_sub = tic;
iter = 0;
% parfor s = 1:nscen
s=1;
	RT_outcome = RT_fixed_DA_dispatch(data,p_gen_DA_hat,p_dem_DA_hat,p_DR_DA_hat,wind_DA_hat,s,iter,kk);
% end
time_sub = toc(t_sub);
disp(['WPP-DAflow: ' num2str(kk) ', Solution Time for Sub-Problem: ' num2str(time_sub)]);
for s = 1
	cost_RT(s,1) = RT_outcome.cost_RT;
end
	

% DA_outcome.cost = DA_outcome.cost_DA + prob_wscen(1,:)*cost_RT(:);
% DA_outcome.cost_STD = std(DA_outcome.cost_DA + cost_RT(:));
	
% result_DA_powerflow.DA_outcome = DA_outcome;
result_DA_powerflow.RT_outcome = RT_outcome;



