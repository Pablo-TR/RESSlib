%Double and triple occultations of Galilean Moons
close all;
clear;
addpath('C:\Users\padlo\Desktop\ESEIAAT\TFG')
METAKR = {'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/jup365.bsp',...
          'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/jup344.bsp',...
          'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls', ...
          'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/de430.bsp',...
          'https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/pck00011.tpc'};

initSPICEv(fullK(METAKR));


occtyp  = 'ANY';
front   = 'JUPITER';
fshape  = 'ELLIPSOID';
fframe  = 'IAU_JUPITER'; 
back1   = 'IO';
back2   = 'CALLISTO';
back3   = 'GANYMEDE';
back4   = 'EUROPA';
bshape  = 'ELLIPSOID';
bframe  = {'IAU_IO', 'IAU_CALLISTO', 'IAU_GANYMEDE', 'IAU_EUROPA'};
abcorr  =  'NONE';
obsrvr  = 'EARTH';
step    = 900; 
startDate = cspice_str2et('1976-11-01T00:00:00');
endDate   = cspice_str2et('2025-11-03T00:00:00');
cnfine = cspice_wninsd(startDate, endDate);
nintvls = 30000;

jupIo = cspice_gfoclt( occtyp,front, fshape, fframe,back1, bshape, bframe(1), ...
                        abcorr,obsrvr,step,cnfine,nintvls);
jupCal = cspice_gfoclt( occtyp,front, fshape, fframe,back2, bshape, bframe(2), ...
                        abcorr,obsrvr,step,cnfine,nintvls);
jupGan = cspice_gfoclt( occtyp,front, fshape, fframe,back3, bshape, bframe(3), ...
                        abcorr,obsrvr,step,cnfine,nintvls);
jupEu = cspice_gfoclt( occtyp,front, fshape, fframe,back4, bshape, bframe(4), ...
                        abcorr,obsrvr,step,cnfine,nintvls);
printTimeWindow('Io occultation', jupIo,0);
printTimeWindow('Callisto occultation', jupCal,0);
printTimeWindow('Ganymede', jupGan,0);
printTimeWindow('Europa occultation', jupEu,0);

[IoCal, IoGan, IoEu, CalGan, CalEu, ... 
 GanEu, IoCalGan, IoCalEu, IoGanEu, CalGanEu, IoCalGanEu] = findIntersections(jupIo, jupCal, jupGan, jupEu);

printTimeWindow('Io-Callisto occultation', IoCal,1);
printTimeWindow('Io-Ganymede occultation', IoGan,1);
printTimeWindow('Io-Europa occultation', IoEu,1);
printTimeWindow('Callisto-Ganymede occultation', CalGan,1);
printTimeWindow('Callisto-Europa occultation', CalEu,1);
printTimeWindow('Ganymede-Europa occultation', GanEu,1);
printTimeWindow('Io-Callisto-Ganymede occultation', IoCalGan,1);
printTimeWindow('Io-Callisto-Europa occultation', IoCalEu,1);
printTimeWindow('Io-Ganymede-Europa occultation', IoGanEu,1);
printTimeWindow('Callisto-Ganymede-Europa occultation', CalGanEu,1);
printTimeWindow('4 moons occultation', IoCalGanEu);



%% Auxiliary functions
%Used to read correctly the result time window
function printTimeWindow(name,r,detail)
    fprintf('Time window <%s> contains %d intervals \n',name,numel(r)/2);
    if detail>0
        for i=1:numel(r)/2
        fprintf('From %s to %s: %.2f (s) \n',...
        cspice_et2utc( r(2*i-1),'C',1), ...
        cspice_et2utc( r(2*i),'C',1) , ...
        r(2*i) -r(2*i-1) );
        end
    end
end

%Used to find time intervals that intersect
function [ab, ac, ad, bc, bd, cd, abc, abd, acd, bcd, abcd] = findIntersections(a,b,c,d)
    ab = cspice_wnintd(a,b);
    ac = cspice_wnintd(a,c);
    ad = cspice_wnintd(a,d);
    bc = cspice_wnintd(b,c);
    bd = cspice_wnintd(b,d);
    cd = cspice_wnintd(c,d);
    if ab(:,1) ~=0
        abc = cspice_wnintd(ab,c);
        abd = cspice_wnintd(ab,d);
    end
    if cd(:,1)~=0
        acd = cspice_wnintd(a,cd);
        bcd = cspice_wnintd(b,cd);
    end
    if ab(:,1)~=0 && cd(:,1)~=0
        abcd = cspice_wnintd(ab,cd);
    end
end