%% Frecuencias Espaciales

waveLength = [50,25,10,5,2.5,1.9,1.05,1.01,1];

figure
a = tiledlayout(3,7,'TileSpacing','Compact','Padding','Compact');

FOV = 501; % mm
longituddeOnda = waveLength(9); %mm
fase = 0.2;
spatialfrequency = 1.0 / longituddeOnda; % Ciclos por mm
maxfrquency = 0.5 / FOV;
sinesampling = linspace(-(FOV - 1) / 2,(FOV - 1) / 2,FOV); %% 1 mm sampling
nsamples = size(sinesampling);
yline = ones(nsamples);
sineline = sin(2 * pi * (spatialfrequency * sinesampling + fase));
nexttile
plot(sinesampling,sineline);
title("Figura 1")

nexttile
xsineimage = conv2(sineline,yline');
imshow(xsineimage,[]);
title("Figura 2")

nexttile
ysineimage = conv2(yline,sineline');
imshow(ysineimage,[]);
title("Figura 3")

% Tranformadas de Fourier
SINELINE = fft(sineline);
nexttile
freq = linspace(-1000 * maxfrquency / 2,1000 * maxfrquency / 2,FOV);
plot(freq,abs(SINELINE))
title("Figura 4")

nexttile
plot(freq,fftshift(abs(SINELINE)))
title("Figura 5")

nexttile
imshow(fftshift(fft2(xsineimage)),[])
title("Figura 6")

nexttile
imshow(fftshift(fft2(ysineimage)),[])
title("Figura 7")

% Resampling, 2022

% Open Image
f=imread("x-rayjumbo.jpg");
f=double(f(:,:,1));
f=f/max(max(f));
nexttile
imshow(f)
title("Figura 8 - X-Ray")

% Sampling
small = imresize(f,0.1,"nearest");
nexttile
imshow(small)
title("Figura 9 - Small")

% Fourier transform
F=fft2(f);
nexttile
imshow(abs(F),[])
title("Figura 10")

nexttile
imshow(log(abs(F)),[])
%imshow((abs(F)),[])
title("Figura 11")

nexttile
imshow(fftshift(log(abs(F))),[])
%imshow(fftshift((abs(F))),[])
title("Figura 12")

% Low pass filter
lowpass=fspecial('gaussian',64,5);
sz = size(f);
LOW=fft2(lowpass,sz(1),sz(2));
nexttile
%imshow(fftshift(log(abs(LOW))),[])
imshow(fftshift((abs(LOW))),[])
title("Figura 13")

nexttile
mesh(fftshift(abs(LOW)))
title("Figura 14")

%
g=conv2(f,lowpass);
nexttile
imshow(g,[])
title("Figura 15")

nexttile
imshow(small)
title('Figure 16 - Small 1')
smallg = imresize(g,0.1,"nearest");

nexttile
imshow(smallg)
title('Figure 17 - Small 2')
zoomg = imresize(smallg,10,"nearest");

nexttile
imshow(zoomg)
title('Figure 18 - Zoomed')
zoomg = imresize(small,10,"nearest");

nexttile
imshow(zoomg)
title('Figure 19 - Zoomed')

% Zoom in fourier (SINC interpolation)
SMALLG = fft2(smallg);
%zomg = abs(ifft2(fftshift(SMALLG),sz(1),sz(2)));
zomg = abs(ifft2(fftshift(SMALLG),500,500));
nexttile
imshow(zomg,[])
title("Figura 20")

% Zoom in fourier (SINC interpolation)
SMALLG = fft2(small);
zomg = abs(ifft2(fftshift(SMALLG),sz(1),sz(2)));
%zomg = abs(ifft2(fftshift(SMALLG),2000,2000));
nexttile
imshow(zomg,[])
title("Figura 21")