function ShowGraphLabels(R, h)

nLines = length(R.lines);
xTK = []; xTKL = {};
for iL = 1:nLines
    if ~isempty(R.lines(iL).Color)
        line(R.lines(iL).TS*[1 1], ylim, 'color', R.lines(iL).Color, 'LineStyle', '--', 'LineWidth', 0.1);
        xTK(end+1) = R.lines(iL).TS;
        if isfield(R.lines(iL), 'Name')
            xTKL{end+1} = R.lines(iL).Name;
        else
            xTKL{end+1} = 'Event';
        end
    end
end

yL = ylim;
ylim([yL(1) 0.1]);
line(xlim, [0 0], 'LineStyle', ':', 'Color', 'k');
set(gca, 'XTick', xTK, 'XTickLabel', xTKL, 'YTick', 0, 'FontSize', 16);

ylabel('\leftarrow Asset cost decrease (arbitrary units)');
if ~isempty(R.cases)
    legend(h, num2str(R.cases'))
end
title(R.title);
xlabel('Time (arbitrary units) \rightarrow', 'interpreter', 'TeX');

end