

location='cifar-10-batches-mat';
[trainingImages, trainingLabels, testImages, testLabels] = helperCIFAR10Data.load(location);
size(trainingImages)
numImageCategories = 10;
categories(trainingLabels)
figure
thumbnails = trainingImages(:,:,:,1:100);
montage(thumbnails)
%% Convolutional Neural Network (CNN) %%

[height,width,numChannels, ~] = size(trainingImages);

imageSize = [height width numChannels];
inputLayer = imageInputLayer(imageSize);
% Convolutional layer parameters
filterSize = [5 5];
numFilters = 32;

middleLayers = [
    

convolution2dLayer(filterSize,numFilters,'Padding',2)



% ReLU layer:
reluLayer()


maxPooling2dLayer(3,'Stride',2)


convolution2dLayer(filterSize,numFilters,'Padding',2)
reluLayer()
maxPooling2dLayer(3, 'Stride',2)

convolution2dLayer(filterSize,2 * numFilters,'Padding',2)
reluLayer()
maxPooling2dLayer(3,'Stride',2)

];
finalLayers = [
    

fullyConnectedLayer(64)


reluLayer

% fully connected layer

fullyConnectedLayer(numImageCategories)

% softmax loss layer and classification layer

softmaxLayer
classificationLayer
];
layers = [
    inputLayer
    middleLayers
    finalLayers
    ]
layers(2).Weights = 0.0001 * randn([filterSize numChannels numFilters]);

% Network training options

opts = trainingOptions('sgdm', ...
    'Momentum', 0.9, ...
    'InitialLearnRate', 0.001, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 40, ...
    'MiniBatchSize', 16, ...
    'Verbose', true);

doTraining = false;

if doTraining
    % Train a network.
    cifar10Net = trainNetwork(trainingImages, trainingLabels, layers, opts);
else
    
    load('rcnnStopSigns.mat','cifar10Net')
end

w = cifar10Net.Layers(2).Weights;

% Better visualization
w = rescale(w);

figure
montage(w)

YTest = classify(cifar10Net, testImages);

% Accuracy Calculation
accuracy = sum(YTest == testLabels)/numel(testLabels)

load('dataTrain.mat');


summary(Pdata)

datacrack = Pdata(:, {'imageFilename','Leaf'});


I = imread(datacrack.imageFilename{1});
I = insertObjectAnnotation(I,'Rectangle',datacrack.Leaf{1},'Leaf','LineWidth',8);

figure
imshow(I)

% Training options

options = trainingOptions('sgdm', ...
    'MiniBatchSize', 16, ...
    'InitialLearnRate', 1e-3, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 100, ...
    'MaxEpochs', 30, ...
    'Verbose', true);


[rcnn,info] = trainRCNNObjectDetector(datacrack, cifar10Net, options, ...
    'NegativeOverlapRange', [0 0.3], 'PositiveOverlapRange',[0.5 1])


testImage = imread('test2.jpeg');
testImage=imresize(testImage,[800,1080]);

[bboxes,score,label] = detect(rcnn,testImage,'MiniBatchSize',128)

[score, idx] = max(score);

bbox = bboxes(idx, :);
annotation = sprintf('%s: (Confidence = %f)', label(idx), score);

outputImage = insertObjectAnnotation(testImage, 'rectangle', bbox, annotation);

figure
imshow(outputImage)

filename = 'RCNN_net.mat';
m = matfile(filename,'Writable',true);
m.rcnn=[];
m.rcnn=rcnn;
m.info=info;
