%% one qubit

% fidelity_AMUB = one_qubit_SIS('AMUB');
% fidelity_rand = one_qubit_SIS('rand');
% fidelity_MUB = one_qubit_SIS('MUB');
% fidelity_semiAMUB = one_qubit_SIS('semiAMUB');

% Ss = floor(logspace(log10(100),log10(10000),20));
% purities =[0.5 0.6 0.7 0.8 0.85 0.9 0.925 0.95 0.975 1];
% figure
% semilogy(purities,mean((1-fidelity_rand(end,:,:)),3),'k:','linewidth',1)
% hold on
% semilogy(purities,mean((1-fidelity_AMUB(end,:,:)),3),'g','linewidth',1)
% semilogy(purities,mean((1-fidelity_MUB(end,:,:)),3),'r','linewidth',1)
% semilogy(purities,mean((1-fidelity_semiAMUB(end,:,:)),3),'b--','linewidth',1)
% ylim([0.0003 0.01])
% xlabel('purity')
% 
% 
% for i=1:size(fidelity_rand,2)
% figure
% loglog(Ss,mean((1-fidelity_rand(Ss,:)),2),'k:')
% hold on
% loglog(Ss,mean((1-fidelity_AMUB(Ss,:)),2),'g')
% loglog(Ss,mean((1-fidelity_MUB(Ss,:)),2),'r')
% loglog(Ss,mean((1-fidelity_semiAMUB(Ss,:)),2),'b--')
% xlim([100,10000])
% legend('rand','AdaptiveMUB','fixedRotationMUB','chooseBetweenMUB')
% % title('purity=1')
% end

% figure
% loglog(((1-fidelity_rand)),'k:')
% hold on
% loglog(((1-fidelity_AMUB)),'g')
% loglog(((1-fidelity_MUB)),'r')
% loglog(((1-fidelity_semiAMUB)),'b--')

%% two qubit

for i=5
    fidelity_MUB(:,:,i) = two_qubit_SIS2(i,'MUB');
    fidelity_SSQT(:,:,i) = two_qubit_SIS2(i,'SSQT');    
    fidelity_aMUB(:,:,i) = two_qubit_SIS2(i,'aMUB');
    fidelity_aSSQT(:,:,i) = two_qubit_SIS2(i,'aSSQT');
    [fidelity_fSSQT(:,:,i) indices_store_SIS] = two_qubit_SIS2(i,'fSSQT');
end
sparse = floor(logspace(log10(1),log10(100000),20));
for i=5
    figure
    loglog(sparse,mean((1-fidelity_MUB(sparse,:,i)),2),'r-','linewidth',1)
    hold on
    loglog(sparse,mean((1-fidelity_SSQT(sparse,:,i)),2),'m:','linewidth',1)
    loglog(sparse,mean((1-fidelity_aMUB(sparse,:,i)),2),'b--','linewidth',1)
    loglog(sparse,mean((1-fidelity_aSSQT(sparse,:,i)),2),'g:','linewidth',1)
    loglog(sparse,mean((1-fidelity_fSSQT(sparse,:,i)),2),'k','linewidth',1)
%     legend('MUB','SSQT','aMUB','aSSQT','fSSQT')
%     title(sprintf('case %g',i))
    xlim([50, 100000])
    ylim([3e-3,8e-1])
end

% for i=1:6
%     figure
%     semilogx(log(1-fidelity_MUB(:,:,i)),'r')
%     hold on
%     semilogx(log(1-fidelity_SSQT(:,:,i)),'m')
%     semilogx(log(1-fidelity_aMUB(:,:,i)),'b')
%     semilogx(log(1-fidelity_aSSQT(:,:,i)),'g')
%     semilogx(log(1-fidelity_fSSQT(:,:,i)),'k')
%     legend('MUB','SSQT','aMUB','aSSQT','fSSQT')
%     title(sprintf('case %g',i))
% end