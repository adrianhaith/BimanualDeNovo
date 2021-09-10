function [pOpt y_fit y] = get_response_onset(y_130)
% find onset time of data based on linear-quadratic model

% resample data from 130 Hz to 1000 Hz
tmax = floor(1000*length(y_130)/130);
y = interp1((1/130)*1000*[1:length(y_130)],y_130,[1:tmax]);
t = 1:length(y);
% estimate initial velocity and acceleration based on first 150ms
igood = ~isnan(y(1:150));
p = polyfit(t(igood),y(igood),1);

% set initial parameters
paramsInit = [250 % onset time in ms after target jump
              0;%p(1)*1000000 % initial acceleration %.00001*1000000
              0;%p(2)*1000000 % initial velocity %-.005*1000000
              .000001*1000000]; % strength of response after t_init

% find optimal parameters
options = optimoptions('fmincon','display','none');

f_targ = @(params) get_error(y,params);
pOpt = fmincon(f_targ,paramsInit,[],[],[],[],[100, -Inf, -Inf, 5],[Inf, Inf, Inf, Inf],[],options);

[e_opt, y_fit] = get_error(y,pOpt);

%{
figure(2); clf; hold on
plot(y,'k','linewidth',2)
plot(y_fit,'r','linewidth',2)
t_init = pOpt(1);
plot([1 1]*t_init,[-.01 .04],'k')
%}

