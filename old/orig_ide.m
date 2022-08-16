%  Code for Figure 1
%   First you run the models, then you put the figure together
%   March 2017 by Lauren L. Sullivan and Allison K. Shaw


%   This code takes ~10 hours to run

clear all; close all; clc;

%% Model for Panel 1a - COMPENSATORY NO ALLEE

iterations = 30;
lowval = 1e-14;
diameter = 1200;  
nodes = (2^10)+1;
radius = diameter/2;
x = linspace(-radius,radius,nodes);
x2 = linspace(-diameter,diameter,2*nodes-1);
dx = diameter/(nodes-1);
[speed_inst,speed_av] = deal(zeros(1,iterations));
xright = zeros(1,iterations+1);
n = zeros(iterations+1,length(x));

irad = 5;       % Initial condition range
idens = 2.0;      % Initial condition density maximum
ncrit = 0.05;   % critical threshold for edge of wave

%For Fig 1a: 
r = 0.9;      % Ricker growth


sigma_sq = 0.25;            % Dispersal variance 
k = exp(-sqrt((2*(x2).^2)/sigma_sq))./sqrt(2*sigma_sq);

% SET THE INITIAL CONDITIONS
temp = find(abs(x) <= irad);
n(1,temp) = idens*normpdf(x(temp),0,1);

% FIND THE INITIAL FRONT LOCATION
jj = find(n(1,:) >= ncrit,1,'last');
if jj
  xright(1) = interp1(n(1,jj:jj+1),x(jj:jj+1),ncrit);
end

for i = 1:iterations
    
%    REPRODUCTION
%    Ricker Model
    f = n(i,:).*exp(r*(1-n(i,:)));
    
%   DISPERSAL
    n1 = fft_conv(k,f);   % dispersing individuals
    n(i+1,:) = dx*n1(nodes:length(x2));
    n(i+1,1) = n(i+1,1)/2; n(i+1,nodes) = n(i+1,nodes)/2;
    temp = find(n(i+1,:) < lowval);
    n(i+1,temp) = zeros(size(n(i+1,temp)));
    
    jj = find(n(i+1,:) >= ncrit,1,'last');
    if jj
         xright(i+1) = interp1(n(i+1,jj:jj+1),x(jj:jj+1),ncrit);
    end
    speed_av(i) = (xright(i+1)-xright(1))/i;
    speed_inst(i) = xright(i+1)-xright(i);
    

end

%%  TO CREATE FIGURE 1


lfsize = 9;  % x/y label fontsize
lfsize2 = 7;  % x/y label fontsize
afsize = 9;  % axes numbering fontsize
afsize2 = 7;  % axes numbering fontsize
lw_edge = 1; % fig edge linewidth
tfsize = 11;  % title fontsize
mksize = 3;  % markersize


% figure(1); clf
% hh = gcf;
% set(hh,'PaperUnits','centimeters');
% set(hh,'Units','centimeters');
% width = 17.8; height = 11;
% xpos = 5;
% ypos = 4;
% set(gcf,'Position',[xpos ypos width height])

w = 0.18;
h = 0.28;
delx = 0.16;
s = 0.07;
dely = 0.22;

s2x = 0.10;
s2y = 0.35;
w2 = 0.08;
h2 = 0.08;

%% Figure panel 1a - COMPENSATORY NO ALLEE
% axes('position',[s s+dely+h w h])
	% load fig1_compensatory_noallee.mat
	[xx,tt] = meshgrid(x,0:iterations);
	nlow = n;
	nlow(n>=ncrit) = NaN;
	n(n<ncrit) = NaN;
	hold on
	for i = 1:11
	     plot3(xx(i,:),tt(i,:),n(i,:),'b');
	     plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
	     grid on
	end
	plot3(xright(1:11),0:10,ncrit*ones(1,11),'k');
    axis([-15 15 0 10 0 5]);
    xlabel('space (x)','FontSize',lfsize);
    ylabel('time (t)','FontSize',lfsize);
    zlabel('density (n)','FontSize',lfsize);
    view(30,30);
