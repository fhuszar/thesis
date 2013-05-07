function [samples,y] = SMC_resample(samples,weights)
    edges = min([0; cumsum(weights)],1); % protect against accumulated round-off
    edges(end) = 1; % get the upper edge exact        
    [junk, y] = histc(rand(length(weights),1),edges);
    samples = samples(y,:);
end