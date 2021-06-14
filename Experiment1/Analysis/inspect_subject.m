% inspect individual participants

subj = 7;

figure(2); clf; hold on

for c=1:7
    subplot(3,7,c); cla; hold on
    plot(d{subj}.Bi{c}{6}.pkVel,'k.-')
    ylim([0 .006])
    ylabel('pk vel')
end