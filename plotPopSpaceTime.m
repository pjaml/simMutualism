function plotPopSpaceTime(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile', @isfile);
    addOptional(p,'createFile', false, @islogical);
    addOptional(p, 'imgDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    load(simMatFile, 'filename', 'iterations', 'nP', 'nF1', 'nF2', 'nThreshold', 'x');

    %% Figure for species P
    figure(1);
    clf
    [xx,tt] = meshgrid(x,0:iterations);
    nlow = nP;
    nlow(nP >= nThreshold) = NaN;
    nP(nP < nThreshold) = NaN;
    hold on
    for i = 1:5:60
        plot3(xx(i,:),tt(i,:),nP(i,:),'b', 'LineWidth', 3.0);
        plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
        grid on
    end
    % plot3(rangeEdgeP(1:11),0:10,nThreshold*ones(1,11),'k');
    axis([-120 120 0 iterations 0 6.25]);
    xlabel('space (x)');
    ylabel('time (t)');
    zlabel('density');
    % title('Species P');
    view(30,30);

    %% Figure for species F1
    [xx,tt] = meshgrid(x,0:iterations);
    nlow = nF1;
    nlow(nF1>=nThreshold) = NaN;
    nF1(nF1<nThreshold) = NaN;
    hold on
    for i = 1:5:60
        plot3(xx(i,:),tt(i,:),nF1(i,:),'r','LineWidth', 3.0);
        plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
        grid on
    end

    % plot3(rangeEdgeF1(1:11),0:10,nThreshold*ones(1,11),'k');
    % axis([-15 15 0 10 0 5]);
    % xlabel('space (x)');
    % ylabel('time (t)');
    % zlabel('species F1 density (nF1)');
    % view(30,30);
    % title('Species F1');

    %% Figure for species F2
    [xx,tt] = meshgrid(x,0:iterations);
    nlow = nF2;
    nlow(nF2>=nThreshold) = NaN;
    nF2(nF2<nThreshold) = NaN;
    hold on
    for i = 1:5:60
        plot3(xx(i,:),tt(i,:),nF2(i,:),'g', 'LineWidth', 3.0);
        plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
        grid on
    end

    % plot3(rangeEdgeF2(1:11),0:100,nThreshold*ones(1,11),'k');
    % axis([-15 15 0 10 0 5]);
    % xlabel('space (x)');
    % ylabel('time (t)');
    % zlabel('species F2 density (nF2)');
    % view(30,30);
    % title('Species F2');
    hold off

    if p.Results.createFile
        filename = strcat('pop_space_time_', filename, '.fig');
        savefig(strcat(imgDir, filename));
    end

end
