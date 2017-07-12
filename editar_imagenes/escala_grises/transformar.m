imagenes = dir(fullfile('input','*.jpg'));

for x = 1:length(imagenes)
    RGB = imread(fullfile('input',imagenes(x).name));
    I = rgb2gray(RGB);
    I = imresize(I,0.5);
    imwrite(I,fullfile('output',imagenes(x).name),'jpg');
end