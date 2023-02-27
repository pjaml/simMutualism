clearvars
clc
%% original function parameters

iterations = 60;
tspan = [0, 10];
r_p = 0.3;
r_f = [0.30 0.30];
alpha_pf = [0.5 0.5];
alpha_fp = [0.5 0.5];
q1 = 1.0;
q2 = 1.0;
beta1 = 0.0;
beta2 = [0.0 0.0];
c1 = 1.0;
c2 = 1.0;
d_p = 0.1;
d_f = [0.1 0.1];
h1 = [0.3 0.3];
h2 = [0.3 0.3];
e1 = 0.3;
e2 = [0.3 0.3];
dep_p = 0.0;
dep_f = [0.9 0.1];
comp_12 = 0.0;
comp_21 = 0.0;

% format spec for floating point values in filenames
fspec = '%.2f';

%% Initialize parameters
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

%% Looping for growth and dispersal
for i = 1:iterations
    %Growth
    y0 = [n_P(i,:);n_F1(i,:);n_F2(i,:)];
    y0 = reshape(y0, 3*length(y0), 1); % reshape happens such that 3 consecutive rows for n_P, n_F1, and n_F2 values are stacked
    [t,y] = ode45(@(t,y) odephenotypes(t,y,r_p,r_f,alpha_pf,alpha_fp,q1,q2,beta1,beta2,c1,c2,d_p,d_f,h1,h2,e1,e2,nodes,dep_p,dep_f, comp_12, comp_21), tspan, y0); %remember to alter where the dep_p and dep_f are being called from

    % We just want the results of the growth phase (end)
    f_P = y(end,(1:3:end)); % final row; element 1, +3, elem. 4, etc. until end
    f_F1 = y(end,(2:3:end));
    f_F2 = y(end,(3:3:end));

%   DISPERSAL
    n1_P = fft_conv(k_P,f_P);   % dispersing individuals
    n1_F1 = fft_conv(k_F1,f_F1);
    n1_F2 = fft_conv(k_F2,f_F2);

    n_P(i+1,:) = dx*n1_P(nodes:length(x2)); %the convolution apparently doubles the length of the array?
    n_F1(i+1,:) = dx*n1_F1(nodes:length(x2));
    n_F2(i+1,:) = dx*n1_F2(nodes:length(x2));

    n_P(i+1,1) = n_P(i+1,1)/2; n_P(i+1,nodes) = n_P(i+1,nodes)/2; %The population density at the edges is halved
    n_F1(i+1,1) = n_F1(i+1,1)/2; n_F1(i+1,nodes) = n_F1(i+1,nodes)/2;
    n_F2(i+1,1) = n_F2(i+1,1)/2; n_F2(i+1,nodes) = n_F2(i+1,nodes)/2;

    temp_P = find(n_P(i+1,:) < lowval); %gives location of random places where numbers are above zero due to some numerical errors
    temp_F1 = find(n_F1(i+1,:) < lowval);
    temp_F2 = find(n_F2(i+1,:) < lowval);

    n_P(i+1,temp_P) = zeros(size(n_P(i+1,temp_P))); %set the places with those numerical errors to zero
    n_F1(i+1,temp_F1) = zeros(size(n_F1(i+1,temp_F1)));%delete this for STE
    n_F2(i+1,temp_F2) = zeros(size(n_F2(i+1,temp_F2)));%delete this for STE

    jj_P = find(n_P(i+1,:) >= ncrit,1,'last');
    jj_F1 = find(n_F1(i+1,:) >= ncrit,1,'last');
    jj_F2 = find(n_F2(i+1,:) >= ncrit,1,'last');

    if jj_P
         xright_P(i+1) = interp1(n_P(i+1,jj_P:jj_P+1),x(jj_P:jj_P+1),ncrit);
    end

    if jj_F1
         xright_F1(i+1) = interp1(n_F1(i+1,jj_F1:jj_F1+1),x(jj_F1:jj_F1+1),ncrit);
    end

    if jj_F2
         xright_F2(i+1) = interp1(n_F2(i+1,jj_F2:jj_F2+1),x(jj_F2:jj_F2+1),ncrit);
    end

    speed_av_P(i) = (xright_P(i+1)-xright_P(1))/i; %latest position of wave edge - initial position of wave edge divided by time
    speed_inst_P(i) = xright_P(i+1)-xright_P(i);

    speed_inst_F1(i) = xright_F1(i+1)-xright_F1(i);
    speed_av_F1(i) = (xright_F1(i+1)-xright_F1(1))/i; %latest position of wave edge - initial position of wave edge divided by time

    speed_inst_F2(i) = xright_F2(i+1)-xright_F2(i);
    speed_av_F2(i) = (xright_F2(i+1)-xright_F2(1))/i; %latest position of wave edge - initial position of wave edge divided by time

    %save(strcat(['mandm_yescost_depP=' num2str(dep_p) '_depF=' num2str(dep_f) '.mat']))
    %save mandm_nocost_yesdep.mat

    %% Adds further iterations if steady states are not reached
    if (i == iterations)
        tol = 1e-04;
        if ~(abs(speed_inst_P(i) - speed_inst_P(i-1)) < tol) || ~(abs(speed_inst_F1(i) - speed_inst_F1(i-1)) < tol) || ~(abs(speed_inst_F2(i) - speed_inst_F2(i-1)) < tol)

            if iterations > 400
                iterations = 500;
            else
                iterations = iterations + 20;
            end

            % extend the sizes of the relevant vectors & matrices
            [speed_inst_P(length(speed_inst_P)+1:iterations), speed_av_P(length(speed_av_P)+1:iterations), speed_inst_F1(length(speed_inst_F1)+1:iterations), speed_av_F1(length(speed_av_F1)+1:iterations), speed_inst_F2(length(speed_inst_F2)+1:iterations), speed_av_F2(length(speed_av_F2)+1:iterations)] = deal(0);
            [xright_P(length(xright_P)+1:iterations+1),xright_F1(length(xright_F1)+1:iterations+1), xright_F2(length(xright_F2)+1:iterations+1)] = deal(0);

            [n_P(height(n_P)+1:iterations+1,:), n_F1(height(n_F1)+1:iterations+1,:), n_F2(height(n_F2)+1:iterations+1,:)] = deal(zeros((iterations+1)-height(n_P), length(n_P)));
        else
            break
        end
    end


end

%% Save a mat file with the current parameter values
save(strcat(['~/sweep2/mat_files/comp_pheno_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.mat']));

%% Figure for species P
figure(1);
clf
[xx,tt] = meshgrid(x,0:iterations);
nlow = n_P;
nlow(n_P>=ncrit) = NaN;
n_P(n_P<ncrit) = NaN;
hold on
for i = 1:5:60
     plot3(xx(i,:),tt(i,:),n_P(i,:),'b', 'LineWidth', 3.0);
     plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
     grid on
end
% plot3(xright_P(1:11),0:10,ncrit*ones(1,11),'k');
    axis([-120 120 0 iterations 0 6.25]);
    xlabel('space (x)');
    ylabel('time (t)');
    zlabel('density');
    % title('Species P');
    view(30,30);

%% Figure for species F1
[xx,tt] = meshgrid(x,0:iterations);
nlow = n_F1;
nlow(n_F1>=ncrit) = NaN;
n_F1(n_F1<ncrit) = NaN;
hold on
for i = 1:5:60
     plot3(xx(i,:),tt(i,:),n_F1(i,:),'r','LineWidth', 3.0);
     plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
     grid on
end

% plot3(xright_F1(1:11),0:10,ncrit*ones(1,11),'k');
    % axis([-15 15 0 10 0 5]);
    % xlabel('space (x)');
    % ylabel('time (t)');
    % zlabel('species F1 density (n_F1)');
    % view(30,30);
    % title('Species F1');

%% Figure for species F2
[xx,tt] = meshgrid(x,0:iterations);
nlow = n_F2;
nlow(n_F2>=ncrit) = NaN;
n_F2(n_F2<ncrit) = NaN;
hold on
for i = 1:5:60
     plot3(xx(i,:),tt(i,:),n_F2(i,:),'g', 'LineWidth', 3.0);
     plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
     grid on
end

% plot3(xright_F2(1:11),0:100,ncrit*ones(1,11),'k');
    % axis([-15 15 0 10 0 5]);
    % xlabel('space (x)');
    % ylabel('time (t)');
    % zlabel('species F2 density (n_F2)');
    % view(30,30);
    % title('Species F2');
hold off

clf
plot(1:iterations, speed_inst_P, 1:iterations, speed_inst_F1, 1:iterations, speed_inst_F2);
legend('P', 'F1', 'F2');
title(strcat(['Spread speed vs. time (tau21=' num2str(comp_21) ', tau12=' num2str(comp_12) ')']));
xlabel('iterations');
ylabel('speed');

savefig(strcat(['comp_pheno_model/speed_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.fig']));

clf
hold on
plot(n_P(end,:));
plot(n_F1(end,:));
plot(n_F2(end,:));
legend('P', 'F1', 'F2');
title(strcat(['N vs. x (tau21=' num2str(comp_21) ', tau12=' num2str(comp_12) ')']));
hold off

savefig(strcat(['comp_pheno_model/N_v_x_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.fig']));

% Save a PNG file
% saveas(gcf, strcat(['comp_pheno_model/comp_pheno_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.png']));

for i = 1:iterations+1

    rangeP(i) = length(find(n_P(i,:) >= ncrit));
    rangeF1(i) = length(find(n_F1(i,:) >= ncrit));
    rangeF2(i) = length(find(n_F2(i,:) >= ncrit));
end

clf
plot(1:iterations+1, [rangeP; rangeF1; rangeF2]);
xlabel('iterations');
ylabel('range size');
title(strcat(['Range size vs. time (tau21=' num2str(comp_21) ', tau12=' num2str(comp_12) ')']));
legend('P', 'F1', 'F2');

savefig(strcat(['comp_pheno_model/range_size_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.fig']));
