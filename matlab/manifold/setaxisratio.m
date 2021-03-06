function setaxisratio(r)

set(gcf,'WindowStyle','normal');
set(gcf,'Position',[0,0,600,600]);

axisPosition = get(gca,'Position');

x1 = axisPosition(1);
y1 = axisPosition(2);
x2 = axisPosition(3);
y2 = axisPosition(4);
h = y2-y1;
w = x2-x1;

if r*w<h
    % shrink vertically
    axisPosition(4) = y1 + r*w;
    set(gca,'Position',axisPosition);
else
    % shrink horizontally
    axisPosition(3) = x1 + h/r;
    set(gca,'Position',axisPosition);
end