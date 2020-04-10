function [data] = load_wiki(config)
    rootPath = config.general.rootPath;
    
    dataPath = strcat(rootPath,'data\wiki\raw_features.mat');
    trainsetCatListPath = strcat(rootPath,'data\wiki\trainset_txt_img_cat.list');
    testsetCatListPath = strcat(rootPath,'data\wiki\testset_txt_img_cat.list');
        
    trainCatList = importdata(trainsetCatListPath);
    testCatList = importdata(testsetCatListPath);

    data = {};
    data.train = {};
    data.test = {};
    load(dataPath);
    data.train.text = pre_process(T_tr);
    data.train.cat_list = trainCatList.data;
    data.test.text = pre_process(T_te);
    data.test.cat_list = testCatList.data;
    if strcmp(config.general.image_feature,'VGG19')
        train_image_deep_feature_path = strcat(rootPath, 'data\wiki\wiki_train_img_vgg19.mat');
        test_image_deep_feature_path = strcat(rootPath, 'data\wiki\wiki_test_img_vgg19.mat');
        load(train_image_deep_feature_path);
        load(test_image_deep_feature_path);
        data.train.image = pre_process(train_img);
        data.test.image = pre_process(test_img);
    else
        data.train.image = pre_process(I_tr);
        data.test.image = pre_process(I_te);            
    end

    
end

function[processed_data] = pre_process(raw_data)
    dataSize = size(raw_data,1);
    % Decentralization
    processed_data = raw_data - repmat(mean(raw_data),dataSize,1);
    % Normalize
    processed_data = processed_data * sqrt(diag(1./diag(processed_data'*processed_data)));
    processed_data(isnan(processed_data)==1)=0;
end