function [halfDrop,percentDropAtEnd] = FindHalfDrop(ACR)

[nS, nA, nT] = size(ACR.ACR);

halfDrop = nan(nS,1);
percentDropAtEnd = nan(nS,1);
for iS = 1:nS
    xA = 1:nT;
    mA = nanmean(squeeze(ACR.ACR(iS,:,:)));
    [maxA,t0] = max(mA);
    f = find((xA > t0) & (mA<(0.5*maxA)) , 1, 'first');
    if ~isempty(f)
        halfDrop(iS) = f;
    end
    percentDropAtEnd(iS) = mA(end)/maxA;
end

figure;
subplot(2,1,1);
plot(ACR.cases, halfDrop, '*');
ylabel('time to 50% recovery');
xlabel(ACR.title);
subplot(2,1,2);
plot(ACR.cases, percentDropAtEnd, '*');
ylabel('% drop by end of time');
xlabel(ACR.title);