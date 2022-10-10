function fig2use = Show3(R, c, varargin)

fig2use = [];
floodLineColor = 'r';
linesColor = 'm';
process_varargin(varargin);

if isempty(fig2use), fig2use = figure; else figure(fig2use); end

sq = @squeeze;
if size(R.events.events,1) == 1, R.events.events = R.events.events'; end

subplot(311); 
z = R.AssetCost; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c); ylabel('Asset Cost');
ylim([-0.2 1]); xlabel(sprintf('Time (flood @ %d)', R.events.flood));
xlim([1 length(R.AssetCost)]);
hold on
lines(R.events.flood, floodLineColor);
lines(cellfun(@(x)x(1), R.events.events), linesColor);

subplot(312); 
z = R.Rememory; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c); ylabel('Memory correlation');
ylim([-0.2 1]); xlabel(sprintf('Time (flood @ %d)', R.events.flood));
xlim([1 length(R.Rememory)]);
hold on
lines(R.events.flood, floodLineColor);
lines(cellfun(@(x)x(1), R.events.events), linesColor);

subplot(313); 
z = R.RememberedCost; ShadedErrorbar(1:1000, nanmean(sq(z)), nanstderr(sq(z)), 'color', c); ylabel('Remembered Cost');
ylim([-0.2 1]); xlabel(sprintf('Time (flood @ %d)', R.events.flood));
xlim([1 length(R.RememberedCost)]);
hold on
lines(R.events.flood, floodLineColor);
lines(cellfun(@(x)x(1), R.events.events), linesColor);

FigureLayout('layout', [0.5 1]); 

    function lines(TS, c)
        if ~isempty(c)
            line(xlim, [0 0], 'color', 'k', 'LineStyle', ':');
            for iT = 1:length(TS)
                line([1 1] * TS(iT), ylim, 'color', c);
            end
        end
    end

end