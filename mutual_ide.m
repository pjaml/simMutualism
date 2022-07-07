clc
%% original function parameters

iterations = 30;
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
dep_f = [0.5 0.9];
comp_12 = 0.4;
comp_21 = 2.3;

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

irad = 2;       % Intial condition range%irad_F = 2;% irad_F = diameter if you want to study STE (semi trivial equlibria);
                %irad_F = 2;
idens = [0.1,0.1];
ncrit = 0.05;   % critical threshold for edge of wave
sigma_sq = 0.25;            % Dispersal variance
k_P = exp(-(x2.^2)/(2*sigma_sq))./sqrt(2*pi*sigma_sq); % this line and the next describes a gaussian dispersal kernel
k_F = exp(-(x2.^2)/(2*sigma_sq))./sqrt(2*pi*sigma_sq); %make k_F = 0 for STE to prevent dispersal of individuals which are already in the entire space (F is arbit. -- could be P as well)

% k_P = exp(-sqrt(2*(x2.^2)/(sigma_sq)))./sqrt(2*sigma_sq); %this line and the next describe a laplacian dispersal kernel
% k_F = exp(-sqrt(2*(x2.^2)/(sigma_sq)))./sqrt(2*sigma_sq);

% SET THE INITIAL CONDITIONS
temp_P = find(abs(x) <= irad); %locate all values in the array x that lie b/w +irad and -irad units of space
temp_F1 = find(abs(x) <= irad); %irad_F for STE
temp_F2 = find(abs(x) <= irad); %irad_F for STE

n_P(1,temp_P) = idens(1)*normpdf(x(temp_P),0,1); %Computes pdf values evaluated at the values in x i.e. all x(temp) values for the normal distribution with mean 0 and standard deviation 1.
n_F1(1,temp_F1) = idens(2)*normpdf(x(temp_F1),0,1); %Would be just idens(2) for STE
n_F2(1,temp_F2) = idens(2)*normpdf(x(temp_F2),0,1); %Would be just idens(2) for STE
%2 Lines below are for studying spatial spread with census after growth
% f_P_all(1,temp_P) = idens(1)*normpdf(x(temp_P),0,1); %Computes pdf values evaluated at the values in x i.e. all x(temp) values for the normal distribution with mean 0 and standard deviation 1.
% f_F_all(1,temp_F) = idens(2)*normpdf(x(temp_F),0,1);

% FIND THE INITIAL FRONT LOCATION
jj_P = find(n_P(1,:) >= ncrit,1,'last'); %find the farthest distance travelled by the population above a certain threshold density and assign it to jj
jj_F1 = find(n_F1(1,:) >= ncrit,1,'last'); %remove all jj_F mentions if you want to calculate speeds of semi trivial equilibria
jj_F2 = find(n_F2(1,:) >= ncrit,1,'last');

%2 Lines below are for studying spatial spread with census after growth
% f_jj_P = find(f_P_all(1,:) >= ncrit,1,'last'); %find the farthest distance travelled by the population above a certain threshold density and assign it to jj
% f_jj_F = find(f_F_all(1,:) >= ncrit,1,'last');

if jj_P %the initial front is obtained from initialization which will be in the first row of 'n'
  xright_P(1) = interp1(n_P(1,jj_P:jj_P+1),x(jj_P:jj_P+1),ncrit);
end
if jj_F1
  xright_F1(1) = interp1(n_F1(1,jj_F1:jj_F1+1),x(jj_F1:jj_F1+1),ncrit);
end

if jj_F2
  xright_F2(1) = interp1(n_F2(1,jj_F2:jj_F2+1),x(jj_F2:jj_F2+1),ncrit);
end
%6 Lines below are for studying spatial spread with census after growth
% if f_jj_P %the initial front is obtained from initialization which will be in the first row of 'n'
%   xright_P(1) = interp1(f_P_all(1,f_jj_P:f_jj_P+1),x(f_jj_P:f_jj_P+1),ncrit);
% end
% if f_jj_F
%   xright_F(1) = interp1(f_F_all(1,f_jj_F:f_jj_F+1),x(f_jj_F:f_jj_F+1),ncrit);
% end

%% Looping for growth and dispersal
for i = 1:iterations
    %Growth
    y0 = [n_P(i,:);n_F1(i,:);n_F2(i,:)];
    y0 = reshape(y0, 3*length(y0), 1); % reshape happens such that pairs of n_P and n_F values are located in adjacent rows to each other
    [t,y] = ode45(@(t,y) odephenotypes(t,y,r_p,r_f,alpha_pf,alpha_fp,q1,q2,beta1,beta2,c1,c2,d_p,d_f,h1,h2,e1,e2,nodes,dep_p,dep_f, comp_12, comp_21), tspan, y0); %remember to alter where the dep_p and dep_f are being called from
    f_P = y(end,(1:3:end));
    f_F1 = y(end,(2:3:end));
    f_F2 = y(end,(3:3:end));
%6 Lines below are for studying spatial spread with census after growth
%     f_P_all(i+1,:) = f_P;
%     f_F_all(i+1,:) = f_F;
%     temp_P = find(f_P_all(i+1,:) < lowval); %gives location of random places where numbers are above zero due to some numerical errors
%     temp_F = find(f_F_all(i+1,:) < lowval);
%     f_P_all(i+1,temp_P) = zeros(size(f_P_all(i+1,temp_P))); %set the places with those numerical errors to zero
%     f_F_all(i+1,temp_F) = zeros(size(f_F_all(i+1,temp_F)));
%

%   DISPERSAL
    n1_P = fft_conv(k_P,f_P);   % dispersing individuals
    n1_F1 = fft_conv(k_F,f_F1);
    n1_F2 = fft_conv(k_F,f_F2);

    n_P(i+1,:) = dx*n1_P(nodes:length(x2)); %the convolution apparently doubles the length of the array?
    n_F1(i+1,:) = dx*n1_F1(nodes:length(x2)); %MAKE n_F(i+1, :) = r_f/d_f if you want to look at cases of semi-trivial equilibrium;
    n_F2(i+1,:) = dx*n1_F2(nodes:length(x2)); %MAKE n_F(i+1, :) = r_f/d_f if you want to look at cases of semi-trivial equilibrium;

    n_P(i+1,1) = n_P(i+1,1)/2; n_P(i+1,nodes) = n_P(i+1,nodes)/2; %The population density at the edges is halved
    n_F1(i+1,1) = n_F1(i+1,1)/2; n_F1(i+1,nodes) = n_F1(i+1,nodes)/2;
    n_F2(i+1,1) = n_F2(i+1,1)/2; n_F2(i+1,nodes) = n_F2(i+1,nodes)/2;

    temp_P = find(n_P(i+1,:) < lowval); %gives location of random places where numbers are above zero due to some numerical errors
    temp_F1 = find(n_F1(i+1,:) < lowval);%delete this for STE
    temp_F2 = find(n_F2(i+1,:) < lowval);%delete this for STE

    n_P(i+1,temp_P) = zeros(size(n_P(i+1,temp_P))); %set the places with those numerical errors to zero
    n_F1(i+1,temp_F1) = zeros(size(n_F1(i+1,temp_F1)));%delete this for STE
    n_F2(i+1,temp_F2) = zeros(size(n_F2(i+1,temp_F2)));%delete this for STE

    jj_P = find(n_P(i+1,:) >= ncrit,1,'last');
    jj_F1 = find(n_F1(i+1,:) >= ncrit,1,'last');
    jj_F2 = find(n_F2(i+1,:) >= ncrit,1,'last');

%     %2 Lines below are for studying spatial spread with census after growth
%     f_jj_P = find(f_P_all(i+1,:) >= ncrit,1,'last');
%     f_jj_F = find(f_F_all(i+1,:) >= ncrit,1,'last');

    if jj_P
         xright_P(i+1) = interp1(n_P(i+1,jj_P:jj_P+1),x(jj_P:jj_P+1),ncrit);
    end

    if jj_F1
         xright_F1(i+1) = interp1(n_F1(i+1,jj_F1:jj_F1+1),x(jj_F1:jj_F1+1),ncrit);
    end

    if jj_F2
         xright_F2(i+1) = interp1(n_F2(i+1,jj_F2:jj_F2+1),x(jj_F2:jj_F2+1),ncrit);
    end

%6 Lines below are for studying spatial spread with census after growth
%     if f_jj_P
%          xright_P(i+1) = interp1(f_P_all(i+1,f_jj_P:f_jj_P+1),x(f_jj_P:f_jj_P+1),ncrit);
%     end
%
%     if f_jj_F
%          xright_F(i+1) = interp1(f_F_all(i+1,f_jj_F:f_jj_F+1),x(f_jj_F:f_jj_F+1),ncrit);
%     end
%

    speed_av_P(i) = (xright_P(i+1)-xright_P(1))/i; %latest position of wave edge - initial position of wave edge divided by time
    speed_inst_P(i) = xright_P(i+1)-xright_P(i);



    speed_inst_F1(i) = xright_F1(i+1)-xright_F1(i);
    speed_av_F1(i) = (xright_F1(i+1)-xright_F1(1))/i; %latest position of wave edge - initial position of wave edge divided by time

    speed_inst_F2(i) = xright_F2(i+1)-xright_F2(i);
    speed_av_F2(i) = (xright_F2(i+1)-xright_F2(1))/i; %latest position of wave edge - initial position of wave edge divided by time

    %save(strcat(['mandm_yescost_depP=' num2str(dep_p) '_depF=' num2str(dep_f) '.mat']))
    %save mandm_nocost_yesdep.mat

end

save(strcat(['comp_pheno_model/comp_pheno_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12) '_comp_21=' num2str(comp_21) '.mat']));

clf
hold on
plot(n_P(end,:));
plot(n_F1(end,:));
plot(n_F2(end,:));
legend('P', 'F1', 'F2');
hold off

savefig(strcat(['comp_pheno_model/comp_pheno_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12) '_comp_21=' num2str(comp_21) '.fig']));


saveas(gcf, strcat(['comp_pheno_model/comp_pheno_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12) '_comp_21=' num2str(comp_21) '.png']));
