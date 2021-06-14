function viewTrajs(d, rng)
% function to inspect individual data points

figure(1); clf; hold on

for i=rng
    

    subplot(3,2,[1 3 5]); cla; hold on
   
    plot(d.CrX_pre(i,:),d.CrY_pre(i,:),'b','linewidth',2)
    plot([d.CrX_pre(i,end) d.CrX_post(i,1)],[d.CrY_pre(i,end) d.CrY_post(i,1)],'r','linewidth',2)
    plot(d.CrX_post(i,:),d.CrY_post(i,:),'r','linewidth',2)
    ylim([0 .14])
    axis equal
    
    subplot(3,2,2); cla; hold on
    l = size(d.CrX_pre,2);
    
    velX = diff([d.CrX_pre(i,:) d.CrX_post(i,:)]);
    
    plot(1:l-1,velX(1:l-1),'b','linewidth',2)
    plot(l:(2*l-1),velX(l:end),'r','linewidth',2)
    %plot(l:l+1
    ylabel('velocity')
    
    subplot(3,2,4); cla; hold on
    accX = diff(velX);
    plot(1:l-1,accX(1:l-1),'b','linewidth',2)
    plot(l:2*l-2,accX(l:end),'r','linewidth',2)
    
    
    pause
    
end