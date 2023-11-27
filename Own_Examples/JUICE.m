close all;
clear;
addpath('C:\Users\padlo\Desktop\ESEIAAT\TFG')
METAKR = {'https://spiftp.esac.esa.int/data/SPICE/JUICE/kernels/spk/jup365_19900101_20500101.bsp',...
          'https://spiftp.esac.esa.int/data/SPICE/JUICE/kernels/spk/jup344-s2003_j24_19900101_20500101.bsp',...
          'https://spiftp.esac.esa.int/data/SPICE/JUICE/kernels/spk/juice_orbc_000051_230414_310721_v01.bsp',...
          'https://spiftp.esac.esa.int/data/SPICE/JUICE/kernels/lsk/naif0012.tls', ...
          'https://spiftp.esac.esa.int/data/SPICE/JUICE/kernels/spk/de430.bsp',... 
          'https://spiftp.esac.esa.int/data/SPICE/JUICE/kernels/pck/pck00011.tpc'};
initSPICEv(fullK(METAKR));

utctime='2023-04-15 T00:00:00';

et0 = cspice_str2et ( utctime );

NDAYS = 365*8.1;

et1 = et0 + 24*3600*NDAYS; % end of query time
et=linspace(et0,et1,10000);

LW=3; % LineWidth of the plots

frame        = 'ECLIPJ2000';
abcorr       = 'NONE';
NAIF_JUICE   = 'JUICE';
NAIF_Jupiter = '599';
NAIF_Earth   = 'Earth';

figure(1);

observer = '5'; % Solar System  barycenter
scale = 149597871 ; % AU (km) 

%https://nssdc.gsfc.nasa.gov/planetary/factsheet/jupiterfact.html

[djup,lt] = cspice_spkezr(NAIF_Jupiter,et,frame,abcorr,observer); % jupiter 
[dJUICE, lt] = cspice_spkezr(NAIF_JUICE,et,frame,abcorr,observer); % JUICE
[dE, lt] = cspice_spkezr(NAIF_Earth,et,frame,abcorr,observer); % Earth

plot3(djup(1,:)/scale,djup(2,:)/scale,djup(3,:)/scale,'r','LineWidth',LW)
hold on
plot3(dJUICE(1,:)/scale,dJUICE(2,:)/scale,dJUICE(3,:)/scale,'g','LineWidth',LW)
plot3(dE(1,:)/scale,dE(2,:)/scale,dE(3,:)/scale,'b','LineWidth',LW)
xlabel('AU');
ylabel('AU');
zlabel('AU');
axis('equal');
legend({'J','JU','E'});
title('JUICE trajectory. Obs: SS barycenter. Frame ECLIPJ2000');
grid
set(findall(gcf,'-property','FontSize'),'FontSize',18);