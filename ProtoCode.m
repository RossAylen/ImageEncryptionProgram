clear;clc;

[file,path] = uigetfile('*.*','select image to be encrypted');
image = im2double(imread([path,file]));
figure(4),imshow(image);
sizeOfImage = size(image);

phaseMaskSpatial = phaseMask(sizeOfImage);
phaseMaskFrequency = phaseMask(sizeOfImage);
key = [phaseMaskSpatial phaseMaskSpatial;real(phaseMaskFrequency) imag(phaseMaskFrequency)];

image = image.*phaseMaskSpatial;
image = fftshift(fft2(fftshift(image)));
image = image.*phaseMaskFrequency;

encryptedImage = ifftshift(ifft2(ifftshift(image)));

phaseMaskSpatial = key(1:sizeOfImage(1),1:sizeOfImage(2));
phaseMaskFrequencyReal = key(sizeOfImage(1)+1:2*sizeOfImage(1),1:sizeOfImage(2));
phaseMaskFrequencyImaginary = key(sizeOfImage(1)+1:2*sizeOfImage(1),sizeOfImage(2)+1:2*sizeOfImage(2));
phaseMaskFrequency = complex(phaseMaskFrequencyReal,phaseMaskFrequencyImaginary);

inversePhaseMaskFrequency = exp(-1*log(phaseMaskFrequency));

image = fftshift(fft2(fftshift(encryptedImage)));
image = image.*inversePhaseMaskFrequency;
image = ifftshift(ifft2(ifftshift(image)));
decryptedImage = image./phaseMaskSpatial;

figure(1),imshow(encryptedImage);
figure(2),imshow(decryptedImage);

function x = phaseMask(sizeOfImage)
    x1 = exp(-1i*2*pi*rand(sizeOfImage(1)-1,sizeOfImage(2)/2-1));
    
    for z = 1:(sizeOfImage(1)-2)/2
        x2(z,1) = exp(-1i*2*pi*rand());
    end
    x2 = [x2;rand();conj(flipud(x2))];

    x3 = conj(rot90(x1,2));

    for z = 1:(sizeOfImage(1)-2)/2
        x4(z,1) = exp(-1i*2*pi*rand());
    end
    x4 = [x4;rand();conj(flipud(x4))];

    for z = 1:(sizeOfImage(2)-2)/2
        x5(1,z) = exp(-1i*2*pi*rand());
    end
    x5 = [rand() x5 rand() conj(fliplr(x5))];

    x = [x4 x1 x2 x3];

    x = [x5;x];
end
