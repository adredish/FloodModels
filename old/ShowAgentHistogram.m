function ShowAgentHistogram(parm, R, ~, floodTS, reminders)
figure;
for iR = 1:length(R)
    subplot(2,2,iR);
    X = squeeze(R{iR}.(parm));
    [~,order] = sort(sum(X,2), 'descend');
    imagesc(X(order,:));
    caxis([0 1]);
    colorbar
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