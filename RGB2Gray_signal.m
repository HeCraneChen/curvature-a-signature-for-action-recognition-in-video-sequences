%Tommuy Mitchel, 2017 tmitchel@jhu.edu

%Imports RGB video as grayscale double array of size  Width X Height X Time
%array

%Input: RGB Video file path (string)

function X = RGB2Gray_signal(RGBfile)
RGB = VideoReader(RGBfile);
total_frames = RGB.Duration*RGB.FrameRate;
for i = 1:total_frames
    Gray(:, :, i) = rgb2gray(read(RGB, i));
    X(:, :, i) = double(Gray(:, :, i));
    
end