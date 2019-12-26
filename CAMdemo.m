%% CAM model demo

[x,y] = ndgrid(-100:100, -100:100);

x0 = [20,-50,50,-70,-75]; 
y0 = [50,75,-50,-50,0]; 
sigma = [10,20,20,10,30];
A = [2,1,4,1,3];
nC = length(x0);

z = 0.001 * randn(size(x));
surf(x,y,-z)
shading flat
axis off
view(3);
zlim([-0.1 0.05]);
caxis([-0.1 0]);
pause;

for iC = 1:nC
    exponent = ((x-x0(iC)).^2 + (y-y0(iC)).^2)./(2*sigma(iC)^2);
    amplitude = A(iC) / (sigma(iC) * sqrt(2*pi));
    z = z + amplitude  * exp(-exponent);

surf(x,y,-z)
shading flat
axis off
view(3);
zlim([-0.1 0.05]);
caxis([-0.1 0]);
pause;
end