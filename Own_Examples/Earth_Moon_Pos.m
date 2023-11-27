close all;
clear;
addpath('../RESSLIB')
METAKR={ 'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls'; 
'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/de430.bsp'; 
'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/Gravity.tpc' };
initSPICEv(fullK(METAKR));
utctime='2000-01-01 T00:00:00';
et0 = cspice_str2et ( utctime );
NDAYS = 80;
et=linspace(et0,et0 + 60*3600*NDAYS,1000); % Vector of instants
frame = 'ECLIPJ2000'; % Referece frames
abcorr = 'NONE'; % No corrections
%observer = '3'; % Earth System barycenter
observer = '0'; % Solar System barycenter Try this
[dearth,lt] = cspice_spkezr('399',et,frame,abcorr,observer); % Earth state (km,km/s)
[dmoon, lt] = cspice_spkezr('301',et,frame,abcorr,observer); % Moon state (km,km/s)
plot3(dearth(1,:),dearth(2,:),dearth(3,:),'r') % Do the plot
hold on
plot3(dmoon(1,:),dmoon(2,:),dmoon(3,:),'g')
axis('equal');
set(findall(gcf,'-property','FontSize'),'FontSize',18)
xlabel('km');
ylabel('km');
zlabel('km');
title(sprintf('Earth and Moon position SPICE observer %s',observer))
legend({'Earth','Moon'});
endSPICE; % Unload the kernels