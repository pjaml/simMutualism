clc

generations = 30;
lowval = 1e-14;
nodes = (2^10) + 1;
diameter = 1200;
radius = diameter / 2;
x = linspace(-radius, radius, nodes);
x2 = linspace(-diameter, diameter, 2*nodes-1);
dx = diameter / (nodes - 1);
n = zeros(generations+1, length(x)); % density
[spd_inst, spd_avg] = deal(zeros(1, generations));

irad = 5;       % Initial condition range
idens = 2.0;      % Initial condition density maximum
ncrit = 0.05;   % critical threshold for edge of wave

% SET THE INITIAL CONDITIONS
temp = find(abs(x) <= irad);
n(1,temp) = idens*normpdf(x(temp),0,1);

% FIND THE INITIAL FRONT LOCATION
jj = find(n(1,:) >= ncrit,1,'last');
if jj
  xright(1) = interp1(n(1,jj:jj+1),x(jj:jj+1),ncrit);
end

% Gaussian kernel

sigma_sq = 0.25; % dispersal variance
k = exp(-(x2).^2/2*sigma_sq) ./ sqrt(2*pi*sigma_sq);

%For Fig 1a:
r = 0.9;      % Ricker growth

for i = 1:generations
% Ricker growth function
f = (n(i,:)>=a).*n(i,:) .* exp(r*(1-n(i,:)));

% dispersal phase
n1 = fft_conv(k, f);
n(i+1, :) = dx * n1(nodes:length(x2));
end

%% Figure panel 1a - COMPENSATORY NO ALLEE

	[xx,tt] = meshgrid(x,0:generations);
	nlow = n;
	nlow(n>=ncrit) = NaN;
	n(n<ncrit) = NaN;
	hold on
	for i = 1:11
	     plot3(xx(i,:),tt(i,:),n(i,:),'b');
	     plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
	     grid on
	end
	plot3(xright(1:11),0:10,ncrit*ones(1,11),'k')
    axis([-15 15 0 10 0 1.5]);
    xlabel('space (x)');
    ylabel('time (t)');
    zlabel('density (n)');
    view(30,30);
