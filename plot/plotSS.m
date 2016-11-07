clear all

myBlue = [0 184 255]/255;
myGreen = [0 230 101]/255;
myRed = [255 0 69]/255;
myGrey = [74 74 74]/255;

darkBlue = [0 97 127]/255;
darkRed = [127 0 39]/255;

mSize = 7.5;
lSize = 2.25;

myCase = 'c10';

fname = sprintf('ss_%s.mat',myCase);
load(fname)

switch myCase
    case 'c02'
        E = [0.525;0.75;0.975]*1e6;
        yp = [0.002,0.516;0.002,0.705;0.002,0.957];
        s1 = 0.5;
        ySc_95 = 0.9655;
        ySc_50 = 0.7461;
        ySc_05 = 0.5253;
    case 'c05'
        E = [0.24;0.6;0.96]*1e6;
        yp = [0.002,0.209;0.002,0.470;0.002,0.922];
        s1 = 0.2;
        ySc_95 = 0.9447;
        ySc_50 = 0.5923;
        ySc_05 = 0.2177;
    case 'c10'
        E = [0.145;0.55;0.96]*1e6;
        yp = [0.002,0.105;0.002,0.373;0.002,0.908];
        s1 = 0.1;
        ySc_95 = 0.9378;
        ySc_50 = 0.5405;
        ySc_05 = 0.1089;
end

close all
plot([0.2e-2,0.2e-2],[0,1.0],'LineWidth',2,'Color',[0.85 0.85 0.85])
hold all
plot([0.0,0.010], [s1,s1],'LineWidth',2,'Color',darkBlue)
plot([0.0,0.010], [1.0,1.0],'LineWidth',2,'Color',darkRed)

%% f2 = 18331/27^3
plot(strain_95, stress_95,'-.','LineWidth',lSize,'Marker','o','MarkerSize',mSize,'Color',myRed,'MarkerFaceColor',myRed)
plot([0.0,0.010], [ySc_95,ySc_95],'LineWidth',2,'Color',myRed)
plot(yp(3,1), yp(3,2),'LineWidth',2,'Marker','x','MarkerSize',1.5*mSize,'Color',myGrey);

%% f2 = 9716/27^3
plot(strain_50, stress_50,'-.','LineWidth',lSize,'Marker','o','MarkerSize',mSize,'Color',myGreen,'MarkerFaceColor',myGreen)
plot([0.0,0.010], [ySc_50,ySc_50],'LineWidth',2,'Color',myGreen)
plot(yp(2,1), yp(2,2),'LineWidth',2,'Marker','x','MarkerSize',1.5*mSize,'Color',myGrey);

%% f2 = 1008/27^3
plot(strain_05, stress_05,'-.','LineWidth',lSize,'Marker','o','MarkerSize',mSize,'Color',myBlue,'MarkerFaceColor',myBlue)
plot([0.0,0.010], [ySc_05,ySc_05],'LineWidth',2,'Color',myBlue)
plot(yp(1,1), yp(1,2),'LineWidth',2,'Marker','x','MarkerSize',1.5*mSize,'Color',myGrey);

xlim([-0.2e-3,0.01])
ylim([0,1.1])

% set(0,'defaultinterpreter','latex')
xlabel('Strain','FontName','Arial','FontSize',12)
ylabel('Stress, MPa','FontName','Arial','FontSize',12)

xTicks = [0:2:10]*1e-3;
yTicks = [0:0.2:1];
set(gca,'XTick',xTicks)

set(gca,'XTickLabel',sprintf('%.3f|',xTicks))
set(gca,'YTickLabel',sprintf('%.1f|',yTicks))
set(gca,'FontName','Arial','FontSize',10)