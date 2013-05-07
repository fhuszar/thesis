% select true state from: max mixed(1), HH+VV(2) HV(2)

% max number of copies used
N = 10^5;
numNs = 10;
Ns = ceil(logspace(2,5,numNs));

% number of samples used
S = 100;

% rank used for inference

% r = 4;
% true_state = 6;


%% initialise measurements

% define constants
H = [1;0];
V = [0;1];
D = [1;1]/sqrt(2);
A = [1;-1]/sqrt(2);
R = [1;1i]/sqrt(2);
L = [1;-1i]/sqrt(2);


% initialize measurements SSQR
Ms_pos = [H,D,R];
Ms_neg = [V,A,L];
Ms_SSQT = kron([kron(Ms_pos,Ms_pos),kron(Ms_pos,Ms_neg),kron(Ms_neg,Ms_pos),kron(Ms_neg,Ms_neg)],eye(4));


% initialize measurements for FSQT
Ms_pos = [D,R,H,...
    [1/sqrt(2);0.5 + 0.5i],...
    [1/sqrt(2);-0.5 + 0.5i],...
    [cos(pi/8);sin(pi/8)],...
    [-cos(pi/8);sin(pi/8)],...
    [cos(pi/8);1i*sin(pi/8)],...
    [cos(pi/8);-1i*sin(pi/8)]];
Ms_neg = [A,L,V,...
    [-1/sqrt(2);0.5 + 0.5i],...
    [1/sqrt(2);0.5 - 0.5i],...
    [-sin(pi/8);cos(pi/8)],...
    [sin(pi/8);cos(pi/8)],...
    [-sin(pi/8);1i*cos(pi/8)],...
    [sin(pi/8);1i*cos(pi/8)]];

Ms_FSQT = kron([kron(Ms_pos,Ms_pos),kron(Ms_pos,Ms_neg),kron(Ms_neg,Ms_pos),kron(Ms_neg,Ms_neg)],eye(4));

% initialize measurements for MUB tomography
Ms = [...
    kron(H,H),...
    kron(R,D),...
    kron(D,R),...
    (kron(R,L)+1i*kron(L,R))/sqrt(2),...
    (kron(R,V)+1i*kron(L,H))/sqrt(2),...
    kron(H,V),...
    kron(R,A),...
    kron(D,L),...
    (kron(R,L)-1i*kron(L,R))/sqrt(2),...
    (kron(R,V)-1i*kron(L,H))/sqrt(2),...
    kron(V,H),...
    kron(L,D),...
    kron(A,R),...
    (kron(R,R)+1i*kron(L,L))/sqrt(2),...
    (kron(R,H)+1i*kron(L,V))/sqrt(2),...
    kron(V,V),...
    kron(L,A),...
    kron(A,L),...
    (kron(R,R)-1i*kron(L,L))/sqrt(2),...
    (kron(R,H)-1i*kron(L,V))/sqrt(2),...
    ];
Ms_MUB = kron(Ms,eye(4));

%% actual script
N_iters=10;
N_states=7;

F_SSQT = zeros(numNs,N_iters,N_states);
F_MUB = zeros(numNs,N_iters,N_states);
F_ASSQT = [];
F_AMUB = [];
F_AFSQT = [];
for iteration = 1:N_iters
    for true_state = 1:N_states
        switch true_state
            case 1 % max mix
                psi_true = (kron([1,0,0,0],[1,0,0,0]) + kron([0,1,0,0],[0,1,0,0]) + kron([0,0,1,0],[0,0,1,0]) + kron([0,0,0,1],[0,0,0,1]))/2;
            case 2 % HH + VV
                psi_true = (kron([1,0,0,0],[1,0,0,0]) + kron([0,0,0,1],[1,0,0,0]))/sqrt(2);
            case 3 %HV
                psi_true = kron([0,1,0,0],[1,0,0,0]);
            case 4 %random mixed, rank 4
                psi = randn(1,4*4)+1i*randn(1,4*4);
                psi_true = psi ./ repmat(sqrt(sum(psi.*conj(psi),2)),[1,4*4]);
            case 5 %random pure
                psi = randn(1,4)+1i*randn(1,4);
                psi_true = kron(psi ./ norm(psi),[1,0,0,0]);
            case 6 %random mixed, rank = 2
                psi1 = randn(1,4)+1i*randn(1,4);
                psi2 = randn(1,4)+1i*randn(1,4);
                psi_true = kron(psi1 ./ norm(psi1),[1,0,0,0]) + kron(psi2 ./ norm(psi2),[0,0,0,1]);
            case 7 %random mixed, rank = 3
                psi1 = randn(1,4)+1i*randn(1,4);
                psi2 = randn(1,4)+1i*randn(1,4);
                psi3 = randn(1,4)+1i*randn(1,4);
                psi_true = kron(psi1 ./ norm(psi1),[1,0,0,0]) + kron(psi2 ./ norm(psi2),[0,1,0,0]) + kron(psi3 ./ norm(psi3),[0,0,1,0]);
        end
        
        % just in case...
        psi_true=psi_true / norm(psi_true);
        
        rho_true = (reshape(psi_true,[4,4]))'* (reshape(psi_true,[4,4]));
        
        temp = (psi_true*Ms_SSQT);
        psSSQT = reshape(sum(reshape(temp.*conj(temp),[4,36]),1),[9,4]);
        
        temp = (psi_true*Ms_FSQT);
        psFSQT = reshape(sum(reshape(temp.*conj(temp),[4,81*4]),1),[81,4]);
        
        temp = (psi_true*Ms_MUB);
        psMUB = reshape(sum(reshape(temp.*conj(temp),[4,20]),1),[5,4]);
        
        
        numsamples=200;
        
        disp('fixed SSQT')
        % SSQT tomography
        % initialise samples
        psi = randn(S,4*4)+1i*randn(S,4*4);
        psi = psi ./ repmat(sqrt(sum(psi.*conj(psi),2)),[1,4*4]);
        clf;
        
        sigma = 0.5;
        E = [];
        for n=1:numNs
            data = mnrnd(ceil(Ns(n)/9),psSSQT);
            for i = 1:numsamples
                % proposing new states
                psinew = psi + sigma*(randn(S,4*4)+1i*randn(S,4*4));
                psinew = psinew ./ repmat(sqrt(sum(psinew.*conj(psinew),2)),[1,4*4]);
                temp = (psi*Ms_SSQT);
                ps_psi = reshape(sum(reshape(temp.*conj(temp),[S,4,36]),2),[S,9,4]);
                l_psi = sum(sum(log(ps_psi).*repmat(permute(data,[3,1,2]),[S,1,1]),2),3);
                temp = (psinew*Ms_SSQT);
                ps_psinew = reshape(sum(reshape(temp.*conj(temp),[S,4,36]),2),[S,9,4]);
                l_psinew = sum(sum(log(ps_psinew).*repmat(permute(data,[3,1,2]),[S,1,1]),2),3);
                a = log(rand(S,1))<l_psinew-l_psi;
                psi(a,:) = psinew(a,:);
                sigma = sigma * 1.2^(erf(mean(a)-0.4));
            end
            for s=1:S
                rho = (reshape(psi(s,:),[4,4]))'* (reshape(psi(s,:),[4,4]));
                F_SSQT(n,iteration,true_state) = F_SSQT(n,iteration,true_state) + trace((rho^(1/2)*rho_true*rho^(1/2))^(1/2))^2;
            end
            F_SSQT(n,iteration,true_state) = real(F_SSQT(n,iteration,true_state))/S;
        end
        
        disp('fixed MUB');
        % MUB tomography
        % initialise samples
        psi = randn(S,4*4)+1i*randn(S,4*4);
        psi = psi ./ repmat(sqrt(sum(psi.*conj(psi),2)),[1,4*4]);
        clf;
        
        sigma = 0.5;
        for n=1:numNs
            data = mnrnd(ceil(Ns(n)/5),psMUB);
            for i = 1:numsamples
                % proposing new states
                psinew = psi + sigma*(randn(S,4*4)+1i*randn(S,4*4));
                psinew = psinew ./ repmat(sqrt(sum(psinew.*conj(psinew),2)),[1,4*4]);
                temp = (psi*Ms_MUB);
                ps_psi = reshape(sum(reshape(temp.*conj(temp),[S,4,20]),2),[S,5,4]);
                l_psi = sum(sum(log(ps_psi).*repmat(permute(data,[3,1,2]),[S,1,1]),2),3);
                temp = (psinew*Ms_MUB);
                ps_psinew = reshape(sum(reshape(temp.*conj(temp),[S,4,20]),2),[S,5,4]);
                l_psinew = sum(sum(log(ps_psinew).*repmat(permute(data,[3,1,2]),[S,1,1]),2),3);
                a = log(rand(S,1))<l_psinew-l_psi;
                psi(a,:) = psinew(a,:);
                sigma = sigma * 1.5^(erf(mean(a)-0.5));
            end
            for s=1:S
                rho = (reshape(psi(s,:),[4,4]))'* (reshape(psi(s,:),[4,4]));
                F_MUB(n,iteration,true_state) = F_MUB(n,iteration,true_state) + trace((rho^(1/2)*rho_true*rho^(1/2))^(1/2))^2;
            end
            F_MUB(n,iteration,true_state) = real(F_MUB(n,iteration,true_state))/S;
        end
        
        % adaptive SSQT (always choosing the best basis)
        
        disp('adaptive SSQT');
        % adaptive SSQT
        ns_SSQT = ones(9,1);
        psi = randn(S,4*4)+1i*randn(S,4*4);
        psi = psi ./ repmat(sqrt(sum(psi.*conj(psi),2)),[1,4*4]);
        numsamples = 8;
        data = mnrnd(ns_SSQT,psSSQT);
        
        sigma = 0.5;
        
        for n=1:3000
            for i = 1:numsamples+10*(n<5)
                % proposing new states
                psinew = psi + sigma*(randn(S,4*4)+1i*randn(S,4*4));
                psinew = psinew ./ repmat(sqrt(sum(psinew.*conj(psinew),2)),[1,4*4]);
                temp = (psi*Ms_SSQT);
                ps_psi = reshape(sum(reshape(temp.*conj(temp),[S,4,36]),2),[S,9,4]);
                l_psi = sum(sum(log(ps_psi).*repmat(permute(data,[3,1,2]),[S,1,1]),2),3);
                temp = (psinew*Ms_SSQT);
                ps_psinew = reshape(sum(reshape(temp.*conj(temp),[S,4,36]),2),[S,9,4]);
                l_psinew = sum(sum(log(ps_psinew).*repmat(permute(data,[3,1,2]),[S,1,1]),2),3);
                a = log(rand(S,1))<l_psinew-l_psi;
                psi(a,:) = psinew(a,:);
                sigma = sigma * 1.5^(erf(mean(a)-0.5));
            end
            ps_psi(a,:) = ps_psinew(a,:);
            h1 = sum(-mean(ps_psi).*log(mean(ps_psi)),3);
            h2 = mean(sum(-ps_psi.*log(ps_psi),3));
            [m,i] = max(h1-h2);
            ns_SSQT(i) = ns_SSQT(i)+30;
            data(i,:) = data(i,:) + mnrnd(30,psSSQT(i,:));
            F = 0;
            if mod(n,50)==0
                disp('.');
                for s=1:S
                    rho = (reshape(psi(s,:),[4,4]))'* (reshape(psi(s,:),[4,4]));
                    F = F + trace((rho^(1/2)*rho_true*rho^(1/2))^(1/2))^2;
                end
                F_ASSQT(n/50,iteration,true_state) = real(F/S);
            end
        end
        
        disp('adaptive mub')
        %adaptive MUB tomography
        ns_MUB = ones(5,1);
        psi = randn(S,4*4)+1i*randn(S,4*4);
        psi = psi ./ repmat(sqrt(sum(psi.*conj(psi),2)),[1,4*4]);
        numsamples = 8;
        data = mnrnd(ns_MUB,psMUB);
        
        sigma = 0.5;
        for n=1:3000
            for i = 1:numsamples+10*(n<5)
                % proposing new states
                psinew = psi + sigma*(randn(S,4*4)+1i*randn(S,4*4));
                psinew = psinew ./ repmat(sqrt(sum(psinew.*conj(psinew),2)),[1,4*4]);
                temp = (psi*Ms_MUB);
                ps_psi = reshape(sum(reshape(temp.*conj(temp),[S,4,20]),2),[S,5,4]);
                l_psi = sum(sum(log(ps_psi).*repmat(permute(data,[3,1,2]),[S,1,1]),2),3);
                temp = (psinew*Ms_MUB);
                ps_psinew = reshape(sum(reshape(temp.*conj(temp),[S,4,20]),2),[S,5,4]);
                l_psinew = sum(sum(log(ps_psinew).*repmat(permute(data,[3,1,2]),[S,1,1]),2),3);
                a = log(rand(S,1))<l_psinew-l_psi;
                psi(a,:) = psinew(a,:);
                sigma = sigma * 1.5^(erf(mean(a)-0.5));
            end
            ps_psi(a,:) = ps_psinew(a,:);
            h1 = sum(-mean(ps_psi).*log(mean(ps_psi)),3);
            h2 = mean(sum(-ps_psi.*log(ps_psi),3));
            [m,i] = max(h1-h2);
            ns_MUB(i) = ns_MUB(i)+30;
            data(i,:) = data(i,:) + mnrnd(30,psMUB(i,:));
            F = 0;
            if mod(n,50)==0
                disp('.');
                for s=1:S
                    rho = (reshape(psi(s,:),[4,4]))'* (reshape(psi(s,:),[4,4]));
                    F = F + trace((rho^(1/2)*rho_true*rho^(1/2))^(1/2))^2;
                end
                F_AMUB(n/50,iteration,true_state) = real(F/S);
            end
        end
        
        disp('adaptive FSQT');
        % % adaptive flexible SQT
        ns_FSQT = ones(81,1);
        psi = randn(S,4*4)+1i*randn(S,4*4);
        psi = psi ./ repmat(sqrt(sum(psi.*conj(psi),2)),[1,4*4]);
        numsamples = 8;
        data = mnrnd(ns_FSQT,psFSQT);
        
        Ns_adaptive = [];
        sigma = 0.5;
        for n=1:3000
            for i = 1:numsamples+10*(n<5)
                % proposing new states
                psinew = psi + sigma*(randn(S,4*4)+1i*randn(S,4*4));
                psinew = psinew ./ repmat(sqrt(sum(psinew.*conj(psinew),2)),[1,4*4]);
                temp = (psi*Ms_FSQT);
                ps_psi = reshape(sum(reshape(temp.*conj(temp),[S,4,81*4]),2),[S,81,4]);
                l_psi = sum(sum(log(ps_psi).*repmat(permute(data,[3,1,2]),[S,1,1]),2),3);
                temp = (psinew*Ms_FSQT);
                ps_psinew = reshape(sum(reshape(temp.*conj(temp),[S,4,81*4]),2),[S,81,4]);
                l_psinew = sum(sum(log(ps_psinew).*repmat(permute(data,[3,1,2]),[S,1,1]),2),3);
                a = log(rand(S,1))<l_psinew-l_psi;
                psi(a,:) = psinew(a,:);
                sigma = sigma * 1.5^(erf(mean(a)-0.5));
            end
            ps_psi(a,:) = ps_psinew(a,:);
            h1 = sum(-mean(ps_psi).*log(mean(ps_psi)),3);
            h2 = mean(sum(-ps_psi.*log(ps_psi),3));
            [m,i] = max(h1-h2);
            ns_FSQT(i) = ns_FSQT(i)+30;
            data(i,:) = data(i,:) + mnrnd(30,psFSQT(i,:));
            F = 0;
            if mod(n,50)==0
                disp('.');
                for s=1:S
                    rho = (reshape(psi(s,:),[4,4]))'* (reshape(psi(s,:),[4,4]));
                    F = F + trace((rho^(1/2)*rho_true*rho^(1/2))^(1/2))^2;
                end
                F_AFSQT(n/50,iteration,true_state) = real(F/S);
                Ns_adaptive(n/50) = sum(sum(data));
            end
        end
        time = clock;
                save(['two_qubit_case_2'...
                    num2str(time(1))... % Returns year as character
                    num2str(time(2))... % Returns month as character
                    num2str(time(3))... % Returns day as char
                    num2str(time(4))... % returns hour as char..
                    num2str(time(5))... %returns minute as char
                    num2str(ceil(time(6)))... % returns seconds as char
                    ],...
                    'F_MUB','F_SSQT','F_ASSQT','F_AFSQT','F_AMUB','Ns','Ns_adaptive');
        
    end
end

 Ns_adaptive = [30*50:30*50:30*3000];
for  i =1:N_states
    figure(i)
    title(sprintf('run %f',i))
    semilogx(Ns,log(1-mean(F_MUB(:,:,i),2)),':.','color','r')
    hold on
    semilogx(Ns,log(1-mean(F_SSQT(:,:,i),2)),':.','color','g')
    semilogx(Ns_adaptive,log(1-mean(F_ASSQT(:,:,i),2)),':.')
    semilogx(Ns_adaptive,log(1-mean(F_AMUB(:,:,i),2)),':.','color','cyan')
    legend('MUB','SSQT','ASSQT','AMUB')
end

