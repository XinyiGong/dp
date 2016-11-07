% pcEqu = pc(1:114,:);
% pcSph = pc(115:228,:);
% pcDsk = pc(229:342,:);
% pcNdl = pc(343:end,:);
% 
% volEqu = volfr(1:114,:);
% volSph = volfr(115:228,:);
% volDsk = volfr(229:342,:);
% volNdl = volfr(343:end,:);

peakBlue = [0 184 255]/255;
peakGreen = [0 230 101]/255;
peakRed = [255 0 69]/255;
peakGrey = [74 74 74]/255;
peakOrange = [238 129 38]/255;

% hFig = figure; set(hFig, 'Position', [100 100 900 600])
% mSize = 150;
% s1 = scatter(pcEqu(:,1),pcEqu(:,2),mSize,volEqu,'filled','s','MarkerEdgeColor',peakGrey,'LineWidth',0.75);
% hold all
% s2 = scatter(pcSph(:,1),pcSph(:,2),mSize,volSph,'filled','o','MarkerEdgeColor',peakGrey,'LineWidth',0.75);
% s3 = scatter(pcDsk(:,1),pcDsk(:,2),mSize,volDsk,'filled','d','MarkerEdgeColor',peakGrey,'LineWidth',0.75);
% s4 = scatter(pcNdl(:,1),pcNdl(:,2),mSize,volNdl,'filled','^','MarkerEdgeColor',peakGrey,'LineWidth',0.75);

mSize = 100;
 
for ii = 2:10
    xi = 1;
    yi = ii;
    figure;
    scatter(pcSph(:,xi),pcSph(:,yi),mSize,'filled','o','MarkerEdgeColor',peakGreen,'MarkerFaceColor',peakGreen);
    hold all; 
    scatter(pcDsk(:,xi),pcDsk(:,yi),mSize,'filled','d','MarkerEdgeColor',peakOrange,'MarkerFaceColor',peakOrange);
    scatter(pcNdl(:,xi),pcNdl(:,yi),mSize,'filled','^','MarkerEdgeColor',peakBlue,'MarkerFaceColor',peakBlue);
    scatter(pcEqu(:,xi),pcEqu(:,yi),mSize,'filled','s','MarkerEdgeColor',peakGrey,'MarkerFaceColor',peakGrey);
    set(gcf,'color','w')
    fname = sprintf('pc_%d%d.png',xi,yi);
    export_fig(fname)
end
% figure; 
% mSize = 180;
% s5 = scatter(pcEqu(:,2),pcEqu(:,3),mSize,volEqu,'filled','s','MarkerEdgeColor',[0.8 0.8 0.8]);
% hold all
% s6 = scatter(pcSph(:,2),pcSph(:,3),mSize,volSph,'filled','o','MarkerEdgeColor',[0.5 0.5 0.5]);
% s7 = scatter(pcDsk(:,2),pcDsk(:,3),mSize,volDsk,'filled','d','MarkerEdgeColor',[0.5 0.5 0.5]);
% s8 = scatter(pcNdl(:,2),pcNdl(:,3),mSize,volNdl,'filled','^','MarkerEdgeColor',[0.5 0.5 0.5]);
% 
% figure; 
% mSize = 180;
% s9 = scatter(pcEqu(:,1),pcEqu(:,3),mSize,volEqu,'filled','s','MarkerEdgeColor',[0.8 0.8 0.8]);
% hold all
% s10 = scatter(pcSph(:,1),pcSph(:,3),mSize,volSph,'filled','o','MarkerEdgeColor',[0.5 0.5 0.5]);
% s11 = scatter(pcDsk(:,1),pcDsk(:,3),mSize,volDsk,'filled','d','MarkerEdgeColor',[0.5 0.5 0.5]);
% s12 = scatter(pcNdl(:,1),pcNdl(:,3),mSize,volNdl,'filled','^','MarkerEdgeColor',[0.5 0.5 0.5]);

% cmp = makeColorMap(peakGrey,[1,1,1],peakRed);
% colormap(cmp)
% colorbar

% set(s1,'LineWidth',0.2)
% set(s2,'LineWidth',0.2)
% set(s3,'LineWidth',0.2)
% set(s3,'LineWidth',0.2)