% create demo
clc; clear; close all

% creat movie demo
% frames{1} = imread('fixation.jpg');

cd('frames')
files = dir('frame*.jpg');
for ii = 1:length(files)
    temp = imread(['frame', num2str(ii), '.jpg']);
    temp(temp>20) = temp(temp>20)+0.3*(255-temp(temp>20));
    temp(temp<=20) = 0;
    frames{ii} = temp;
end

cd ..
% create the video writer with 1 fps
writerObj = VideoWriter('demoTrial.avi');
writerObj.FrameRate = 80;
% open the video writer
open(writerObj);
% write the frames to the video
for u=1:length(frames)
    % convert the image to a frame
    frame = im2frame(frames{u});
    if u>123
        frameN = 4;
    else
        frameN = 1;
    end
    for v=1:frameN
        writeVideo(writerObj, frame);
    end
end
% close the writer object
close(writerObj);

% % for procedure plot
% fixImg = imread('fixation.jpg');
% dispImg = imread('display.jpg');
% flashImg = imread('flash.jpg');
% respImg = imread('response.jpg');
%
% figure
% fixImg = fixImg+0.3*(255-fixImg);
% imshow(fixImg)
% imwrite(fixImg, 'fixation2.jpg')
%
% figure
% dispImg = dispImg+0.3*(255-dispImg);
% imshow(dispImg)
% imwrite(dispImg, 'display2.jpg')
%
% figure
% flashImg = flashImg+0.3*(255-flashImg);
% imshow(flashImg)
% imwrite(flashImg, 'flash2.jpg')
%
% figure
% respImg(respImg>20) = respImg(respImg>20)+0.3*(255-respImg(respImg>20));
% respImg(respImg<=20) = 0;
% imshow(respImg)
% imwrite(respImg, 'response2.jpg')