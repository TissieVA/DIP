function [detected, highlighted] = detect(im, iteration, gamm, dSize, color)

    if(~exist('iteration', 'var'))
        iteration = 3;
    end
    if(~exist('gamm', 'var'))
        gamm = 5.2;
    end
    if(~exist('dSize', 'var'))
        dSize = 8;
    end
    if(~exist('color', 'var'))
        color = [0,0,1];
    end
    
    
    im_gray = im2gray(im);

    im_blur = imgaussfilt(im_gray, 2);

    %Imadjust maps the intenisty values to a new value
    ia = imadjust(im_blur, [], [], gamm);
    ribs = imdilate(imbinarize(ia, 0.4), strel('sphere', 5));
    ribs = 1- imclose(ribs,strel('disk',10));
    ia2 = ia .* uint8(ribs);
    ed = edge(imbinarize(ia2), 'canny');
    liver = bwconvhull(ed, 'objects');
    liver2 = biggestArea(liver);

    liverIm = im_blur .* uint8(liver2);
    T = graythresh( liverIm);
    binIm = imbinarize( liverIm , T);
    

    for n = 1:iteration
        liverIm = uint8(uint8(binIm) .* liverIm);
        T = thresh(liverIm);

        binIm = (1-imbinarize(liverIm, T) ) .* binIm;
    end

    eroded = imerode(binIm,strel('square', dSize));
    detected = imdilate(eroded, strel('sphere', 20));
    
    subplot(3,2,1);
    imshow(im);
    title('Original image')
    subplot(3,2,2);
    imshow(im_blur);
    title('blurred image')
    subplot(3,2,3)
    imshow(ribs);
    title('ribs')
    subplot(3,2,4)
    imshow(liver);
    title('adjusted mage')
    subplot(3,2,5)
    imshow(ed);
    title('areas')
    subplot(3,2,6)
    imshow(im_blur .* uint8(liver2))
    title('liver')
    pause

    [b, l] = size(detected);
    highlight = cat(3, uint8(detected*255) * color(1), uint8(detected*255) * color(2), uint8(detected*255) * color(3));
    highlighted = highlight + im;
end


function [avg] = thresh(im)
    avg = sum(sum(im)) ./ (sum(sum((im > 0))) * 255);
end

function [BW_out] = biggestArea(BW)

    pieces = regionprops(BW, 'Area', 'PixelList');

    area = cat(1, pieces.Area);
    maxArea = max(area);
    index = find(area == maxArea);
    pixels = regionprops(BW,'PixelList');
    pixels = struct2array(pixels(index,1));
    
    BW_out = zeros(size(BW));
    for i =1:size(pixels,1)
        BW_out(pixels(i,2),pixels(i,1))=1;
    end

end
