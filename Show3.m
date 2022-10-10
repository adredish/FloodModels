function fig2use = Show3(R, c, varargin)

fig2use = [];
separate_figures = false;
floodLineColor = 'r';
linesColor = 'm';
process_varargin(varargin);

if isempty(fig2use) && ~separate_figures, fig2use = figure; end

sq = @squeeze;
if size(R.events.events,1) == 1, R.events.events = R.events.events'; end

if separate_figures, figure; else subplot(311); end
z = R.AssetCost; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c); ylabel('Asset Cost');
ylim([-0.2 1]); xlabel(sprintf('Time (flood @ %d)', R.events.flood));
lines([R.events.flood; cellfun(@(x)x(1), R.events.events)], [floodLineColor; repmat(linesColor, size(R.events.events))]);
if separate_figures, FigureLayout(); end

if separate_figures, figure; else subplot(312); end
z = R.Rememory; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c); ylabel('Memory correlation');
ylim([-0.2 1]); xlabel(sprintf('Time (flood @ %d)', R.events.flood));
lines([R.events.flood; cellfun(@(x)x(1), R.events.events)], [floodLineColor; repmat(linesColor, size(R.events.events))]);
if separate_figures, FigureLayout; end

if separate_figures, figure; else subplot(313); end
z = R.RememberedCost; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c); ylabel('Remembered Cost');
ylim([-0.2 1]); xlabel(sprintf('Time (flood @ %d)', R.events.flood));
lines([R.events.flood; cellfun(@(x)x(1), R.events.events)], [floodLineColor; repmat(linesColor, size(R.events.events))]);
if separate_figures, FigureLayout; end

if ~separate_figures, FigureLayout('layout', [0.5 1]); end

    function lines(TS, c)
        if nargin == 1, c = repmat('r', size(TS)); end
        ax = findobj(gcf, 'Type', 'axes');
        for iA = 1:length(ax)
            axes(ax(iA));
            line(xlim, [0 0], 'color', c(1));
            for iT = 1:length(TS)
                line([1 1] * TS(iT), ylim, 'color', c(iT));
            end
        end
    end

end