function [e2, y_predict] = get_error(y,params)
% compute error in fitting a model of velocity profile comprising an
% initial straight line followed by a quadratic rise
%
% Before t_init, y = ax+b
% After t_init, y = cx^2 + dx + e

t_init = params(1);

% determine time point to fit up to
%t = 1:(t_init+100); % go 100 ms after initiation time
ymax = max(y);
i_fit_to = min(find(y>ymax/2));
i_fit_to = max(i_fit_to,t_init+100); % avoid spurious situations where peak velocity is really low
i_fit_to = min(i_fit_to,length(y));
t = 1:i_fit_to; % go 100 ms after initiation time

Nt = length(t);
y_predict = 0*t;


a = params(2)/1000000; % slope
b = params(3)/10000; % y offset
c = params(4)/10000000; % response strength
% other parameters constrained by continuity of y and dy/dt at t_init
d = a - 2*c*t_init;
e = (a-d)*t_init - c*t_init^2 + b;



t = 1:Nt;
i_t_init = min(floor(t_init),i_fit_to);

y_predict(1:i_t_init) = a*t(1:i_t_init) + b;
y_predict(i_t_init:end) = c*t(i_t_init:end).^2 + d*t(i_t_init:end) + e;

e2 = nansum((y_predict - y(1:Nt)).^2);

if(0)
    figure(1); clf; hold on
    plot(y,'b','linewidth',2)
    plot(y_predict,'r','linewidth',2)
    plot([1 1]*t_init,[-.01 .04],'k')
end