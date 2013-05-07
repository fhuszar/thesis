close all
clear all

%% initialise variables samples
S = 5000; % number of samples
Sthreshold = 1000; % threshold, when ESS falls below this, resample
% Ss = floor(logspace(log10(500),log10(10000),15)); % number of samples
% Ss =10000;
% Sthresholds = logspace(log10(2),log10(4000),15); % threshold, when ESS falls below this, resample
% Sthresholds = Ss/4;

        % Pauli matrices
        sx = [0 1; 1 0];
        sy = [0 -1i;1i 0];
        sz = [1 0;0 -1];

        Niter=1;
for iter = 1:Niter
    disp(iter)
%     for Si=1:length(Ss)
        
%         S = Ss(Si); % number of samples
%         Sthreshold = Sthresholds(Si); % threshold
        

        
        %% generate uniform samples
        samples = [];
        while length(samples)<S
            temp = 2*rand(floor(S/4),3)-1;
            samples = [samples;temp(sum(temp.^2,2)<=1,:)];
        end
        uniform_samples = samples(1:S,:);
        
        % maximum number of measurements
        Nmax = 100;
        
        
        % initialising measurements - just for testing, for experiments sensible
        % measurement model needed.
        measurements = randn(3,25);
        measurements = measurements ./ repmat(sqrt(sum(measurements.^2,1)),[3,1]);
        Nmeas = size(measurements,2);
        Nmax = ceil(Nmax/Nmeas)*Nmeas;
        
        % generating random "ground truth" with specified purity
        purity = 1;
        rho_true = randn(1,3);
        rho_true = rho_true/norm(rho_true)*sqrt(2*purity-1);
        ps_true = (rho_true*measurements + 1)/2;
        sqrt_rho_true = ([sx*rho_true(1)+sy*rho_true(2)+sz*rho_true(3)+eye(2)]/2)^0.5;
        %% active tomography via SIS
        
        samples = uniform_samples;
        data = zeros(S,Nmeas);
        negdata = zeros(S,Nmeas);
        
        %precomputing probabilities and entropies
        ps_samples = (samples*measurements+1)/2;
        lps_samples = log(ps_samples);
        lqs_samples = log(1-ps_samples);
        hs_samples = -ps_samples.*lps_samples + (ps_samples-1).*lqs_samples;
        fs_samples = zeros(S,1);
        for i=1:S
            sqrt_rho_sample = ([sx*samples(i,1)+sy*samples(i,2)+sz*samples(i,3)+eye(2)]/2)^0.5;
            fs_samples(i) = real((trace(sqrt_rho_sample*sqrt_rho_true))^2);
        end
        
        % the weights will sum to sumweights, not 1, for numerical stability
        sumweights = 1e10;
        weights = ones(S,1)*sumweights/S;
        
        %initialise sigma
        sigma = 0.05; % try to come up with better way of initialising sigma
        maxgain = zeros(Nmax,1);
        ESS = zeros(Nmax,1);
        fidelity = zeros(Nmax,1);
        
        for n=1:Nmax
            % selecting next measurement, computing BALD criterion using
            % precomputed log-probabilities
            meanps_samples = (weights'*ps_samples)/sumweights;
            h1 = -meanps_samples.*log(meanps_samples) + (meanps_samples-1).*log(1-meanps_samples);
            h2 = weights'*hs_samples/sumweights;
            
            % for monitoring purposes
            maxgain(n) = (max(h1-h2)-min(h1-h2))/max(h1-h2);
            
            % performing maximisation
            [~,index] = max(h1-h2);
            index = index(1);
            
            % adding new datapoint (actually waiting for next photon to arrive)
            newdata = rand()<ps_true(index);
            data(:,index) = data(:,index) + newdata;
            negdata(:,index) = negdata(:,index) + 1-newdata;
            
            %reweighting using sequential importance sampling rule. Note that
            %weights sum to sumweights, and not 1 for numerical stability. This is
            %faster than using logarithms.
            weights = weights.*(ps_samples(:,index)*newdata + (1-ps_samples(:,index))*(1-newdata));
            weights = (weights*sumweights)/sum(weights);
            
            %computing effective sample size
            ESS(n) = sumweights^2/sum(weights.^2);
            
            if ESS(n)<Sthreshold
                
                %disp(['iteration ', int2str(n),': ESS= ', num2str(ESS), ', performing resampling']);
                %perform resampling
                [samples] = SMC_resample(samples,weights/sumweights);
                weights = ones(S,1)*sumweights/S;
                
                %number of Metro-Hastings steps
                numsamples = 5;
                ps_samples = (samples*measurements+1)/2;
                l_samples = sum(log(ps_samples).*data + log(1-ps_samples).*negdata,2);
                l_samplesnew = l_samples;
                
                for i = 1:numsamples
                    samplesnew = samples + sigma*randn(S,3);
                    a = sum(samplesnew.^2,2)<=1;
                    ps_samplesnew = (samplesnew(a,:)*measurements+1)/2;
                    % apparently, computing the logarithms here is the
                    % computational bottleneck...
                    l_samplesnew(a) = sum(log(ps_samplesnew).* data(a,:) + log(1-ps_samplesnew).*negdata(a,:),2);
                    a = a&(log(rand(S,1))<l_samplesnew-l_samples);
                    l_samples(a)=l_samplesnew(a);
                    samples(a,:) = samplesnew(a,:);
                    sigma = sigma * 1.4^(erf(mean(a)-0.6));
                end
                %disp(['acceptance: ',num2str(mean(a))]);
                % recomputing precomputed probabilities and entropies
                ps_samples = (samples*measurements+1)/2;
                lps_samples = log(ps_samples);
                lqs_samples = log(1-ps_samples);
                hs_samples = -ps_samples.*lps_samples + (ps_samples-1).*lqs_samples;
                for i=1:S
                    sqrt_rho_sample = ([sx*samples(i,1)+sy*samples(i,2)+sz*samples(i,3)+eye(2)]/2)^0.5;
                    fs_samples(i) = real((trace(sqrt_rho_sample*sqrt_rho_true))^2);
                end
                
            end
            
            % compute fidelity of new posterior
            fidelity(n) = weights'*fs_samples/sumweights;
            
        end
        
        %final resampling and MCMC sampling for visualisation
        samples = SMC_resample(samples,weights/sumweights);
        
        samples_SMC = samples;
        
        numsamples = 10;
        ps_samples = (samples*measurements+1)/2;
        l_samples = sum(log(ps_samples).*data + log(1-ps_samples).*negdata,2);
        l_samplesnew = l_samples;
        
        for i = 1:numsamples
            samplesnew = samples + sigma*randn(S,3);
            a = sum(samplesnew.^2,2)<=1;
            ps_samplesnew = (samplesnew(a,:)*measurements+1)/2;
            % apparently, computing the logarithms here is the
            % computational bottleneck...
            l_samplesnew(a) = sum(log(ps_samplesnew).* data(a,:) + log(1-ps_samplesnew).*negdata(a,:),2);
            a = a&(log(rand(S,1))<l_samplesnew-l_samples);
            l_samples(a)=l_samplesnew(a);
            samples(a,:) = samplesnew(a,:);
            sigma = sigma * 1.5^(erf(mean(a)-0.6));
        end
        
        samples_adaptive = samples;
        
%         final_fidelity(Si,iter)=fidelity(end);
        
%     end
    
end
%% visualisation

hold off;
plot3(samples_adaptive(:,1),samples_adaptive(:,2),samples_adaptive(:,3),'.','MarkerSize',2)
hold on;
plot3(rho_true(1),rho_true(2),rho_true(3),'rx');
xlim([-1,1]);
ylim([-1,1]);
zlim([-1,1]);
[x,y,z] = sphere(20);
surf(x,y,z,'FaceAlpha',0,'EdgeAlpha',0.3);
n = 10;
numframes = 30;
axis square
axis vis3d
axis off
set(gca,'nextplot','replacechildren');
for i=1:numframes
    camorbit(12,0)
    drawnow
end
%figure
% mesh(Ss,Sthresholds,log(1-final_fidelity))
% for i=1:Niter
%     semilogx(Ss,log(1-final_fidelity(:,i)))
%     hold on
% end