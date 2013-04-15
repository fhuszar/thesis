entropy = @entropy_Brier_Bernoulli;

p = 0.3;
q = 0.6;

ps = 0:0.01:1;
H = entropy(ps);

[Hq,dHdq] = gradient_complexstep(q,entropy,eps);
Hp = entropy(p);
upper = Hq + (ps-q)*dHdq;

figure(1)
clf
hold on;

plot(ps,H,'b');
plot(ps,upper,':');
set(gca,'XTick',[0,p,q,1]);
set(gca,'XTickLabel',{'0','p','q','1'});
plot([p,p],[0,Hp],'k:');
plot([q,q],[0,Hq],'k:');
plot([p,p],[Hp,Hq+(p-q)*dHdq],'r','LineWidth',2);
