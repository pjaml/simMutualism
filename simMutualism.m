clearvars
clc

function simMutualism(varargin)

%% for simulation

iterations = 60; % cycles of growth and dispersal
steady_state_threshold = 1e-04; % threshold for speed variance at steady state
max_iterations = 500;
add_iterations = 100;

% format spec for floating point values in filenames
fspec = '%.2f';

%% Initialize space parameters
lowval = 1e-9;
diameter = 1200;  %total size of landscape along positive x-axis (so technically half the size of the total landscape)
nodes = (2^16)+1; %total points in space -- 65537
radius = diameter/2;
x = linspace(-radius,radius,nodes);
x2 = linspace(-diameter,diameter,2*nodes-1);
dx = diameter/(nodes-1);

[speed_inst_P,speed_av_P, speed_inst_F1,speed_av_F1, speed_inst_F2, speed_av_F2] = deal(zeros(1,iterations)); %assign initializing values to each of the arrays
[xright_P,xright_F1, xright_F2] = deal(zeros(1,iterations+1)); %array with 1 row and 201 columns. tells us the farthest a population has reached
[n_P,n_F1, n_F2] = deal(zeros(iterations+1,length(x))); %array with 201 rows and 65537 columns. tells us population density at each node along column and each time step/iteration is one row. define ,f_P_all,f_F_all if you wish to do post census calculations

sigma_sq = 0.25; % Dispersal variance

% gaussian dispersal kernels
k_P = exp(-(x2.^2)/(2*sigma_sq))./sqrt(2*pi*sigma_sq);
k_F1 = exp(-(x2.^2)/(2*sigma_sq))./sqrt(2*pi*sigma_sq);
k_F2 = exp(-(x2.^2)/(2*sigma_sq))./sqrt(2*pi*sigma_sq);

% SET THE INITIAL CONDITIONS
irad = 2; % Initial condition range
idens = [0.1,0.1,0.1];
ncrit = 0.05; % critical threshold for edge of wave
temp_P = find(abs(x) <= irad); %locate all values in the array x that lie b/w +irad and -irad units of space
temp_F1 = find(abs(x) <= irad);
temp_F2 = find(abs(x) <= irad);

n_P(1,temp_P) = idens(1)*normpdf(x(temp_P),0,1); %Computes pdf values evaluated at the values in x i.e. all x(temp) values for the normal distribution with mean 0 and standard deviation 1.
n_F1(1,temp_F1) = idens(2)*normpdf(x(temp_F1),0,1);
n_F2(1,temp_F2) = idens(3)*normpdf(x(temp_F2),0,1);

% FIND THE INITIAL FRONT LOCATION
jj_P = find(n_P(1,:) >= ncrit,1,'last'); %find the farthest distance travelled by the population above a certain threshold density and assign it to jj
jj_F1 = find(n_F1(1,:) >= ncrit,1,'last');
jj_F2 = find(n_F2(1,:) >= ncrit,1,'last');

if jj_P %the initial front is obtained from initialization which will be in the first row of 'n'
  xright_P(1) = interp1(n_P(1,jj_P:jj_P+1),x(jj_P:jj_P+1),ncrit);
end
if jj_F1
  xright_F1(1) = interp1(n_F1(1,jj_F1:jj_F1+1),x(jj_F1:jj_F1+1),ncrit);
end

if jj_F2
  xright_F2(1) = interp1(n_F2(1,jj_F2:jj_F2+1),x(jj_F2:jj_F2+1),ncrit);
end

generation = 1;
%% Looping for growth and dispersal
while generation < iterations

    tspan = [0, 10];

    %Growth
    y0 = [n_P(generation,:);n_F1(generation,:);n_F2(generation,:)];

    % reshape happens such that 3 consecutive rows for n_P, n_F1, and n_F2 values are stacked
    y0 = reshape(y0, 3*length(y0), 1);

    [t,y] = ode45(@(t,y) growthODEs(t,y), tspan, y0); %remember to alter where the dep_p and dep_f are being called from


    % We just want the results of the growth phase (end)
    f_P = y(end,(1:3:end)); % final row; element 1, +3, elem. 4, etc. until end
    f_F1 = y(end,(2:3:end));
    f_F2 = y(end,(3:3:end));

%   DISPERSAL
    n1_P = fft_conv(k_P,f_P);   % dispersing individuals
    n1_F1 = fft_conv(k_F1,f_F1);
    n1_F2 = fft_conv(k_F2,f_F2);

    n_P(generation + 1,:) = dx*n1_P(nodes:length(x2)); %the convolution apparently doubles the length of the array?
    n_F1(generation + 1,:) = dx*n1_F1(nodes:length(x2));
    n_F2(generation + 1,:) = dx*n1_F2(nodes:length(x2));

    n_P(generation + 1,1) = n_P(generation + 1,1)/2; n_P(generation + 1,nodes) = n_P(generation + 1,nodes)/2; %The population density at the edges is halved
    n_F1(generation + 1,1) = n_F1(generation + 1,1)/2; n_F1(generation + 1,nodes) = n_F1(generation + 1,nodes)/2;
    n_F2(generation + 1,1) = n_F2(generation + 1,1)/2; n_F2(generation + 1,nodes) = n_F2(generation + 1,nodes)/2;

    temp_P = find(n_P(generation + 1,:) < lowval); %gives location of random places where numbers are above zero due to some numerical errors
    temp_F1 = find(n_F1(generation + 1,:) < lowval);
    temp_F2 = find(n_F2(generation + 1,:) < lowval);

    n_P(generation + 1,temp_P) = zeros(size(n_P(generation + 1,temp_P))); %set the places with those numerical errors to zero
    n_F1(generation + 1,temp_F1) = zeros(size(n_F1(generation + 1,temp_F1)));%delete this for STE
    n_F2(generation + 1,temp_F2) = zeros(size(n_F2(generation + 1,temp_F2)));%delete this for STE

    jj_P = find(n_P(generation + 1,:) >= ncrit,1,'last');
    jj_F1 = find(n_F1(generation + 1,:) >= ncrit,1,'last');
    jj_F2 = find(n_F2(generation + 1,:) >= ncrit,1,'last');

    if jj_P
         xright_P(generation + 1) = interp1(n_P(generation + 1,jj_P:jj_P + 1),x(jj_P:jj_P + 1),ncrit);
    end

    if jj_F1
         xright_F1(generation + 1) = interp1(n_F1(generation + 1,jj_F1:jj_F1 + 1),x(jj_F1:jj_F1 + 1),ncrit);
    end

    if jj_F2
         xright_F2(generation + 1) = interp1(n_F2(generation + 1,jj_F2:jj_F2 + 1),x(jj_F2:jj_F2 + 1),ncrit);
    end

    speed_av_P(generation) = (xright_P(generation + 1) - xright_P(1)) / generation; %latest position of wave edge - initial position of wave edge divided by time
    speed_inst_P(generation) = xright_P(generation + 1) - xright_P(generation);

    speed_inst_F1(generation) = xright_F1(generation + 1) - xright_F1(generation);
    speed_av_F1(generation) = (xright_F1(generation + 1) - xright_F1(1)) / generation; %latest position of wave edge - initial position of wave edge divided by time

    speed_inst_F2(generation) = xright_F2(generation + 1) - xright_F2(generation);
    speed_av_F2(generation) = (xright_F2(generation + 1) - xright_F2(1)) / generation; %latest position of wave edge - initial position of wave edge divided by time

    % increment the while loop current iteration
    generation = generation + 1;

    %save(strcat(['mandm_yescost_depP=' num2str(dep_p) '_depF=' num2str(dep_f) '.mat']))
    %save mandm_nocost_yesdep.mat
% while loop end
end

%% Save a mat file with the current parameter values
%save(strcat(['~/sweep2/mat_files/comp_pheno_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.mat']));
filename = ''

save(strcat(['~/sweep2/mat_files/comp_pheno_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.mat']));

% end of simMutualism function
end
