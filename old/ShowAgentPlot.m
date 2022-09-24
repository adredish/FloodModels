function ShowAgentPlot(parm, R, ~, floodTS, reminders)
figure;
for iR = 1:length(R)
    subplot(2,2,iR);
    X = squeeze(R{iR}.(parm));
    plot(1:size(X,2), X', '-', 'color', [1 0 0 0.1]);
    title(parm)
    
    line(floodTS * [1 1], ylim, 'color','r', 'LineWidth',2);
    for iL = 1:3
        if iL > iR-1
            line(reminders(iL) * [1 1], ylim, 'color','w', 'LineStyle', ':', 'LineWidth', 2);
        else
            line(reminders(iL) * [1 1], ylim, 'color','m', 'LineWidth', 2);
        end
    end
end
end
