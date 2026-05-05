
function pyramid = gaussian_pyramid(I, L, sigma)
    pyramid = cell(L+1, 1);
    pyramid{1} = I;
    h = fspecial('gaussian', [5 5], sigma);
    for l = 2:L+1
        I_blur = imfilter(pyramid{l-1}, h, 'symmetric');
        pyramid{l} = imresize(I_blur, 0.5);
    end
end
