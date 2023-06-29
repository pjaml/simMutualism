function createTiledPlots(file1, file2, file3, file4)

    p1 = openfig(file1);
    p2 = openfig(file2);
    p3 = openfig(file3);
    p4 = openfig(file4);

    t1 = gca(p1);
    t2 = gca(p2);
    t3 = gca(p3);
    t4 = gca(p4);

    f = figure;
    f.Position = [1 1 1000 1000];
    hold on
    tiled = tiledlayout(2,2, "TileSpacing", "Compact", "Padding", "Compact");

    t1.Parent=tiled;
    t1.Title.String="(A)";
    t1.Layout.Tile=1;
    t2.Parent=tiled;
    t2.Title.String="(B)";
    t2.Layout.Tile=2;
    t3.Parent=tiled;
    t3.Title.String="(C)";
    t3.Layout.Tile=3;
    t4.Parent=tiled;
    t4.Title.String="(D)";
    t4.Layout.Tile=4;

    hold off

    filename = fullfile('./', 'tiled')
    saveas(f, strcat(filename, '.fig'));
    saveas(f, strcat(filename, '.png'));

end
