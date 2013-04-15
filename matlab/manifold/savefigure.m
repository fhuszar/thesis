function savefigure(filename,figno,aspectratio)
    if nargin>1
        figure(figno)
    end
    if nargin>2
        setaxisratio(aspectratio);
    end
    matlab2tikz(filename)
    if nargin>2
        set(gcf,'WindowStyle','docked');
    end