function se = nanstderr(x,dim)

% se = stderr(x)
%
% given that x is an nCol x nRow, returns an nCol x 1 matrix
% however, if x is 1 x nR, returns nR x 1 matrix
% 
% removes nans 
% 
% ADR

% May 2022 GWD corrected to be sum(f) not length(f) as f is a logical of
% non-nan entries

if size(x,1) == 1
	x = x';
end

nC = size(x,2);

se = nan(nC, 1);
for iC = 1:nC
	f = ~isnan(x(:,iC));
	if ~isempty(f)
%%% 		se(iC) = std(x(f,iC))/sqrt(length(f));
		se(iC) = std(x(f,iC))/sqrt(sum(f));
	end
end