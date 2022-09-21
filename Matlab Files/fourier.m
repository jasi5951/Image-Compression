close all
clear
clc

%Read image from computer, alias as A, convert to grayscale for easier computation

A = imread('pexels-jonas-kakaroto-736230.jpeg');
B = rgb2gray(A);

figure;
imshow(A);
title('Original Image');

%take the 2D fft of the b&w image
BFt = fft2(B);

%use log-scale for fourier coeffs (too small to plot), shift by one for
%plotting errors
BFtlog = log(abs(1+fftshift(BFt)));

figure;
imshow(BFtlog,[]);
title('Fourier Transform');

%Sort the Fourier coefficients by size
BFtsort = sort(abs(BFt(:))); %vectorize, sort largest to smallest
casenum = 1;
%initalize table for display
tblsz = [4 4];
varTypes = ["double","double","double","double"];
varNames = ["Percent Kept", "CR", "MSE", "PSNR"];
eval = table('Size',tblsz,'VariableTypes',varTypes,'VariableNames',varNames);
%initialize figure for compressed img disp
figure
sgtitle('Compressed Images')

%compress images for each percent of "kept" coefficients, calc performance
%indicators and add to table
for keep = [.99 .1 .01 .001]
        
        subplot(2,2,casenum)
        
        keepnum = BFtsort(floor((1-keep)*length(BFtsort)));
        indices = abs(BFt)>keepnum; %find values above keepnum threshold 
        %multiplying indices matix w Fourier coeff matrix will zero out any
        %values below the keep number
        CFt = BFt.*indices;
        C = uint8(ifft2(CFt)); %inverse fourier 2D of C
        imshow(C) %plot
        title(['',num2str(keep*100),'%'])
        
        %Performance Indicators:
        %MSE with Matlab fxn
        MSE = immse(B,C);
        
        %CR - this must be calculated using the number of nonzero entries
        %this is producing a zero CR value for 0.1% compression, why??
        dimB = (size(B,1))*(size(B,2));
        CR = 100*(dimB-keepnum)/dimB;
        
        %find PSNR in dB
        PSNR = 20*log((255^2)/(MSE));
     
        %append table
        tablerow = {keep, CR, MSE, PSNR};
        eval(casenum,:) = tablerow;
    
        casenum = casenum + 1;
end

disp(eval)
imgsz = size(B,1)*size(B,2)
