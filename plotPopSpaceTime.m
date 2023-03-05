function plotPopSpaceTime(simMatFile)

    load(simMatFile);

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

end
