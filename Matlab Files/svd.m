close all
clear all
clc

% We need to be able convert the image to matrix form
image = imread('yellow-daisy-lilia-maloratskiy.jpeg');
image = rgb2gray(image);
imagematrix = double(image);

% Getting SVD decomposition of the imagematrix
[P, E, Q] = svd(imagematrix);

% Picking the number of singular values for the compressed image
singularvalues = 21;

% Keeping only # of singular values from above and setting the rest to 0
Ecompressed = E;
Ecompressed(singularvalues:end,:) = 0;
Ecompressed(:,singularvalues:end) = 0;

% Getting the compressed image matrix
imagecompressed = P * Ecompressed * Q';

% Displaying the compressed image
figure;
imshow(uint8(imagecompressed));
title("Image with " + singularvalues + " singular values");

% Initializing the variables used to display the error
errortable = [];
numberofsingularvalues = [];

% For loop that will calculate the difference-squared between the
% compressed image and the original image
for singularvalues = 2:2:400
    disp(singularvalues);
    Ecompressed = E;
    Ecompressed(singularvalues:end,:) = 0;
    Ecompressed(:,singularvalues:end) = 0;
    imagecompressed = P * Ecompressed * Q';
    errormatrix = abs(imagecompressed-imagematrix) ./ abs(imagematrix);
    errormatrix(isinf(errormatrix)|isnan(errormatrix)) = 0;
    error = mean(errormatrix, 'all');
    errortable = [errortable; error];
    numberofsingularvalues = [numberofsingularvalues; singularvalues];
end

% Displaying the error graph
figure;
title('Error in compression');
plot(numberofsingularvalues, errortable);
grid on
xlabel('Number of Singular Values used');
ylabel('Error between compress and original image');