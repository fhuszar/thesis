

%% initialise variables
dim = 4; %two qubit
k = 4; %full rank
S = 10000; % number of samples
Sthreshold = 1000; % threshold, when ESS falls below this, resample

%% generate uniform samples
samples = randn(S,k*dim)+1i*randn(S,k*dim);
samples = samples ./ repmat(sqrt(sum(samples.*conj(samples),2)),[1,k*dim]);
uniform_samples = samples;

% maximum number of measurements
Nmax = 100000;


% initialising measurements - just for testing, for experiments sensible
% measurement model needed.
% define constants
H = [1;0];
V = [0;1];
D = [1;1]/sqrt(2);
A = [1;-1]/sqrt(2);
R = [1;1i]/sqrt(2);
L = [1;-1i]/sqrt(2);
Ms_pos = [H,D,R];
Ms_neg = [V,A,L];
Ms_SSQT = kron([kron(Ms_pos,Ms_pos),kron(Ms_pos,Ms_neg),kron(Ms_neg,Ms_pos),kron(Ms_neg,Ms_neg)],eye(4));

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

measurements = Ms_FSQT;
Nmeas = size(measurements,2)/dim/k;
% generating random "ground thruth"

true_case = 3;
switch true_case
    case 1 % maximally mixed state
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
        p = rand();
        psi_true = sqrt(p)*kron(psi1 ./ norm(psi1),[1,0,0,0]) + sqrt(1-p)*kron(psi2 ./ norm(psi2),[0,0,0,1]);   
end
rho_true = (reshape(psi_true,[dim,dim]))'* (reshape(psi_true,[dim,dim]));
temp = (psi_true*measurements);
ps_true = reshape(sum(reshape(temp.*conj(temp),[k,Nmeas*dim]),1),[Nmeas,dim]);
cumps_true = cumsum(ps_true(:,1:dim-1),2);

%% active tomography via SIS

samples = uniform_samples;
data = zeros(S,Nmeas,dim);

%precomputing probabilities and entropies
temp = (samples*measurements);
ps_samples = reshape(sum(reshape(temp.*conj(temp),[S,k,dim*Nmeas]),2),[S,Nmeas,dim]);
lps_samples = log(ps_samples);
hs_samples = -sum(ps_samples.*lps_samples,3);
fidelities = zeros(S,1);
for s=1:S
    rho = (reshape(samples(s,:),[dim,k]))'* (reshape(samples(s,:),[dim,k]));
    fidelities(s) = trace((rho^(1/2)*rho_true*rho^(1/2))^(1/2))^2;
end
% the weights will sum to sumweights, not 1, for numerical stability
sumweights = 1e10;
weights = ones(S,1)*sumweights/S;

%initialise sigma
sigma = 0.05; % try to come up with better way of initialising sigma
maxgain = zeros(Nmax,1);
expgain = zeros(Nmax,1);
ESS = zeros(Nmax,1);
F = zeros(Nmax,1);
index = zeros(Nmax,1);
meanps_samples = zeros(1,Nmeas,dim);

for n=1:Nmax
    if mod(n,1000)==0
       disp(n) 
    end
    % selecting next measurement, computing BALD criterion using
    % precomputed log-probabilities
    for d = 1:dim
        meanps_samples(1,:,d) = (weights'*ps_samples(:,:,d))/sumweights;
    end
    h1 = -sum(meanps_samples.*log(meanps_samples),3);
    h2 = weights'*hs_samples/sumweights;
    

    
    % performing maximisation
    [expgain(n),index(n)] = max(h1-h2);
    % for random, use
    %index(n) = ceil(rand()*Nmeas);
    
    %index = 1+floor(rand()*Nmeas);
    
    % adding new datapoint (actually waiting for next photon to arrive)
    outcome = 1+sum(rand()>cumps_true(index(n),:));
    data(:,index(n),outcome) = data(:,index(n),outcome) + 1;
    
    %reweighting using sequential importance sampling rule. Note that
    %weights sum to sumweights, and not 1 for numerical stability. This is
    %faster than using logarithms.
    weights = weights.*ps_samples(:,index(n),outcome);
    weights = (weights*sumweights)/sum(weights);
    
    
    % for monitoring purposes
    maxgain(n) = (max(h1-h2)-min(h1-h2))/max(h1-h2);
    ESS(n) = sumweights^2/sum(weights.^2);
    F(n) = weights'*fidelities/sumweights;
    
    if ESS(n)<Sthreshold
        
        %disp(['iteration ', int2str(n),': ESS= ', num2str(ESS), ', performing resampling']);
        %perform resampling
        [samples,indices] = SMC_resample(samples,weights/sumweights);
        weights = ones(S,1)*sumweights/S;
        ps_samples = ps_samples(indices,:,:);
        
        %number of Metro-Hastings steps
        numsamples = 5;
        l_samples = sum(sum(log(ps_samples).*data,2),3);
        
        % the posterior variance should contract at a rate 1/sqrt(n), so
        % this seems to be a reasonable initialisation
        sigma = 0.1/sqrt(n);
        for i = 1:numsamples
            samplesnew = samples + sigma*randn(S,dim*k)+1i*sigma*randn(S,dim*k);
            samplesnew = samplesnew./repmat(sqrt(sum(samplesnew.*conj(samplesnew),2)),[1,dim*k]);
            temp = (samplesnew*measurements);
            ps_samplesnew = reshape(sum(reshape(temp.*conj(temp),[S,k,dim*Nmeas]),2),[S,Nmeas,dim]);
            % apparently, computing the logarithms here is the
            % computational bottleneck...
            lps_samplesnew = log(ps_samplesnew);
            l_samplesnew = sum(sum(lps_samplesnew.*data ,2),3);
            % computing acceptance
            a = (log(rand(S,1))<l_samplesnew-l_samples);
            
            l_samples(a)=l_samplesnew(a);
            ps_samples(a,:,:) = ps_samplesnew(a,:,:);
            lps_samples(a,:,:) = lps_samplesnew(a,:,:);
            samples(a,:) = samplesnew(a,:);
            
            % modifying sigma
            sigma = sigma * 1.3^(erf(mean(a)-0.6));
            %disp(max(l_samples/n));
        end
        disp(['acceptance: ',num2str(mean(a))]);
        % recomputing precomputed probabilities and entropies
        hs_samples = -sum(ps_samples.*lps_samples,3);
        for s=1:S
            rho = (reshape(samples(s,:),[dim,k]))'* (reshape(samples(s,:),[dim,k]));
            %NOTE: make sure a consistent definition of fidelity is used
            %everywhere
            fidelities(s) = trace((rho^(1/2)*rho_true*rho^(1/2))^(1/2))^2;
        end
    end
end

hold off;
loglog(1:Nmax,1-real(F),'b',1:Nmax,ESS/S,'r');
figure
hold on
loglog(1:Nmax,1-real(F1),'b')
loglog(1:Nmax,1-real(F),'r')