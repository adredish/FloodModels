%% TestAgent Weights
clf
nTS = [1 50 100 250 500 1000];
for iTS = 1:length(nTS)
    A = Agent('nTimeSteps', nTS(iTS));
    A.runTimeline();
    
    histogram(A.wHA); drawnow;
    hold on;
end
legend(arrayfun(@num2str, nTS, 'UniformOutput', false));
